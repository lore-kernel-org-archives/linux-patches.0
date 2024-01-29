Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C0715A493;
	Mon, 29 Jan 2024 17:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548056; cv=none; b=Nw8qGkciUfdwW2Qm5d+GsfiUaIzdRNAtTfPvbv36rRyP0pwLE6hCXRsOvCw4QoCy3AObf3oMTrdG/tH04OlG242Ok+LrbAmStxflkiwMVoMFZhy+EU60JoAXSt5Z2bK5iEfWPm6TNolAWk+p+aIgtYRbOh/Bmz5uMpwwS6orkPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548056; c=relaxed/simple;
	bh=9E25CHUt8bmpbIyDYyPbVCTQ7zcaFU4YQerk5DKwzGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahczjMJghjIZRJBTmjkGTZjObnhcfDS7Lw6g4RXnFvWarEhGP6tX/4m6/5AUE3UuTzFfVluwm/Jj3z78viFAu5WCaIrXkt3hAbdESm5n9BO4HEzR+QiywMdkyMZLF2Rm4Kmr5DB+JItHO1x6k1ybcNkxNbYWI0MWhV0FjbhUj6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5WrPsbR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5WrPsbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B30C433F1;
	Mon, 29 Jan 2024 17:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548056;
	bh=9E25CHUt8bmpbIyDYyPbVCTQ7zcaFU4YQerk5DKwzGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5WrPsbRIIpe3fUcTo/9aFwVV0OARDKYSjR1p+SRomVx8JNAf0su4XTq7GwHeYiRS
	 xum2jJ5iCGsj0ABRsC9csDqcn2xR7Knli8kMOfeGeMQXroj/YhpujVH1IXes2bsftS
	 e/RzubdWu0VnopW1dSJ4nTYu0d3qJW2rKeblcs5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.7 035/346] soc: fsl: cpm1: qmc: Fix rx channel reset
Date: Mon, 29 Jan 2024 09:01:06 -0800
Message-ID: <20240129170017.417415658@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit dfe66d012af2ddfa566cf9c860b8472b412fb7e4 upstream.

The qmc_chan_reset_rx() set the is_rx_stopped flag. This leads to an
inconsistent state in the following sequence.
    qmc_chan_stop()
    qmc_chan_reset()
Indeed, after the qmc_chan_reset() call, the channel must still be
stopped. Only a qmc_chan_start() call can move the channel from stopped
state to started state.

Fix the issue removing the is_rx_stopped flag setting from
qmc_chan_reset()

Fixes: 3178d58e0b97 ("soc: fsl: cpm1: Add support for QMC")
Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20231205152116.122512-4-herve.codina@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/fsl/qe/qmc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/soc/fsl/qe/qmc.c
+++ b/drivers/soc/fsl/qe/qmc.c
@@ -685,7 +685,6 @@ static void qmc_chan_reset_rx(struct qmc
 		    qmc_read16(chan->s_param + QMC_SPE_RBASE));
 
 	chan->rx_pending = 0;
-	chan->is_rx_stopped = false;
 
 	spin_unlock_irqrestore(&chan->rx_lock, flags);
 }


