Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8482F562600;
	Wed,  9 Sep 2026 14:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962898; cv=none; b=lRcXJjAtlsM7pKhRIctNgi1n+3jW2cxM15wlr75vhLm+ENbeB5C73y964McLnJDQ/0QmZTXj0/gon6hdokgcNfxB9w2AT/CyGoEYqwHWg4nHLpQVeoSP0PheCAncYUKudscUJFeofjv0Cqx3sa/32aGP1vP3l8f9irqWAwEDWB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962898; c=relaxed/simple;
	bh=pT183lMGRXq9V5yhiVhqJsZr/eyXs4WwsDgPIEIY4Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0bdq1a6dL+p2qDVY2FLyVgz/zG5BznSSQDT41BJkCNh+nZQQwBrmx63UgEMGfeVff4Qj1gEI/zSP0Ar+Nf7vU7HAcculTKg2vylMcdVoMKigNlwUiKigaOshc9WBjo7NK+iV1ZJUNSSdKJc1W8d+H35rSkzVQd03/i3495BodM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SycJIloL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SycJIloL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945441F00A3A;
	Wed,  9 Sep 2026 14:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962897;
	bh=/+/ncy2xSMfAWynsU0kAIcNtVmFg106k2bZwzA2miHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SycJIloL6ZQSM/PCe/etkH32EOEgQARsy3kB5015E6XrJjgELQQrTTa3zMERUgCJ6
	 zjlyCxmqJ7CLZYY6od5jin0TCvC8TJOJCCnMmDR8+nDb6Amyf5LeXsZQ81X3rkbcza
	 NWIpNrcfGQWv0Otc2HVARqZvYbqkSJ9Gs4dsl9BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 449/556] f2fs: fix to avoid move_range and defragment on device_alias file
Date: Wed,  9 Sep 2026 15:42:09 +0200
Message-ID: <20260909134246.382854692@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

commit 1b4db09b7f10895dc1a0bc32704c7de05188fb1d upstream.

It's forbidden to migrate blocks of device alias file.

Cc: stable@kernel.org
Fixes: 128d333f0dff ("f2fs: introduce device aliasing file")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3083,6 +3083,9 @@ static int f2fs_ioc_defragment(struct fi
 	if (f2fs_readonly(sbi->sb))
 		return -EROFS;
 
+	if (IS_DEVICE_ALIASING(inode))
+		return -EOPNOTSUPP;
+
 	if (copy_from_user(&range, (struct f2fs_defragment __user *)arg,
 							sizeof(range)))
 		return -EFAULT;
@@ -3135,7 +3138,8 @@ static int f2fs_move_file_range(struct f
 	if (!S_ISREG(src->i_mode) || !S_ISREG(dst->i_mode))
 		return -EINVAL;
 
-	if (IS_ENCRYPTED(src) || IS_ENCRYPTED(dst))
+	if (IS_ENCRYPTED(src) || IS_ENCRYPTED(dst) ||
+		IS_DEVICE_ALIASING(src) || IS_DEVICE_ALIASING(dst))
 		return -EOPNOTSUPP;
 
 	if (pos_out < 0 || pos_in < 0)


