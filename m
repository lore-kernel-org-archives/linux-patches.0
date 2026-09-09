Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271BE562600;
	Wed,  9 Sep 2026 14:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962901; cv=none; b=ttdDFt/yY77GvZ1mNf9fnkVM0qGhm2Rvc4DAIq/qMtHJ17LkBTSpqDb3u2daw/PdBSq9JmY23uonyeHvJdirYkluaTKN+D79DV3PfbztSZWFASAKMVvMctRx2/+nJFx8Igvo7zfg3SjXVjROlSWQ4qK5ToNkc2UUWvMDeAzVF0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962901; c=relaxed/simple;
	bh=Jofqa7l9QOZyOI/ldXovhXufx2BcAzxPl8syZOdMYJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0gJ6+sCV8ZBUQjfaYzFB90ghNn/H1so2CBCKi0WQVldQJBQqgs2bIgsGdl8nM0V/Gc70D9cwwSexclPTAznUmHv9Le2SSZQxjssM2mgyKrmX1Vm9xNoLbt9Ky9GnrI97xxHDBmI586bUjDGTnVgiB7wT81skG3uHZmx2rrRars=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0IMHevsE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0IMHevsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B101F00A3A;
	Wed,  9 Sep 2026 14:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962900;
	bh=VCRi98SlIR6YvC+73hPCy3wAAlB8JmnuGMxBaifm4JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0IMHevsE0F8KgKXwYEjBrj2zS6lXQc0cKOSfHMY9ggKBXlKRFXMWbatLbetuxZR0p
	 MIzus5p+Czh9U/RbPBXvBgDridRk/FG2Hl73GF0fAiSaa9LnQ87Dg8VVuRByg2j1vp
	 uOYchq3vylYWMJuzwX0Ly0tmV5+T5i1ICOOWdL5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 450/556] f2fs: validate MOVE_RANGE destination size
Date: Wed,  9 Sep 2026 15:42:10 +0200
Message-ID: <20260909134246.413485893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Wenjie Qi <qwjhust@gmail.com>

commit e533889fc26aea0cd83c90327063f272061dd820 upstream.

F2FS_IOC_MOVE_RANGE checks the source range, but not the destination end
before updating i_size. A source hole can expose this: __clone_blkaddrs()
skips NULL_ADDR entries and returns success, so the caller can still extend
the destination inode with unchecked pos_out + len.

Reject destination overflow and use inode_newsize_ok() before extending
the destination inode.

Fixes: 4dd6f977fc77 ("f2fs: support an ioctl to move a range of data blocks")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3124,8 +3124,9 @@ static int f2fs_move_file_range(struct f
 	struct inode *dst = file_inode(file_out);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(src);
 	struct f2fs_lock_context lc;
-	size_t olen = len, dst_max_i_size = 0;
-	size_t dst_osize;
+	size_t olen = len;
+	loff_t dst_max_i_size = 0;
+	loff_t dst_osize, dst_end;
 	int ret;
 
 	if (file_in->f_path.mnt != file_out->f_path.mnt ||
@@ -3183,8 +3184,15 @@ static int f2fs_move_file_range(struct f
 	}
 
 	dst_osize = dst->i_size;
-	if (pos_out + olen > dst->i_size)
-		dst_max_i_size = pos_out + olen;
+	if (olen > LLONG_MAX - pos_out)
+		goto out_unlock;
+	dst_end = pos_out + olen;
+	if (dst_end > dst->i_size) {
+		ret = inode_newsize_ok(dst, dst_end);
+		if (ret)
+			goto out_unlock;
+		dst_max_i_size = dst_end;
+	}
 
 	/* verify the end result is block aligned */
 	if (!IS_ALIGNED(pos_in, F2FS_BLKSIZE) ||


