Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55C7299920;
	Sat, 12 Sep 2026 11:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211780; cv=none; b=uPndsj47ipHysCrTOHywHDIgi7so3/Vcp942sH7jf59kqa01HkILOxcQEpSDZatPWBK+XFimQv2fgDFm3kFmMySU17RReyRmmPvmUkD/0fMs5jlmd1ZOyiyBMjDUZLr5KYpoZuX1MsDsfPHrdz2Mioinn86y0ovcYCG5KWmjZKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211780; c=relaxed/simple;
	bh=WyJSqdKgXUabSNn5FaiChWjsVasVTe/8g7dRIrSKh8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zyi1waWyqXB4IGmlCbkNmd003HRuFhJPNXKh35rsyUZksWCHheULTXAweXnqPIR6orY4qxlEcY4BQM6Q1kINlLu040EzK5vl+3V8hPL+/jFmn525AK10D+FB8cjYHScQRetB9w97g+4dl4/zi28lUj4vSrRkMqmbHHQDLfWS48I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNO5rL45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNO5rL45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003EA1F000FF;
	Sat, 12 Sep 2026 11:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211778;
	bh=QYZYDCtkI4yJIQrBAEL6LQI9TNdtgJclJOZn6KP36MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNO5rL45MaPVVpM5HOeCQx02GsFbX7AWwbcTj1joZr34oXdIJb9x7msQ2znjrfhMd
	 V9KvMxBO20Gy4aMjeMbuPwejLBV5KoVYk2WEbvfe8Pu8gebnkd/knDWBrY2wdIsn41
	 CwHwvWPnrz07zWnzM1CxVOlzyp9xgzVGNT6HUif0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Lusk <clusk@northecho.dev>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1302/1518] smb: client: fix request buffer leak in smb2_new_read_req()
Date: Sat, 12 Sep 2026 08:57:51 +0200
Message-ID: <20260912065652.974182370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Lusk <clusk@northecho.dev>

[ Upstream commit deb6468f4164640e4dc875f008aa449cf55987a5 ]

smb2_new_read_req() allocates the request buffer with
smb2_plain_req_init() but only publishes it to the caller with
*buf = req at the very end of the function. Two error returns sit in
between:

	rc = smb2_plain_req_init(SMB2_READ, io_parms->tcon, server,
				 (void **) &req, total_len);
	if (rc)
		return rc;

	if (server == NULL)
		return -ECONNABORTED;
	[...]
		rdata->mr = smbd_register_mr(server->smbd_conn,
					     &rdata->subreq.io_iter,
					     true, need_invalidate);
		if (!rdata->mr)
			return -EAGAIN;

On either of them the buffer is neither released nor handed back, so
it is leaked. The caller cannot clean up after it: smb2_async_readv()
does 'goto out' on a non-zero return, which skips the
cifs_small_buf_release(buf) at async_readv_out, and buf has not been
assigned at that point in any case.

The write path has never had this problem. smb2_async_writev()
registers the memory region inline and jumps to its release label
instead of returning:

	wdata->mr = smbd_register_mr(...);
	if (!wdata->mr) {
		rc = -EAGAIN;
		goto async_writev_out;
	}

Commit b7972092199f ("cifs: smbd: Retry on memory registration
failure") changed both sides from -ENOBUFS to -EAGAIN in a single
patch, which puts the two shapes next to each other.

Only the -EAGAIN return is reachable in practice, because
smb2_plain_req_init() calls smb2_reconnect() first and that already
fails with -EIO when server is NULL, before anything is allocated.
Both returns are given the same treatment here rather than leaving
one of them correct only by accident.

Because -EAGAIN is a replayable error, the failure also reaches the
retry block at the end of smb2_async_readv(), which marks the
subrequest NETFS_SREQ_NEED_RETRY, so a failing registration can be
retried rather than ending the I/O, and every attempt that reaches it
leaks another buffer. smb2_should_replay() short-circuits on
tcon->retry, so on a hard mount the attempt count is not bounded by
the retrans setting.

Only the asynchronous read path is affected. The synchronous
SMB2_read() caller passes rdata == NULL and the memory registration
block is guarded on rdata.

The memory registration failure path was pointed out by the Sashiko
AI reviewer while it was reviewing an unrelated patch to
smb2_async_readv().

Fixes: bd3dcc6a22a9 ("CIFS: SMBD: Upper layer performs SMB read via RDMA write through memory registration")
Link: https://sashiko.dev/#/patchset/20260729192002.876156-1-clusk%40northecho.dev
Link: https://lore.kernel.org/all/20260729192002.876156-1-clusk@northecho.dev/
Assisted-by: Claude:claude-opus-5
Signed-off-by: Christopher Lusk <clusk@northecho.dev>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5aca5b4a98682..46580d6eab627 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4454,8 +4454,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 	if (rc)
 		return rc;
 
-	if (server == NULL)
-		return -ECONNABORTED;
+	if (!server) {
+		rc = -ECONNABORTED;
+		goto free_req;
+	}
 
 	shdr = &req->hdr;
 	shdr->Id.SyncId.ProcessId = cpu_to_le32(io_parms->pid);
@@ -4486,8 +4488,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 
 		rdata->mr = smbd_register_mr(server->smbd_conn, &rdata->subreq.io_iter,
 					     true, need_invalidate);
-		if (!rdata->mr)
-			return -EAGAIN;
+		if (!rdata->mr) {
+			rc = -EAGAIN;
+			goto free_req;
+		}
 
 		req->Channel = SMB2_CHANNEL_RDMA_V1_INVALIDATE;
 		if (need_invalidate)
@@ -4530,6 +4534,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 
 	*buf = req;
 	return rc;
+
+free_req:
+	cifs_small_buf_release(req);
+	return rc;
 }
 
 static void
-- 
2.53.0



