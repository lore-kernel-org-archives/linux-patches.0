Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705623;
	b=VWexKz6LWKn8oDx+X2CB3N7qnZfujLQDrNM4cIA7bKXK5JaS5jDWmhIt42ntEukL++wF
	 Eah1NTj1QJcjHz4/oyPc3ePCxm8sK2RjTEmF12xEk5EFhfc6P10ze8mmqJASoojkUtMnG
	 vT5VEX+txq/ADQTFmBgbO9WQt6SCMtpU14aODlCFmi3HZNCg158OZhnCYA2/w7M1SoMi3
	 VvQtv6GbibfGPo1UfvfpHyShnQAbZ9BdneaHhn6gkkcpuXJnk0KIGGaCa/vrr00UB6AxE
	 0Tz3qHSSBHuT+sJCZ0QiVx5ffbIvU3tbpusxCl71s4AFSDe6L2IWnDEiUJVpjLoQy6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P6DHUe53MG/gTFf9pe1y03bpu5KHwQGEOKK2RUfoo6g=;
	b=GNPFwaThoxCFLgM1iU8qb+kgufSe14KVeBYlAHNAedWylusIWM2GpdNBJvRzcH+nIBBR
	 yNB8FekESEShO2Hoy3rp63ayMJNl+CAj2iKrRNBWlzP/3W4/Yc/PeVHgITk8wHEP2xWAv
	 GKt7vxCxeTjcwwKjeLQTgCZ/7AA4aXQWnAswR+EdPoIt9QHNYtu53t793vUIfs3nC7Bvl
	 q2gUVmNwWucep14gjohUjrx7qhaKIeKIf6wckCuDeE0tifpiogfQyfCyHunXNLuG1uEJp
	 cemkBzpP8vBVbeUqhHEXjO//qkDAn8gCZhgc5CoFPpHOedyoUXTbtS9Q7BdStwGAtNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i9UK6yoV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BA8606A31C;
	Thu, 26 Nov 2026 15:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i9UK6yoV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317451F000C0;
	Thu, 26 Nov 2026 15:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705622;
	bh=P6DHUe53MG/gTFf9pe1y03bpu5KHwQGEOKK2RUfoo6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9UK6yoVONF8BtM2p2SHwIchHCzATLxUntcQ1B5NP5+rIzinOcRHDhp4gUdO6w2QY
	 1byr+Gy2De1Or9DZkk8GPSfmFy15/Eb7zDXRPdzYrH15+dhs/rQ5Uw7kvCHLxzV1xO
	 xBfBNGqPjXwEpqQAZ3DygwYGIq5CnqZZTumk0UP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Nicolas Pitre <npitre@baylibre.com>,
	Kees Cook <kees+treewide@kernel.org>,
	Joshua Rogers <linux@joshua.hu>,
	Chris Mason <mason@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ronan Pigott <ronan@rjp.ie>,
	Liav Mordouch <liavmordouch@gmail.com>
Subject: [PATCH 5.15 258/319] vt: serialise the producers of the flip buffer
Date: Thu, 26 Nov 2026 15:40:26 +0100
Message-ID: <20261126144012.570071957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit 5d1d814408c1c8e797031eac8ddd40de1a9e8e93 upstream.

Typing on a virtual console while the console replies to an escape
sequence can make the kernel write past the end of a buffer. A user who
can write to the foreground console can cause this on purpose if they
can also inject key events, through /dev/uinput or by writing to the
/dev/input/event* node of a keyboard.

Input for a tty goes through the flip buffer of its port. A driver
inserts the data with tty_insert_flip_*() and then calls
tty_flip_buffer_push() to pass it on to the line discipline. The insert
functions take no lock: they check that the current struct tty_buffer
has room, copy the data to offset ->used, and then advance ->used. So a
flip buffer supports only one producer at a time, and a driver that has
several must serialise them.

Four functions feed the flip buffer of a virtual console:

- put_queue(), puts_queue() and fn_send_intr() insert typed characters
  and breaks for the keyboard handler. They run under kbd_event_lock.
- respond_string() inserts the reply when a program writes an escape
  sequence that requests one, such as a cursor position report. It runs
  under the console lock.

The keyboard handler gets its events from the input layer and feeds the
foreground console. Key events that a program writes to /dev/uinput or
to an event node reach it in the same way as typed keys.

The keyboard handler and respond_string() share no lock, so they can
interleave:

    keyboard handler                respond_string()
    ================                ================
    room check passes
                                    room check passes
    memcpy() to offset used
    used += len
                                    memcpy() to offset used
                                    used += len
                                      /* used > size of the buffer */

The room check subtracts ->used from the size, and both are unsigned.
Once ->used exceeds the size, the result wraps, so the check always
passes, and each later insert lands further past the buffer.

Reproduced as root, with keys from a uinput keyboard and cursor position
reports on the same console: KFENCE reported an out-of-bounds write
1,024 bytes past the buffer in under 10 s.

Fix this by taking port->lock, with interrupts disabled, around the
insert and the push in these four functions. kbd_keycode() already takes
port->lock under kbd_event_lock, so this lock ordering is not new.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Nicolas Pitre <npitre@baylibre.com>
Cc: Kees Cook <kees+treewide@kernel.org>
Cc: Joshua Rogers <linux@joshua.hu>
Cc: Chris Mason <mason@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Mingyu Wang <25181214217@stu.xidian.edu.cn>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ronan Pigott <ronan@rjp.ie>
Cc: Liav Mordouch <liavmordouch@gmail.com>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20261027-tty-llm-v1-1-99b0202ae546@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/keyboard.c |    6 ++++++
 drivers/tty/vt/vt.c       |    2 ++
 2 files changed, 8 insertions(+)

--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -320,15 +320,20 @@ int kbd_rate(struct kbd_repeat *rpt)
 
 /*
  * Helper Functions.
+ *
+ * A flip buffer allows one producer at a time, and respond_string() in vt.c
+ * feeds the same one under the console lock. So take the lock of the port.
  */
 static void put_queue(struct vc_data *vc, int ch)
 {
+	guard(spinlock_irqsave)(&vc->port.lock);
 	tty_insert_flip_char(&vc->port, ch, 0);
 	tty_flip_buffer_push(&vc->port);
 }
 
 static void puts_queue(struct vc_data *vc, const char *cp)
 {
+	guard(spinlock_irqsave)(&vc->port.lock);
 	tty_insert_flip_string(&vc->port, cp, strlen(cp));
 	tty_flip_buffer_push(&vc->port);
 }
@@ -583,6 +588,7 @@ static void fn_inc_console(struct vc_dat
 
 static void fn_send_intr(struct vc_data *vc)
 {
+	guard(spinlock_irqsave)(&vc->port.lock);
 	tty_insert_flip_char(&vc->port, 0, TTY_BREAK);
 	tty_flip_buffer_push(&vc->port);
 }
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1834,6 +1834,8 @@ static void csi_m(struct vc_data *vc)
 
 static void respond_string(const char *p, size_t len, struct tty_port *port)
 {
+	/* The keyboard handler feeds the same flip buffer. */
+	guard(spinlock_irqsave)(&port->lock);
 	tty_insert_flip_string(port, p, len);
 	tty_flip_buffer_push(port);
 }


