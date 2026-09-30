Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1521736826E;
	Wed, 30 Sep 2026 19:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796376; cv=none; b=rXxjpcCQ350LtSoo9pPs2vmgWy+xiFE6QH5cU52uhK/5s2CKS5EUUib+FbzrQcecnU9+nkq9pFDBei/khOSgyb9NjJfsCKcRWiHV5OwkwMnjodZ1ROUKeKBP65tkUnoEiRHiukOxRCG3Zf9Pkgk5oiNnURjMdz2pkHtlz7qtMSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796376; c=relaxed/simple;
	bh=qbcNqgkA+JXz/GgQWZBuR7jlIXXty3Vz4saHEm01Xnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNVIBtCNu/HOAipQ9fIuZO1Ufh9gBbN/eM3aSeCL4bqCGydBr12uLW9d30aTlbq9pNCwegNdDL/SrqyGlTblkwYczaYnLqZWvt8miO0A5ZEoXEHoq+XWl5Zv24qeNyxd8h67PdrhWGoEq/SnRLeW2U8tNm+Fue/nhR2Y4OV8x9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5i1cBmm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5i1cBmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306EE1F000FF;
	Wed, 30 Sep 2026 19:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796374;
	bh=2hfG6AilvT5XMjE50PyLAN9eoeJxllVH3rZiQdhszDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y5i1cBmmofIiHr4Ch7TOnqSioAT18s5GevsCO5YUqyicuve0kAy+OrDpgRHX3Gpiv
	 2r57kKuIN30Bx45KvWSl3bifbghUqFMG7ALUtbshBQhXTM1fbQkHVebAqym6PelPfd
	 oQkvqZsxvhaMl0IwbLHym7slpiZvSW3PcaUJhH3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0890/1193] mmc: sh_mmcif: initialize IRQ-thread mutex before requesting interrupt
Date: Wed, 30 Sep 2026 17:26:14 +0200
Message-ID: <20260930152454.020325487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit d5ea0d226e8f0801d78702142a124d78c317d822 upstream.

The threaded IRQ handler can run before devm_request_threaded_irq()
returns, but thread_lock was initialized afterwards. Initialize it before
requesting either interrupt.

Fixes: 8047310ee984 ("mmc: sh_mmcif: fix a race, causing an Oops on SMP")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sh_mmcif.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1423,6 +1423,7 @@ static int sh_mmcif_probe(struct platfor
 	host->pd = pdev;
 
 	spin_lock_init(&host->lock);
+	mutex_init(&host->thread_lock);
 
 	mmc->ops = &sh_mmcif_ops;
 	sh_mmcif_init_ocr(host);
@@ -1483,8 +1484,6 @@ static int sh_mmcif_probe(struct platfor
 		}
 	}
 
-	mutex_init(&host->thread_lock);
-
 	ret = mmc_add_host(mmc);
 	if (ret < 0)
 		goto err_clk;


