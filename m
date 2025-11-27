Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38454333743;
	Thu, 27 Nov 2025 14:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255512; cv=none; b=YWIX9RJZFZf9knaxiIjR4uer1WFIaVk3zRrPKZ2k5swBm4uQtNZj0pQCw92WGQCaUngbSNjU1yDq3oyAoc62T5sA2eHvoZHG8er/E0xPvXd3b/nl8Ar8NMpSuY5EizT9pv3eJXYRtaVt0xFthvIzCTC8BNizDhb80HRVp5lnqAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255512; c=relaxed/simple;
	bh=v/Yh4KM6WZxAKJ/U4oKp2qB4nePblDwNZdCp+K8HmCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgMF8fOn06w6jdNhi9nVtZ+zhWFzGhbv4Z6jAliyyI4xNlQi1jzR7eOCJh0O3F+TOKFEHD7mRmsJzFIZktxXAjfftrsUcLDh1zDF3Be+lSAShScCuMiI7vzSjrngsnQw1SRO1vfgS2mDKI7jzd7Jr1gZBy4uhZTPgCzEsdinNPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKDyVGuM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKDyVGuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A207C4CEF8;
	Thu, 27 Nov 2025 14:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255511;
	bh=v/Yh4KM6WZxAKJ/U4oKp2qB4nePblDwNZdCp+K8HmCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKDyVGuM6zltSxLe6B4flpZQ09Ry6ine7NVSoiNJqiIifCbTaVVVkytmidJ53gVo1
	 ESTMrm6x8JLURZToVjKXmEzSwWMQpdGIFl1Jct2hmNVsYT5wIdb8TZrmRvT4f88WSu
	 1NrlkshCCxXnJeH1M9x2Xb29WUzrYs9ttBjmAmp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.17 019/175] exfat: check return value of sb_min_blocksize in exfat_read_boot_sector
Date: Thu, 27 Nov 2025 15:44:32 +0100
Message-ID: <20251127144043.661635994@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit f2c1f631630e01821fe4c3fdf6077bc7a8284f82 upstream.

sb_min_blocksize() may return 0. Check its return value to avoid
accessing the filesystem super block when sb->s_blocksize is 0.

Cc: stable@vger.kernel.org # v6.15
Fixes: 719c1e1829166d ("exfat: add super block operations")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Link: https://patch.msgid.link/20251104125009.2111925-3-yangyongpeng.storage@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -423,7 +423,10 @@ static int exfat_read_boot_sector(struct
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
 	/* set block size to read super block */
-	sb_min_blocksize(sb, 512);
+	if (!sb_min_blocksize(sb, 512)) {
+		exfat_err(sb, "unable to set blocksize");
+		return -EINVAL;
+	}
 
 	/* read boot sector */
 	sbi->boot_bh = sb_bread(sb, 0);


