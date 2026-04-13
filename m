Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D40309F1C;
	Mon, 13 Apr 2026 16:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097471; cv=none; b=n17yAhuSg+Ui1//xfnWya6NtirfWq4IrHjDIEPU/O3BXutdJy0qaj11NL3M0X/7TLcmn2FKXc1uG4o1ma1qQZ1Jg60ntdC0zwNqambFwHrPexOzugKqymIaDkmiEOzIziFktlwRI7BKn25QbJlce/HJkQeYH26mCVn0ROCjcjfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097471; c=relaxed/simple;
	bh=m2IOVs2cMLw4UP4GM6ybtRy0tjMrZW7fIoiVzf+vqYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ui3A6+cg3bzbATgVgvTM9CvEkl/RJZoiyivJ+VNfxtV7txatoFqc+mEJgxZySJpQDofFXZdr8sa3y7GFC2riveCilK5ryWrmpT1bdR0uCYKZt3ogL2+bdzFVK90BnYBJ+3x4X/2adScNO8pYMyT5b66nKCWvW8XhYrX+V4Za9fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRvDapsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRvDapsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA14C2BCB0;
	Mon, 13 Apr 2026 16:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097471;
	bh=m2IOVs2cMLw4UP4GM6ybtRy0tjMrZW7fIoiVzf+vqYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRvDapsm9sAvaaDKfpZzeOkwn0rz6OyQWQUK63RKKQ8714bMRERov2+qDEJJ6Fgjy
	 zNWXZtS/zG+JWJZz8mVZ0vB8+5BJMxPK/+azsDHPrirr5iaVlH95NJ0WbugB85cfU6
	 sSy+HVAG7xGSsfo0Q2k4sarxHEAozF5aGSdtcs/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Penghe Geng <pgeng@nvidia.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 149/570] mmc: core: Avoid bitfield RMW for claim/retune flags
Date: Mon, 13 Apr 2026 17:54:40 +0200
Message-ID: <20260413155836.032130628@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Penghe Geng <pgeng@nvidia.com>

commit 901084c51a0a8fb42a3f37d2e9c62083c495f824 upstream.

Move claimed and retune control flags out of the bitfield word to
avoid unrelated RMW side effects in asynchronous contexts.

The host->claimed bit shared a word with retune flags. Writes to claimed
in __mmc_claim_host() or retune_now in mmc_mq_queue_rq() can overwrite
other bits when concurrent updates happen in other contexts, triggering
spurious WARN_ON(!host->claimed). Convert claimed, can_retune,
retune_now and retune_paused to bool to remove shared-word coupling.

Fixes: 6c0cedd1ef952 ("mmc: core: Introduce host claiming by context")
Fixes: 1e8e55b67030c ("mmc: block: Add CQE support")
Cc: stable@vger.kernel.org
Suggested-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Penghe Geng <pgeng@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mmc/host.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -418,14 +418,12 @@ struct mmc_host {
 
 	struct mmc_ios		ios;		/* current io bus settings */
 
+	bool			claimed;	/* host exclusively claimed */
+
 	/* group bitfields together to minimize padding */
 	unsigned int		use_spi_crc:1;
-	unsigned int		claimed:1;	/* host exclusively claimed */
 	unsigned int		doing_init_tune:1; /* initial tuning in progress */
-	unsigned int		can_retune:1;	/* re-tuning can be used */
 	unsigned int		doing_retune:1;	/* re-tuning in progress */
-	unsigned int		retune_now:1;	/* do re-tuning at next req */
-	unsigned int		retune_paused:1; /* re-tuning is temporarily disabled */
 	unsigned int		retune_crc_disable:1; /* don't trigger retune upon crc */
 	unsigned int		can_dma_map_merge:1; /* merging can be used */
 	unsigned int		vqmmc_enabled:1; /* vqmmc regulator is enabled */
@@ -433,6 +431,9 @@ struct mmc_host {
 	int			rescan_disable;	/* disable card detection */
 	int			rescan_entered;	/* used with nonremovable devices */
 
+	bool			can_retune;	/* re-tuning can be used */
+	bool			retune_now;	/* do re-tuning at next req */
+	bool			retune_paused;	/* re-tuning is temporarily disabled */
 	int			need_retune;	/* re-tuning is needed */
 	int			hold_retune;	/* hold off re-tuning */
 	unsigned int		retune_period;	/* re-tuning period in secs */


