Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD1639B943;
	Fri,  4 Sep 2026 05:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498937; cv=none; b=BkeHntlMRKfE9c8gPfXIy89hf0oEZTttREToOCBxRxjyFRYt37nWnGYm676Pq2SDpVa85MHAJ5OO7oPCppyyb5GkbA8+uUuyoOmlxw6mZB0PJfqFmWX928Ee94pmTWqlO7maJ1Ulk96EiESkqBJyQuQKzgIzlOSJwBeyjPOJAHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498937; c=relaxed/simple;
	bh=X6PWd3ZEb9szOjDa+bdc6qqteKnqzSXhvaq0ejto84w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaaMPtndtLLvVnY+Gq9wYLdmGmdsL/o02TPQSlPRGlCw5pR4kbiVcEcWcIRn235bHhL+Rbeuwhdc2Ez6ZQefl60OtZmHRxdGenNzb34ISx9g5knpMiNJzQ/1QUKvFvqeL975i+Td0z7qPCCDDKzOZIIrU/28p4LpGsqrxe3TVUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9pANMnA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9pANMnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105241F00A3D;
	Fri,  4 Sep 2026 05:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498936;
	bh=tLXaqTsP0zryrDCO6i0Q1dfdVMcxxp/ylqU0Up18ofM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N9pANMnAG1yKRq8H+a8Zg3zVZlxmw07yGnKUNJF5mByPv2pCVimjY0DOhwoqx+IPB
	 OGz2Hx5s5xXD7eXbrF89HXXfeT7j+TvgP/+P8b2UUgOQjg28/spN9BNPRUNcAsFJBD
	 cdo2Zmei1IL2ta+F9E7hyZQuh9aOwPr3BBQaofyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.2 240/713] smb: client: fix copy-paste error in WSL EA length accounting for $LXDEV
Date: Fri,  4 Sep 2026 06:53:28 +0200
Message-ID: <20260904045809.207175072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit 5d14030b46af1a958fd104b020fbb93631c98822 upstream.

The LXDEV block in cifs_query_path_info() uses SMB2_WSL_XATTR_MODE_SIZE
(4) instead of SMB2_WSL_XATTR_DEV_SIZE (8), undercounting eas_len by 4
bytes per $LXDEV EA.

eas_len is used only as a zero/non-zero presence flag so there is no
current functional impact, but the value is incorrect and misleading.

Fixes: 97db41604555 ("smb: client: parse uid, gid, mode and dev from WSL reparse points")
Cc: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb1ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -717,7 +717,7 @@ static int cifs_query_path_info(const un
 			ea->ea_value_length = cpu_to_le16(SMB2_WSL_XATTR_DEV_SIZE);
 			memcpy(&ea->ea_data[0], SMB2_WSL_XATTR_DEV, SMB2_WSL_XATTR_NAME_LEN + 1);
 			data->wsl.eas_len += ALIGN(sizeof(*ea) + SMB2_WSL_XATTR_NAME_LEN + 1 +
-						   SMB2_WSL_XATTR_MODE_SIZE, 4);
+						   SMB2_WSL_XATTR_DEV_SIZE, 4);
 			rc = 0;
 		} else if (rc >= 0) {
 			/* It is an error if EA $LXDEV has wrong size. */


