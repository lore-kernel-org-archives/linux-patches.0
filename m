Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EC53C061A;
	Mon, 23 Mar 2026 16:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282615; cv=none; b=ZoLbfx4HBLmRdunta/2kSjVC3DpJYsB9CFiJZe680swdqMHbSs3aIwtEaWJr46jWOobopGdVkN6FH56K7RxfLDCRM9v/WHF7XZy58Fh1bcL7cEibabIpT6x8L255qylsDyCgfQSB2n+DrPFgScd66z4NDMN5t60tdSQJaGAczws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282615; c=relaxed/simple;
	bh=MzRXOGDu5ahx6DmYbckUDAvUPoWgfyeK15nbY41LTJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJWsz1FyPYOIFrE7AVOacBeXncpgIOocqPeAZg3Dei0UCdrL53Xgd8bF5tpc+5kedO08pb/OjpOf/Ur1uUTmbyWrDah/KEpV6Usd57LcyN8i5hPKzdmPT4tBjfsexqj25+QddE5uCKOfcZaCbBHXsqDkyt1eWE523YbcRfSU5Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sEroCZP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sEroCZP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8FCC2BCB4;
	Mon, 23 Mar 2026 16:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282615;
	bh=MzRXOGDu5ahx6DmYbckUDAvUPoWgfyeK15nbY41LTJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEroCZP9uBSLGCmewDmaZw3ZmNocOXyrBm9V+55p5EVj3ysc6a9L6pkGjycNp1x1d
	 O3KrhZ/8MjUWLoMFJNwJbVaYWDsvrG8+nEemOWs4lHSfz1agpL2TnAFUEoVf2aMctM
	 wqfmu79H4K07WlFhOcvRa/Qj9oxWqd2IC0JWIf4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Penghe Geng <pgeng@nvidia.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 221/481] mmc: core: Avoid bitfield RMW for claim/retune flags
Date: Mon, 23 Mar 2026 14:43:23 +0100
Message-ID: <20260323134530.537625594@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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
@@ -440,14 +440,12 @@ struct mmc_host {
 
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
@@ -455,6 +453,9 @@ struct mmc_host {
 	int			rescan_disable;	/* disable card detection */
 	int			rescan_entered;	/* used with nonremovable devices */
 
+	bool			can_retune;	/* re-tuning can be used */
+	bool			retune_now;	/* do re-tuning at next req */
+	bool			retune_paused;	/* re-tuning is temporarily disabled */
 	int			need_retune;	/* re-tuning is needed */
 	int			hold_retune;	/* hold off re-tuning */
 	unsigned int		retune_period;	/* re-tuning period in secs */


