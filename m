Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC522E62CD;
	Thu,  3 Jul 2025 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554597; cv=none; b=BBTPniR6KeCLJzIqtGiJ0Nxa6+Eiy7P9u9Y83YbMKs1LwU/0XZ62ez24CitqWcL30FHUW64kFRrl4Tj6SXjM2KsHSgEA62isFHD/23OXJGVlWerGPltm//NlamXzS5FydKdLhi2zBohXdTpip1/IzpJ1vAVL0ifqL7JMLAhkW+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554597; c=relaxed/simple;
	bh=8bcZQofDo4je4SF5yegmTKN/xYY/dIoAcfoBOBJFHq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AzTdcWGsIiDdfm0uDMLCJZVksSPiLgnYYBVEMD+ZYCNKTMO1JveBY3ZOG4qZTOSTPw4uQA8ZkwCdLAyGGy717y5T9+63mzZmUhkSuuzO18qHhpSKi4zSgoJZDlzrtQAVQRY055AEjG0ghbALJhsBzfdeHWRqZESDYo+87bUXK/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfmEJs8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfmEJs8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE29C4CEE3;
	Thu,  3 Jul 2025 14:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554597;
	bh=8bcZQofDo4je4SF5yegmTKN/xYY/dIoAcfoBOBJFHq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfmEJs8mBnRXEyyw2KrKaC/jCDeYGpW8vs6UbNmhNLoSO58IoTUAGJIU7bUm0R4la
	 rzxV9x+hVcENWJOpfB75JEGqx9PVGaiNdPqAWGQqph+lyqrq93oiDFB/aHlJCpZ5Ez
	 pski+BGAmWl069hcqTwGNPkQKo0niVen5aCJpRYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 002/263] cifs: Fix cifs_query_path_info() for Windows NT servers
Date: Thu,  3 Jul 2025 16:38:42 +0200
Message-ID: <20250703144004.378623862@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/client/misc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 7b6ed9b23e713..e77017f470845 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -326,6 +326,14 @@ check_smb_hdr(struct smb_hdr *smb)
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



