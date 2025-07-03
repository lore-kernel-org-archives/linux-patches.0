Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5151C2F0027;
	Thu,  3 Jul 2025 15:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555457; cv=none; b=l2Hi2h6AnogG+eCvPxAU3U2LJKoXgLgUF/zxehSbR/IHm2nJgihDEMKLPk2gmh92YvsXru/owoJibpFLhvCdjVrnphAhq7lJrce0Mgqw3CO0zKMYUFV67jayzCkkAZ9KuY1FJ4uRDldilQQEqHoObRstPPFPJMZSUE2vBS+7eKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555457; c=relaxed/simple;
	bh=S14XEFq2T83V/sqrWH65uJtFDfVfS25vchRJn0YUVb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ut84AO1G71F1hhgyHL+WmAxtzVKJ2DQqu/Sw/665P15NYEHGA1wkqbYlr1e8rCRphWsSwtYS4ULhKt8ZzTOKgk/DQ+WjKTSWIjgdWP46hWcCAxpW6QhqlOliDvDVvgtlyGr66ZcwJALrNc4txzDWDH6hLnsHfVtaodyOxttNyY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIIhm74C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIIhm74C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C8AC4CEE3;
	Thu,  3 Jul 2025 15:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555456;
	bh=S14XEFq2T83V/sqrWH65uJtFDfVfS25vchRJn0YUVb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIIhm74C47uU2WGpZLmXQuBZXYbhznwGPQFN8JjWXNeNAgpyCstlgrw2SKffVsD+a
	 k+UDtwYMf1mu+j9CJAVKd/qY3sCgc5ziAGQ1Zz5ueAdNDKz6J0M63R/Jk/7ov46pHa
	 O2jJJ16sibWmbnqcv/vfgPGa239Qd2PW6PNUTHnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/139] cifs: Fix cifs_query_path_info() for Windows NT servers
Date: Thu,  3 Jul 2025 16:41:05 +0200
Message-ID: <20250703143941.278484252@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 65d4b72b4d51a..9e8e0a01ae8eb 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -320,6 +320,14 @@ check_smb_hdr(struct smb_hdr *smb)
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



