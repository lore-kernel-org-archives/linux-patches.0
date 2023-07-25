Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC2D1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E22C433C8;
	Tue, 25 Jul 2023 11:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283013;
	bh=IO3r4sVOeSuyitbPXaYBhId+NFd2Hcaf3GdnMr8DJVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3aAyoLOKGTpefF6E6X5R7QpSVEMZ7uurHakO2YsJI3L0tVaA8nzcgwWjZCSrqwd1
	 6RzRnIe3JQ64HoRoalQncWd70/D/CFZZm2XwRhs/RWjTYClcGYl/AmvB/50eWqqQmj
	 iDXW8M52DUKUqPfXW9xPIJ5jmGaBEablS9tsVwvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/183] cifs: fix mid leak during reconnection after timeout threshold
Date: Tue, 25 Jul 2023 12:45:36 +0200
Message-ID: <20230725104511.838451863@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <nspmangalore@gmail.com>

[ Upstream commit 69cba9d3c1284e0838ae408830a02c4a063104bc ]

When the number of responses with status of STATUS_IO_TIMEOUT
exceeds a specified threshold (NUM_STATUS_IO_TIMEOUT), we reconnect
the connection. But we do not return the mid, or the credits
returned for the mid, or reduce the number of in-flight requests.

This bug could result in the server->in_flight count to go bad,
and also cause a leak in the mids.

This change moves the check to a few lines below where the
response is decrypted, even of the response is read from the
transform header. This way, the code for returning the mids
can be reused.

Also, the cifs_reconnect was reconnecting just the transport
connection before. In case of multi-channel, this may not be
what we want to do after several timeouts. Changed that to
reconnect the session and the tree too.

Also renamed NUM_STATUS_IO_TIMEOUT to a more appropriate name
MAX_STATUS_IO_TIMEOUT.

Fixes: 8e670f77c4a5 ("Handle STATUS_IO_TIMEOUT gracefully")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 935fe198a4baf..cbe08948baf4a 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -59,7 +59,7 @@ extern bool disable_legacy_dialects;
 #define TLINK_IDLE_EXPIRE	(600 * HZ)
 
 /* Drop the connection to not overload the server */
-#define NUM_STATUS_IO_TIMEOUT   5
+#define MAX_STATUS_IO_TIMEOUT   5
 
 struct mount_ctx {
 	struct cifs_sb_info *cifs_sb;
@@ -1162,6 +1162,7 @@ cifs_demultiplex_thread(void *p)
 	struct mid_q_entry *mids[MAX_COMPOUND];
 	char *bufs[MAX_COMPOUND];
 	unsigned int noreclaim_flag, num_io_timeout = 0;
+	bool pending_reconnect = false;
 
 	noreclaim_flag = memalloc_noreclaim_save();
 	cifs_dbg(FYI, "Demultiplex PID: %d\n", task_pid_nr(current));
@@ -1201,6 +1202,8 @@ cifs_demultiplex_thread(void *p)
 		cifs_dbg(FYI, "RFC1002 header 0x%x\n", pdu_length);
 		if (!is_smb_response(server, buf[0]))
 			continue;
+
+		pending_reconnect = false;
 next_pdu:
 		server->pdu_size = pdu_length;
 
@@ -1258,10 +1261,13 @@ cifs_demultiplex_thread(void *p)
 		if (server->ops->is_status_io_timeout &&
 		    server->ops->is_status_io_timeout(buf)) {
 			num_io_timeout++;
-			if (num_io_timeout > NUM_STATUS_IO_TIMEOUT) {
-				cifs_reconnect(server, false);
+			if (num_io_timeout > MAX_STATUS_IO_TIMEOUT) {
+				cifs_server_dbg(VFS,
+						"Number of request timeouts exceeded %d. Reconnecting",
+						MAX_STATUS_IO_TIMEOUT);
+
+				pending_reconnect = true;
 				num_io_timeout = 0;
-				continue;
 			}
 		}
 
@@ -1308,6 +1314,11 @@ cifs_demultiplex_thread(void *p)
 			buf = server->smallbuf;
 			goto next_pdu;
 		}
+
+		/* do this reconnect at the very end after processing all MIDs */
+		if (pending_reconnect)
+			cifs_reconnect(server, true);
+
 	} /* end while !EXITING */
 
 	/* buffer usually freed in free_mid - need to free it here on exit */
-- 
2.39.2



