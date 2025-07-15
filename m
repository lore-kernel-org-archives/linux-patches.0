Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200FC2E6D0E;
	Tue, 15 Jul 2025 13:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587429; cv=none; b=WxjME6ceUvV0PMliq1VTGob53LqhBjj4t+HV78sBKCaBkog9fIqTweOOtvrhJdU8WvarKVjXKyyCjOdVx/VBdrLNS+3Ssi8uCPOutTFwl57TWoXRLl7BB5eLefFW06/Wlo8cKYR9ZVv1LKkMGlBoRZxYMgI24hjvu3gt39wwezg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587429; c=relaxed/simple;
	bh=/acimN+XRsKyvXcu0M04DznstB79oBxSe8t5b30COPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vrp6P4HEclSwmGteIfE1W9o68geyj0OtoBh8+ew6Lvg0dFbOjmBG0KUg87UztJ6/nshHAysxa9HC0nxAqe8BU9hbd7dDjgr5/nq2ED030S4kksnqHL3oFdtUNT68SQuA5wR8+0kam1+UJqzv1kpuH6yfnfJk0zxL2H+28aZVQuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Ns2/IYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Ns2/IYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1F5C4CEE3;
	Tue, 15 Jul 2025 13:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587429;
	bh=/acimN+XRsKyvXcu0M04DznstB79oBxSe8t5b30COPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Ns2/IYacCDjmL1fCu2lWVksejRcstBfw7xgJ6cKxHRqsJh7D9rRa/tu7N52mcIIh
	 qC6UxnzubJOHsXMCIJ7asYuUgzKy6C9Mo0ln5/owGSoXtJ63gC5aezmXIAcJMUidLK
	 p90g03RcA/hBDnDzvuDs6Hf7o/AgfVNqLdR8zJBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/208] cifs: Fix cifs_query_path_info() for Windows NT servers
Date: Tue, 15 Jul 2025 15:11:50 +0200
Message-ID: <20250715130810.893945345@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2d46018b02839..54c443686daba 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -310,6 +310,14 @@ check_smb_hdr(struct smb_hdr *smb)
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



