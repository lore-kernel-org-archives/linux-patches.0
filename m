Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7DF4D7D4C;
	Wed, 30 Sep 2026 16:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786931; cv=none; b=WcIpP8BMDApjocML2FOElK+KCQe/7JOSSqOFH7dLnAkjqG8nM8XHFP6raIeKRZj5UH9245NO+zoX6QIHXlx5Q/PII4e/43ctaznTSaX8LhPzf4BhBoZV3rwCKUKl6h/fAaWZe76AGOXOR+0Tl3t5LgJKMJesF6WYsJEPFhY5VLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786931; c=relaxed/simple;
	bh=2QKPdhLLJczD2gfvIGRp/rFUTXf/6P4dD3kYl49ehkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVw/ikYpIy28xAA2O4KTMIIIEZjOa/ZNvAuJ/Maboge3Y62tgpvqGDvY2leGbWY33xCNiYO0FKwR7e8MiMaLfH2FujCxpJ08A0Hf+i9UeTRWTUu7kPRrkOqvO8GGdEXcIM9DWpsFUzEhFjqbq8/XOBiRJEGLYCt80MzT83125ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reFiG9j7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reFiG9j7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9922C1F000FF;
	Wed, 30 Sep 2026 16:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786930;
	bh=+eoYhWjwfjU40dCvEm3Ao3/j+IfUAXjjFY1XuHMuA1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=reFiG9j7zY6p5tUTlpxNC0F4SsnLHCE9whEoAnDKoGEGm8/mCOs+TqQifHpF9dIqM
	 /l55GstJLhp+NrvjBaKvbTk9Jal1I2qtWIX6oa+Bm6/tiOixPe172IYJh4hLPXerM7
	 HyslgUetoV7D6sgxhG1A78dEctiZhZ4MVqvl76xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ran Hongyun <ranhongyun1@huawei.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 050/457] squashfs: Add dictionary size range check to prevent shift-out-of-bounds
Date: Wed, 30 Sep 2026 17:22:35 +0200
Message-ID: <20260930152347.114436082@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Ran Hongyun <ranhongyun1@huawei.com>

[ Upstream commit 1f7745fb3580152ca902ef181b605f33cabfb1d0 ]

When an abnormal SquashFS image (COMP_OPTS flag is 1 but dictionary size
is 0) is mounted, and performs shift operations using dictionarysize, the
shift exponent is -1, causing a shift-out-of-bounds.

Detail as below:
squashfs_comp_opts(msblk, buffer, length)
  squashfs_xz_comp_opts()
    if (comp_opts)
      n = ffs(opts->dict_size) - 1;<----opts->dict_size=0, n=-1
      if (opts->dict_size != (1 << n) && opts->dict_size !=
	  	(1 << n) + (1 << (n + 1))) <----shift-out-of-bounds

Fix it by adding a dictionary size range check before the shift operation.

Fixes: ff750311d30a ("Squashfs: add compression options support to xz decompressor")
Signed-off-by: Ran Hongyun <ranhongyun1@huawei.com>
Link: https://patch.msgid.link/20260713115525.2661734-1-ranhongyun1@huawei.com
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/squashfs/xz_wrapper.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/squashfs/xz_wrapper.c b/fs/squashfs/xz_wrapper.c
index 0a4ff3ec9c8cd..6610af2414493 100644
--- a/fs/squashfs/xz_wrapper.c
+++ b/fs/squashfs/xz_wrapper.c
@@ -57,10 +57,10 @@ static void *squashfs_xz_comp_opts(struct squashfs_sb_info *msblk,
 
 		opts->dict_size = le32_to_cpu(comp_opts->dictionary_size);
 
-		/* the dictionary size should be 2^n or 2^n+2^(n+1) */
+		/* the dictionary size should be positive and 2^n or 2^n+2^(n+1) */
 		n = ffs(opts->dict_size) - 1;
-		if (opts->dict_size != (1 << n) && opts->dict_size != (1 << n) +
-						(1 << (n + 1))) {
+		if (opts->dict_size <= 0 || (opts->dict_size != (1 << n) &&
+			opts->dict_size != (1 << n) + (1 << (n + 1)))) {
 			err = -EIO;
 			goto out;
 		}
-- 
2.53.0



