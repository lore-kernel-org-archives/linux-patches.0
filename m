Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD306F099;
	Mon, 29 Jan 2024 17:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548467; cv=none; b=lv5qskQWFBNeCnJgCoNCoYIC6jh+rnl8w/hl78AbtTGwFhwioZdrxrkHZksqtNuMhfIdiP9TA9roBpzF8LduUf7l7t7CayKJUxWqmty6BBB+yCMHzFiNWUdaMwZEBcfDYlzNY7yAt0E0xMekgnYVdR/o44K2YV3j8Ogfa2rCizA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548467; c=relaxed/simple;
	bh=LxhnoQ9pmTIMG8/ruWseSOD7kkAsw1DGzZe48MZBk+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJ7tzMqf/OqfRwHjjtT/Qmfd4HL2SrKOTSHmly7yg2MVNXDbL7HUiNVdfgokS4ZAyR+xdHMg9sOIADl7kRIGz5C8ONW7il1RBJGgyj5RgNxuvuDRCD1aD0CSP/y3oMoj0N10zOJ+XRs6Ye3D3OJh2dOjEeLN9TOFLsh8gQGL3J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2POFRB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2POFRB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87212C43394;
	Mon, 29 Jan 2024 17:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548467;
	bh=LxhnoQ9pmTIMG8/ruWseSOD7kkAsw1DGzZe48MZBk+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2POFRB7XaurWFS97/UpJrj12Mn00W+qIeAguMVRoGgl8MHufscOCL5wOUST5T3zS
	 z6N/NjZLRQrxj6z1paI6Cqkd5tekEn8mOuVCkjwlAZh5uaxkjbSAsdJSbfJXhtcypj
	 qDqi3zdJq09D0rxsGZ5PHiA0+842RATbQoKLCVlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.6 058/331] soc: fsl: cpm1: qmc: Fix rx channel reset
Date: Mon, 29 Jan 2024 09:02:02 -0800
Message-ID: <20240129170016.627332509@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/soc/fsl/qe/qmc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/soc/fsl/qe/qmc.c b/drivers/soc/fsl/qe/qmc.c
index 3f3de1351c96..2312152a44b3 100644
--- a/drivers/soc/fsl/qe/qmc.c
+++ b/drivers/soc/fsl/qe/qmc.c
@@ -685,7 +685,6 @@ static void qmc_chan_reset_rx(struct qmc_chan *chan)
 		    qmc_read16(chan->s_param + QMC_SPE_RBASE));
 
 	chan->rx_pending = 0;
-	chan->is_rx_stopped = false;
 
 	spin_unlock_irqrestore(&chan->rx_lock, flags);
 }
-- 
2.43.0



