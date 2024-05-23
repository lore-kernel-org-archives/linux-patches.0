Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3C814B95C;
	Thu, 23 May 2024 13:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470636; cv=none; b=NZcqz5Qc6l+Ynt33tUhMU2zSivGuZq3amewDYPW7HDDeF19b3oBdsFLh6RaJXwbv6RZZuksWUsK6xixtHil0rPVjGmnCBCgUBrkB2l/NuSrfLl+5bFbX4BU1TgvSjMl6fI2CjFpZjzmqY7yduaF4GTplUQ0PV8dTAglRg+C3Yio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470636; c=relaxed/simple;
	bh=UXZ+pdienlmRZQx1ZOWaLjH6SP2ycljH4kQJuhSh5tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1TEJbyygzcuhLwPvpFNWgdIwL54kdM5pflZA/c2P2L5A6BtM+hvbXRyJgHwambs3HXpKmkw0UQv+kVyfQ81x6+EXozc9ybiN/mNrLIFbYY39Q+D2MwC6CQfex9FALCUsxsVPYvQrDYum/xKX5dIloYYqhNV1hHcLSzA1wvXolE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yr3VYUXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yr3VYUXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289C9C2BD10;
	Thu, 23 May 2024 13:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470636;
	bh=UXZ+pdienlmRZQx1ZOWaLjH6SP2ycljH4kQJuhSh5tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yr3VYUXO2xaqLGk+tsTS74oxMgtMAEfh/MLnBkV+VC90ckgeygyt1XeW1teES0mkq
	 +zSueefCDH6y0pVseJ4krSFkB0P1OJXAnSPdRP29HVW5ML5rdj9qAAJ4w5LQmsq8fa
	 8kAszKnNxmVpXXOljaDGQ3eiTB68pzH7PpnPzt5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/102] cifs: set replay flag for retries of write command
Date: Thu, 23 May 2024 15:13:00 +0200
Message-ID: <20240523130343.788482941@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 4cdad80261862c8cdcbb5fd232aa713d0bdefe24 ]

Similar to the rest of the commands, this is a change
to add replay flags on retry. This one does not add a
back-off, considering that we may want to flush a write
ASAP to the server. Considering that this will be a
flush of cached pages, the retrans value is also not
honoured.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h | 1 +
 fs/smb/client/file.c     | 1 +
 fs/smb/client/smb2pdu.c  | 4 +++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 479bf0d9ad589..8fbdb781d70a6 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1515,6 +1515,7 @@ struct cifs_writedata {
 	struct smbd_mr			*mr;
 #endif
 	struct cifs_credits		credits;
+	bool				replay;
 };
 
 /*
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index f41804245fca1..6d44991e1ccdc 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3413,6 +3413,7 @@ cifs_resend_wdata(struct cifs_writedata *wdata, struct list_head *wdata_list,
 			if (wdata->cfile->invalidHandle)
 				rc = -EAGAIN;
 			else {
+				wdata->replay = true;
 #ifdef CONFIG_CIFS_SMB_DIRECT
 				if (wdata->mr) {
 					wdata->mr->need_invalidate = true;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 6a5d478b3cef6..c73a621a8b83e 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4801,7 +4801,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	struct cifs_io_parms *io_parms = NULL;
 	int credit_request;
 
-	if (!wdata->server)
+	if (!wdata->server || wdata->replay)
 		server = wdata->server = cifs_pick_channel(tcon->ses);
 
 	/*
@@ -4886,6 +4886,8 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	rqst.rq_nvec = 1;
 	rqst.rq_iter = wdata->iter;
 	rqst.rq_iter_size = iov_iter_count(&rqst.rq_iter);
+	if (wdata->replay)
+		smb2_set_replay(server, &rqst);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (wdata->mr)
 		iov[0].iov_len += sizeof(struct smbd_buffer_descriptor_v1);
-- 
2.43.0



