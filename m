Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82FA1EA91;
	Tue, 27 May 2025 16:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364503; cv=none; b=DXf6nKGBsCPQrCp5DnmX94Wz7RT2hSW8s/wruaYSJXPCjQM4i07O5yuegQLZIHpUi/wii3Az7X7x6P4xpztrAXPV4wis/nkrMgbRq4dEiu15+W0hqaI0weEv5XQEohU/S2/L8JgrYi1Q3Y9Umi22UPyaCyzCvyaKa9Pb10CbM7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364503; c=relaxed/simple;
	bh=vwXe7r75HAsetmAS6BFo3c5jC8/J/uxQMFREJz4bqPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xx/SZgXlfZnIr6v9cgDwLo6w5uKw56dp0DuyBV3Vfs0KPbjisFmEZsglfIVIULL+6xX+Y7ZiaWIPyXLGUQMrP396Qt6liWzIt24On/jr/USNwKZEMmqFjqOkcKeHL8bRquB+YD8vD6wAQEnQjzmHS7ZmorWvqiDXx4VgiWllA/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRuqmIvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRuqmIvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46811C4CEE9;
	Tue, 27 May 2025 16:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364503;
	bh=vwXe7r75HAsetmAS6BFo3c5jC8/J/uxQMFREJz4bqPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRuqmIvErFvH8Iv6kzBgnw0AuM1Nu207inCfoTirErej6BRjLWrB2kECp226p9jTf
	 OmBtlwaPtiGuYQwhP0exDXNdskAD7OZvKbqsMIjUYBUXslfnoM1O9rrKN6v3JvUttY
	 RzMNQhObcQEQxrghcjx3EKsm6gxT84uTSSCfSjjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/626] cifs: Add fallback for SMB2 CREATE without FILE_READ_ATTRIBUTES
Date: Tue, 27 May 2025 18:19:00 +0200
Message-ID: <20250527162446.973299415@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit e255612b5ed9f179abe8196df7c2ba09dd227900 ]

Some operations, like WRITE, does not require FILE_READ_ATTRIBUTES access.

So when FILE_READ_ATTRIBUTES is not explicitly requested for
smb2_open_file() then first try to do SMB2 CREATE with FILE_READ_ATTRIBUTES
access (like it was before) and then fallback to SMB2 CREATE without
FILE_READ_ATTRIBUTES access (less common case).

This change allows to complete WRITE operation to a file when it does not
grant FILE_READ_ATTRIBUTES permission and its parent directory does not
grant READ_DATA permission (parent directory READ_DATA is implicit grant of
child FILE_READ_ATTRIBUTES permission).

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index e836bc2193ddd..b313c128ffbab 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -107,16 +107,25 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 	int err_buftype = CIFS_NO_BUFFER;
 	struct cifs_fid *fid = oparms->fid;
 	struct network_resiliency_req nr_ioctl_req;
+	bool retry_without_read_attributes = false;
 
 	smb2_path = cifs_convert_path_to_utf16(oparms->path, oparms->cifs_sb);
 	if (smb2_path == NULL)
 		return -ENOMEM;
 
-	oparms->desired_access |= FILE_READ_ATTRIBUTES;
+	if (!(oparms->desired_access & FILE_READ_ATTRIBUTES)) {
+		oparms->desired_access |= FILE_READ_ATTRIBUTES;
+		retry_without_read_attributes = true;
+	}
 	smb2_oplock = SMB2_OPLOCK_LEVEL_BATCH;
 
 	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
 		       &err_buftype);
+	if (rc == -EACCES && retry_without_read_attributes) {
+		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
+		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
+			       &err_buftype);
+	}
 	if (rc && data) {
 		struct smb2_hdr *hdr = err_iov.iov_base;
 
-- 
2.39.5



