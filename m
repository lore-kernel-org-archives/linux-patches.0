Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B0614A632;
	Thu, 23 May 2024 13:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470642; cv=none; b=ond+XwkMNPjFxC0C3YsDSB1uVAQeNafnbkHeAmNkz8LeaQmAAPoTf+mtaesycT9wRE2yggiZoLEo6ZY7RPzmtGAdcqhQYqgBGaPOI1vUlplcuHdx5LE5dJYoou2txGcwAC4+/otdcJ8xLyGm854nYouEzgSDwiOtgFKs93DvziE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470642; c=relaxed/simple;
	bh=1SwK/Pf9m5NbgwGq3XxstDS6INia0n606YKpJdLuarI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUxvOVrLxl70xrIdYLjCL1uFfHDcNqif5upmAvNBHeSGQVe5PTqI/K78W3TCgyVe9EnyOO4lTKQ84O7xLy//y7gG0mj+RtyJnaW84wYZPlTKcYxmvVEUir8ctqGv1YsLFQdC1hzpOt148wnqtdcrEgxP62CVWaZVs9+jetx4yWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMgk6gBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMgk6gBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191DFC32781;
	Thu, 23 May 2024 13:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470642;
	bh=1SwK/Pf9m5NbgwGq3XxstDS6INia0n606YKpJdLuarI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMgk6gBlCk8ERGXoeOxrPnyKU1HUWtYSy/PhBq8tv/Hf2nAFI3lf8KXk2izEloUaF
	 C8VBcMrkRoRgAP5mVocWvWIO6hApBNEMlwr284oq+/D+Gf+/j67nNb98S4d8ijWQZW
	 W438bPUMp7tq4M5GKtPqGdx+CL6fdM2gAMTUFSBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/102] cifs: update the same create_guid on replay
Date: Thu, 23 May 2024 15:13:02 +0200
Message-ID: <20240523130343.864572440@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 79520587fe42cd4988aff8695d60621e689109cb ]

File open requests made to the server contain a
CreateGuid, which is used by the server to identify
the open request. If the same request needs to be
replayed, it needs to be sent with the same CreateGuid
in the durable handle v2 context.

Without doing so, we could end up leaking handles on
the server when:
1. multichannel is used AND
2. connection goes down, but not for all channels

This is because the replayed open request would have a
new CreateGuid and the server will treat this as a new
request and open a new handle.

This change fixes this by reusing the existing create_guid
stored in the cached fid struct.

REF: MS-SMB2 4.9 Replay Create Request on an Alternate Channel

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c |  1 +
 fs/smb/client/cifsglob.h   |  1 +
 fs/smb/client/smb2ops.c    |  4 ++++
 fs/smb/client/smb2pdu.c    | 10 ++++++++--
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index ca0fd25236ef4..0ff2491c311d8 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -243,6 +243,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 				   FILE_READ_EA,
 		.disposition = FILE_OPEN,
 		.fid = pfid,
+		.replay = !!(retries),
 	};
 
 	rc = SMB2_open_init(tcon, server,
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 8fbdb781d70a6..181e9d5b10f92 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1382,6 +1382,7 @@ struct cifs_open_parms {
 	struct cifs_fid *fid;
 	umode_t mode;
 	bool reconnect:1;
+	bool replay:1; /* indicates that this open is for a replay */
 };
 
 struct cifs_fid {
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 06735c5685bf6..23cf6e92fd54c 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1204,6 +1204,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
 		.fid = &fid,
+		.replay = !!(retries),
 	};
 
 	rc = SMB2_open_init(tcon, server,
@@ -1570,6 +1571,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, create_options),
 		.fid = &fid,
+		.replay = !!(retries),
 	};
 
 	if (qi.flags & PASSTHRU_FSCTL) {
@@ -2296,6 +2298,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
 		.fid = fid,
+		.replay = !!(retries),
 	};
 
 	rc = SMB2_open_init(tcon, server,
@@ -2684,6 +2687,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
 		.fid = &fid,
+		.replay = !!(retries),
 	};
 
 	rc = SMB2_open_init(tcon, server,
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c73a621a8b83e..60793143e24c6 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2421,8 +2421,13 @@ create_durable_v2_buf(struct cifs_open_parms *oparms)
 	 */
 	buf->dcontext.Timeout = cpu_to_le32(oparms->tcon->handle_timeout);
 	buf->dcontext.Flags = cpu_to_le32(SMB2_DHANDLE_FLAG_PERSISTENT);
-	generate_random_uuid(buf->dcontext.CreateGuid);
-	memcpy(pfid->create_guid, buf->dcontext.CreateGuid, 16);
+
+	/* for replay, we should not overwrite the existing create guid */
+	if (!oparms->replay) {
+		generate_random_uuid(buf->dcontext.CreateGuid);
+		memcpy(pfid->create_guid, buf->dcontext.CreateGuid, 16);
+	} else
+		memcpy(buf->dcontext.CreateGuid, pfid->create_guid, 16);
 
 	/* SMB2_CREATE_DURABLE_HANDLE_REQUEST is "DH2Q" */
 	buf->Name[0] = 'D';
@@ -3159,6 +3164,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	/* reinitialize for possible replay */
 	flags = 0;
 	server = cifs_pick_channel(ses);
+	oparms->replay = !!(retries);
 
 	cifs_dbg(FYI, "create/open\n");
 	if (!ses || !server)
-- 
2.43.0



