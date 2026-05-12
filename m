Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E2B3EDE55;
	Tue, 12 May 2026 17:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608691; cv=none; b=F0U4a/WKENGNan1xRYrfHRoH2Ny52J4nIAYbQXdVtrcb0J4wmT0iuMWPzhSUp2J7Q2iuDkLWQQvbM0hMieiOhH2wvKKXuX2qp+bVGzNAjPFQCpJLpedKIlpu53V/sPjplXtFtelNXymYwLefJ+DVHfsUYvZY6XW27tD6hmB6+mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608691; c=relaxed/simple;
	bh=xrgGPfVcEQVHf38jQNTJhAE8KoECk9NfyZBArdpP/Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6nDFUB08n8heY/UPNjgim8Gr6DITth7D5oA4GyH0qJtzmmIs/Jp8UR6UApUGqz04pIQUHrhmC1MyWQoGYf6qx45vEOjZghveUVbaj/+Ygo2X6OINieSuQcOHo7fUmfTehx3hW61ibIgPnDjoEWNMz5ud5omkvaLKCvJXLa5S2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eal1saLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eal1saLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A20C2BCB0;
	Tue, 12 May 2026 17:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608690;
	bh=xrgGPfVcEQVHf38jQNTJhAE8KoECk9NfyZBArdpP/Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eal1saLxjwfkV5xdjYWNixhSAjsy3MwJ8zPrc7BaQ+m++CbIbljYRhcBfYPCrL+L8
	 Bo/ipd5W3zF1MTX0S0uG1mHJNEkYUxbCK1/Q33Rm1UZi6T7mocm+fRtF/qoexhOxpx
	 SHk/W4YTTgShKbDusi0QcMBmYVHK4EC2HhxKuRhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Zisen Ye <zisenye@stu.xidian.edu.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 178/270] smb/client: fix out-of-bounds read in symlink_data()
Date: Tue, 12 May 2026 19:39:39 +0200
Message-ID: <20260512173942.196645539@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -240,7 +240,8 @@ smb2_check_message(char *buf, unsigned i
 	if (len != calc_len) {
 		/* create failed on symlink */
 		if (command == SMB2_CREATE_HE &&
-		    shdr->Status == STATUS_STOPPED_ON_SYMLINK)
+		    shdr->Status == STATUS_STOPPED_ON_SYMLINK &&
+		    len > calc_len)
 			return 0;
 		/* Windows 7 server returns 24 bytes more */
 		if (calc_len + 24 == len && command == SMB2_OPLOCK_BREAK_HE)


