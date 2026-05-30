Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC93366567;
	Sat, 30 May 2026 17:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160532; cv=none; b=ExlBrKF0TfZSuDrU42Rg2QWXpKNjHQCNlvNnjNuo9NBW/VsnnA9W9oRtBUv4lx7GficD1hVnJpH3lFiw+27pCHduysgHTEf//KZdOydqDlQpGOMuyNZ7hgRN71FTk/B1xxigAHcnKsyKi+1EmRz8lAIAn15+iymuw5zxqdkaaWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160532; c=relaxed/simple;
	bh=IWe57j2BwzCseIT50aSApPf0FT6+sSpRfQnu+C8F1EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Up/Ls2gn1S9C9HfUzd3mMxznNpD8ICXG02TEU5EvDmclK7/Anzn54cdbndW5ZB+cJ+K+leTzyDmQ8ji8iMb6lNPGayeDz1nuRxSMSKf6/bzPGNYHCjKTn9WUcpbRZvld4M3+XMm4A24vz78QRsqLfnrEno4ePNECBuLcSDA2ZBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTFXdJ9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTFXdJ9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681591F00893;
	Sat, 30 May 2026 17:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160531;
	bh=pd/nJDIBL5eNMDYEnYsDsJAIqSz3p1QB+1ficqHxUCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZTFXdJ9Zn3ZiSV+MoJAnjCawpL39q7pOULm/VZWKzh8AqMmN+Y2GvVEOtnEaL1X2Q
	 CcmuaPqcDxfaPR4xLtUUh7jvChWLTyehiRUeNjA4KWKLQmiRW+54dAE4CidW3G+1di
	 z0HUohtC45xpPO7+F+fObii4h7wQMMMUjpdbmsh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Zisen Ye <zisenye@stu.xidian.edu.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 363/969] smb/client: fix out-of-bounds read in symlink_data()
Date: Sat, 30 May 2026 17:58:07 +0200
Message-ID: <20260530160310.353792080@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zisen Ye <zisenye@stu.xidian.edu.cn>

commit d62b8d236fab503c6fec1d3e9a38bea71feaca20 upstream.

Since smb2_check_message() returns success without length validation for
the symlink error response, in symlink_data() it is possible for
iov->iov_len to be smaller than sizeof(struct smb2_err_rsp). If the buffer
only contains the base SMB2 header (64 bytes), accessing
err->ErrorContextCount (at offset 66) or err->ByteCount later in
symlink_data() will cause an out-of-bounds read.

Link: https://lore.kernel.org/linux-cifs/297d8d9b-adf7-42fd-a1c2-5b1f230032bc@chenxiaosong.com/
Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Cc: Stable@vger.kernel.org
Signed-off-by: Zisen Ye <zisenye@stu.xidian.edu.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2misc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -239,7 +239,8 @@ smb2_check_message(char *buf, unsigned i
 	if (len != calc_len) {
 		/* create failed on symlink */
 		if (command == SMB2_CREATE_HE &&
-		    shdr->Status == STATUS_STOPPED_ON_SYMLINK)
+		    shdr->Status == STATUS_STOPPED_ON_SYMLINK &&
+		    len > calc_len)
 			return 0;
 		/* Windows 7 server returns 24 bytes more */
 		if (calc_len + 24 == len && command == SMB2_OPLOCK_BREAK_HE)


