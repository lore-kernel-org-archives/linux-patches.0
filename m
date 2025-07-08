Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6727D2E5402;
	Tue,  8 Jul 2025 16:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991816; cv=none; b=oUgvM4AieM6pEoHTJ79QPMVNo4yWg+vcnAd2RbiAntHjkJmEqT+Ma7Z86m6tKiYdpprnSvZbQdrO0Yg/8sIMsPzUd448QE1jyAr8ZkzEVQG+NK9Iil1AQP+VF97N48t9eVAnqXKi0BGm6Q5eXlt3hK9uoRIpFCv87mg+ToslkEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991816; c=relaxed/simple;
	bh=+ARDM9Q4KtLUK6crXAwDlt883u5NGOA4Foezbbv8Wrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CMu3qNWgPlOcQ6i+0ZLxaUA2pv1p+00+siySOd9mA3lfaPdeN3d3du8HlCFyMalqh2Z53CZPt8pEmYQzMsmqNSYGUdOUhNQ50Z/QrCIf9n6b3YHSZIhUsEkOh6+e3KUOQ8Zi4v6uYN0qjRuJllPaQzRTI2Jqz4lwWgHztgQNWbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIy5aElr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIy5aElr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8498C4CEED;
	Tue,  8 Jul 2025 16:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991816;
	bh=+ARDM9Q4KtLUK6crXAwDlt883u5NGOA4Foezbbv8Wrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIy5aElrO15FxnQkGtnn96Ia5WteB6QWabC1rBysN/IBhUyPEMc0cPHr4u8rCbfcj
	 pTQuPE04H4MF6FJ5dd+Fz/UU5T9Ymy/rVHmU8zVau3TqBMr6kMc185+KCqGBGBVo3V
	 wl6iO7Xj3b7QK18gqrsdIM08YqnWxHi8iR85BOxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/160] cifs: Fix cifs_query_path_info() for Windows NT servers
Date: Tue,  8 Jul 2025 18:20:38 +0200
Message-ID: <20250708162231.546525086@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit a3e771afbb3bce91c8296828304903e7348003fe ]

For TRANS2 QUERY_PATH_INFO request when the path does not exist, the
Windows NT SMB server returns error response STATUS_OBJECT_NAME_NOT_FOUND
or ERRDOS/ERRbadfile without the SMBFLG_RESPONSE flag set. Similarly it
returns STATUS_DELETE_PENDING when the file is being deleted. And looks
like that any error response from TRANS2 QUERY_PATH_INFO does not have
SMBFLG_RESPONSE flag set.

So relax check in check_smb_hdr() for detecting if the packet is response
for this special case.

This change fixes stat() operation against Windows NT SMB servers and also
all operations which depends on -ENOENT result from stat like creat() or
mkdir().

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/misc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 33328eae03d7a..a3d37e7769e61 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -297,6 +297,14 @@ check_smb_hdr(struct smb_hdr *smb)
 	if (smb->Command == SMB_COM_LOCKING_ANDX)
 		return 0;
 
+	/*
+	 * Windows NT server returns error resposne (e.g. STATUS_DELETE_PENDING
+	 * or STATUS_OBJECT_NAME_NOT_FOUND or ERRDOS/ERRbadfile or any other)
+	 * for some TRANS2 requests without the RESPONSE flag set in header.
+	 */
+	if (smb->Command == SMB_COM_TRANSACTION2 && smb->Status.CifsError != 0)
+		return 0;
+
 	cifs_dbg(VFS, "Server sent request, not response. mid=%u\n",
 		 get_mid(smb));
 	return 1;
-- 
2.39.5



