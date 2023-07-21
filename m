Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF521F942
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F4DC433C8;
	Fri, 21 Jul 2023 16:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956523;
	bh=hrvnTgoiPi+IitK04ZY9FdFYKizfHMuobWjkr2ZqftE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5HQhFtWf9dqgPjJUwxnrmURkHbCO6C+NafnT4sz4idqVMg/pADSQLDXM6iuNqNDC
	 qbUl/TEYZB6HQgewkNrzRBK/kG78ehHCbiLZBwv2lMpRMe/0+XMd6K7uhRoHSFNKyP
	 ItsBAcoMOY4btLJCrkJJv0gTlhJqxqbuK25kJN9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hui Li <caelli@tencent.com>
Subject: [PATCH 6.4 218/292] tty: fix hang on tty device with no_room set
Date: Fri, 21 Jul 2023 18:05:27 +0200
Message-ID: <20230721160538.240003333@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hui Li <caelli@tencent.com>

commit 4903fde8047a28299d1fc79c1a0dcc255e928f12 upstream.

It is possible to hang pty devices in this case, the reader was
blocking at epoll on master side, the writer was sleeping at
wait_woken inside n_tty_write on slave side, and the write buffer
on tty_port was full, we found that the reader and writer would
never be woken again and blocked forever.

The problem was caused by a race between reader and kworker:
n_tty_read(reader):  n_tty_receive_buf_common(kworker):
copy_from_read_buf()|
                    |room = N_TTY_BUF_SIZE - (ldata->read_head - tail)
                    |room <= 0
n_tty_kick_worker() |
                    |ldata->no_room = true

After writing to slave device, writer wakes up kworker to flush
data on tty_port to reader, and the kworker finds that reader
has no room to store data so room <= 0 is met. At this moment,
reader consumes all the data on reader buffer and calls
n_tty_kick_worker to check ldata->no_room which is false and
reader quits reading. Then kworker sets ldata->no_room=true
and quits too.

If write buffer is not full, writer will wake kworker to flush data
again after following writes, but if write buffer is full and writer
goes to sleep, kworker will never be woken again and tty device is
blocked.

This problem can be solved with a check for read buffer size inside
n_tty_receive_buf_common, if read buffer is empty and ldata->no_room
is true, a call to n_tty_kick_worker is necessary to keep flushing
data to reader.

Cc: <stable@vger.kernel.org>
Fixes: 42458f41d08f ("n_tty: Ensure reader restarts worker for next reader")
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Hui Li <caelli@tencent.com>
Message-ID: <1680749090-14106-1-git-send-email-caelli@tencent.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_tty.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -203,8 +203,8 @@ static void n_tty_kick_worker(struct tty
 	struct n_tty_data *ldata = tty->disc_data;
 
 	/* Did the input worker stop? Restart it */
-	if (unlikely(ldata->no_room)) {
-		ldata->no_room = 0;
+	if (unlikely(READ_ONCE(ldata->no_room))) {
+		WRITE_ONCE(ldata->no_room, 0);
 
 		WARN_RATELIMIT(tty->port->itty == NULL,
 				"scheduling with invalid itty\n");
@@ -1697,7 +1697,7 @@ n_tty_receive_buf_common(struct tty_stru
 			if (overflow && room < 0)
 				ldata->read_head--;
 			room = overflow;
-			ldata->no_room = flow && !room;
+			WRITE_ONCE(ldata->no_room, flow && !room);
 		} else
 			overflow = 0;
 
@@ -1728,6 +1728,17 @@ n_tty_receive_buf_common(struct tty_stru
 	} else
 		n_tty_check_throttle(tty);
 
+	if (unlikely(ldata->no_room)) {
+		/*
+		 * Barrier here is to ensure to read the latest read_tail in
+		 * chars_in_buffer() and to make sure that read_tail is not loaded
+		 * before ldata->no_room is set.
+		 */
+		smp_mb();
+		if (!chars_in_buffer(tty))
+			n_tty_kick_worker(tty);
+	}
+
 	up_read(&tty->termios_rwsem);
 
 	return rcvd;
@@ -2281,8 +2292,14 @@ more_to_be_read:
 		if (time)
 			timeout = time;
 	}
-	if (old_tail != ldata->read_tail)
+	if (old_tail != ldata->read_tail) {
+		/*
+		 * Make sure no_room is not read in n_tty_kick_worker()
+		 * before setting ldata->read_tail in copy_from_read_buf().
+		 */
+		smp_mb();
 		n_tty_kick_worker(tty);
+	}
 	up_read(&tty->termios_rwsem);
 
 	remove_wait_queue(&tty->read_wait, &wait);


