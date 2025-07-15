Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5FC70831;
	Tue, 15 Jul 2025 13:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586287; cv=none; b=IdABmAWE8DxQUqCMNBy6NytrFrePuWAxvcgWgVg/FeQXPXD1dwAAfEfmm0eWT8lIFSBIRJTVL7PGyMVV2sxPKb58WiaH54GsknxBZBuOnE3mrCjCQmsNNs1jDSrCapP3M35x7H56XI+binzCvxzI4EplcUByOzZbaDB6sueR1VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586287; c=relaxed/simple;
	bh=8D2X9lvGxreTgEibUXyY5aNJw0IJPZc/ZpSvIV97IH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZmGElX31QBamTDfUhDEq2HjPAnC2asUOaqVnAWGIv+d9MbrL881cPnnb0K9YisJH6rboZbLAmpNnj3TWzudA72Y7K8nWUa1uDrqz7TGdoXECFaxyZ6kpMWW58L+rCbiAeN5snw1/31Zz8BPx7feKz0Ke3RJokmPjt6KgtkrcQto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpYomT/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpYomT/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11443C4CEF6;
	Tue, 15 Jul 2025 13:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586287;
	bh=8D2X9lvGxreTgEibUXyY5aNJw0IJPZc/ZpSvIV97IH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpYomT/cVcXudSp5L/SQczmVop2TQr1BUtwepI6YZty8p5nKcTIjflkhQfGbn/n0c
	 u7pLv8c5eeTCOxrcWN3jiKh4Fmx2jRJ6cHPEI/Jcv5XPU9XEC/753dvnX1EwRC1YAo
	 zJD8HNhcF4UE3xTmhf8RhWJJUSjpEnuYRt80R0s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/148] cifs: Fix cifs_query_path_info() for Windows NT servers
Date: Tue, 15 Jul 2025 15:12:03 +0200
Message-ID: <20250715130800.356346177@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index db1fcdedf289a..af9752535dbab 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -306,6 +306,14 @@ check_smb_hdr(struct smb_hdr *smb)
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



