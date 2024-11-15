Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD10185924;
	Fri, 15 Nov 2024 07:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731654023; cv=none; b=ob9ZBRhNm1lED3GwoWF0gidWUx/VQr8QLNHphXzzMY9zM0NikoIM4x87sr4Y/7liaTNKwsy6ySHPG6Sfm0MdvZduRMqiiRlu3+sHT5eIJ8YeH4tQ0Iy+anMU/3FEtFw0Qd1VHD8F41SoNLXUmjz0vtnKmwLQeJu/xcJODacNnQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731654023; c=relaxed/simple;
	bh=R87tCKYKDXaehAlone5EF8p2OlGf0vArfKRIAhe3JMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiMg6rNOdp1L6PX8OBXdbBT/K01hBF+CPMvqd/5pz+MMHGgkEBkIN1IknhbBbw7rwg4p7Nsnuvn28JtjSNdskQP3PKbyiXomNjVTQDCb8SXABCM7GlouKmCwe3D7PlU/tHU0aXxbQHzlBNq1TGUO8XkRk1WAVOQwVmMDJwbRZMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnHyYPkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnHyYPkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF84C4CED0;
	Fri, 15 Nov 2024 07:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731654022;
	bh=R87tCKYKDXaehAlone5EF8p2OlGf0vArfKRIAhe3JMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnHyYPknn7Ciou6HWo09dmvUfVLb94BVtKwwrocmNHPsnHwrwijSUoOc//HgDAPJc
	 RM9Via897n1IZXzYdCk65Azc5HqiFunoowKPR+AVBv2S2blsUF3N5xZytGevNVj1bQ
	 j2r4RXD6L5NIOX6my1k09Bv7X38/885hFFQVkpJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+111eaa994ff74f8d440f@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5.15 21/22] udf: Avoid directory type conversion failure due to ENOMEM
Date: Fri, 15 Nov 2024 07:39:07 +0100
Message-ID: <20241115063721.942844477@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit df97f64dfa317a5485daf247b6c043a584ef95f9 upstream.

When converting directory from in-ICB to normal format, the last
iteration through the directory fixing up directory enteries can fail
due to ENOMEM. We do not expect this iteration to fail since the
directory is already verified to be correct and it is difficult to undo
the conversion at this point. So just use GFP_NOFAIL to make sure the
small allocation cannot fail.

Reported-by: syzbot+111eaa994ff74f8d440f@syzkaller.appspotmail.com
Fixes: 0aba4860b0d0 ("udf: Allocate name buffer in directory iterator on heap")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/directory.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -249,9 +249,12 @@ int udf_fiiter_init(struct udf_fileident
 	iter->elen = 0;
 	iter->epos.bh = NULL;
 	iter->name = NULL;
-	iter->namebuf = kmalloc(UDF_NAME_LEN_CS0, GFP_KERNEL);
-	if (!iter->namebuf)
-		return -ENOMEM;
+	/*
+	 * When directory is verified, we don't expect directory iteration to
+	 * fail and it can be difficult to undo without corrupting filesystem.
+	 * So just do not allow memory allocation failures here.
+	 */
+	iter->namebuf = kmalloc(UDF_NAME_LEN_CS0, GFP_KERNEL | __GFP_NOFAIL);
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 		err = udf_copy_fi(iter);


