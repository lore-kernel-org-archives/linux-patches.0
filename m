Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B7B1DA23;
	Thu,  3 Jul 2025 15:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555923; cv=none; b=rV453geSKyv/n/1SZzVt7u233d/wLkq4S/uGqRGCIzBwJ20cSIbx4OvPMT8JKklhdNyMlry1mIaaAlN5euLyYWZ2ZGmUfNeDH0NvuHizsLKpqsGvMxcJUFw3HkvV1JL1L3nNlH3uWayPaoz08F1vlOWYxcY6kxIImIFqORz5+rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555923; c=relaxed/simple;
	bh=FqM7NSlq38pHeafzZPenQjHIN69EYxNhlT6QD1ljiQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QPkfFQlj+UPqNQhlgNzIL46mrRVjAATijJDiC7aWaxXdZX8krLHJswuyDIQDb2GoWUIaeCbbsDolLv1Cmb3Nd8YFPVWceL9DNXbUkpZbEBEts+O76WIdYgmj7KhyKQ0HAk4EorQrsEWmWhwDjUe3cr0dwywn00+YyWbGHpnGGRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8EJtguE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8EJtguE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E1EC4CEE3;
	Thu,  3 Jul 2025 15:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555923;
	bh=FqM7NSlq38pHeafzZPenQjHIN69EYxNhlT6QD1ljiQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8EJtguEsOmg38dbX2DzT69u3gvqjj6qYu/2iE3NM/4IO+hObxIH7WJipolcsfpwM
	 98ZKtv797a5vga3GxduNvf6v9NzIoqGEakdvxN+8lgsgLJO/4Wc83Kw6VIQp3OGrHT
	 xjWx6tELm+MC5DL/lm/Jxgcx7sJfpO77/pZeg3qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/132] cifs: Fix cifs_query_path_info() for Windows NT servers
Date: Thu,  3 Jul 2025 16:41:31 +0200
Message-ID: <20250703143939.480107720@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3826f71766086..99a0a1fe66187 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -307,6 +307,14 @@ check_smb_hdr(struct smb_hdr *smb)
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



