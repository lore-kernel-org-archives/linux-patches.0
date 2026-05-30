Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5696B3112C1;
	Sat, 30 May 2026 18:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164454; cv=none; b=gzEz2CVBUwOICCTlj4r8iyG59rjYkQHFNdzKeJ0PRUIPMbeFQtj/RgBYfiw22zc+PsWSK5zDzW6aG9pI4D+u07xO3ucMkChcyZDC9jm7jKN8BE4gyDRRA8pPAPOO8Hk3PNxyZ/R8LxvSPUCaXPPefV/7E2CaOElHXyuEeNQVhCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164454; c=relaxed/simple;
	bh=4QGSyWTyPijHnGChRCN1MKq9QglkOq35KyPw7cPaN7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/saW/fGZGFzQG0F4C4jra9Vs7kDPBmCd/zsFPBhGDc6tD800+Bf/7VYhtlQSYiu777yIGrKQbrOpTyrsuG+xz3KBA7O30HbRled4kQCP7BwQccZj+yzN8T58yNneUWxM79czmSpuzOC8hCnSf+NphDc4/nCOVW+Ns2CVusKEZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4QNC/pV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4QNC/pV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9281F00893;
	Sat, 30 May 2026 18:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164453;
	bh=yIGQ5hDgLaxNx1Aao9bxHMj+RIA1hfabPRov2fvOFMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4QNC/pV7ZBc0IT/ad7O23g+QxmcYfRCmICWP1+kKFYpf48BSemSu6Nj7EnlvEQqZ
	 a78VyBA/cD7YJX/kfzoUI4PwDbi0nboSIEeFln5AmO0Z2vGG0ag3TtWjmh3H0Z2tW2
	 0RoTVPadcKSrDBN0Exd8RS6yFJVnmMXvfaR7FQ88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 531/776] fs/ntfs3: terminate the cached volume label after UTF-8 conversion
Date: Sat, 30 May 2026 18:04:05 +0200
Message-ID: <20260530160253.930297859@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit a6cd43fe9b083fa23fe1595666d5738856cb261a ]

ntfs_fill_super() loads the on-disk volume label with utf16s_to_utf8s()
and stores the result in sbi->volume.label. The converted label is later
exposed through ntfs3_label_show() using %s, but utf16s_to_utf8s() only
returns the number of bytes written and does not add a trailing NUL.

If the converted label fills the entire fixed buffer,
ntfs3_label_show() can read past the end of sbi->volume.label while
looking for a terminator.

Terminate the cached label explicitly after a successful conversion and
clamp the exact-full case to the last byte of the buffer.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index a9952b0321837..4ba1501119bff 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -958,8 +958,13 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 				      le32_to_cpu(attr->res.data_size) >> 1,
 				      UTF16_LITTLE_ENDIAN, sbi->volume.label,
 				      sizeof(sbi->volume.label));
-		if (err < 0)
+		if (err < 0) {
 			sbi->volume.label[0] = 0;
+		} else if (err >= sizeof(sbi->volume.label)) {
+			sbi->volume.label[sizeof(sbi->volume.label) - 1] = 0;
+		} else {
+			sbi->volume.label[err] = 0;
+		}
 	} else {
 		/* Should we break mounting here? */
 		//err = -EINVAL;
-- 
2.53.0



