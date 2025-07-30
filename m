Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10079276058;
	Wed, 30 Jul 2025 09:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868778; cv=none; b=DFIzd2qHu7Ws772LYU9YFZiOBvdUl58vFJC98X4nWxKuznB4AlXj5//iCo+XWJBDHk0szbdMFousuX+6k51rRRc/t6SDxDueRMfw1au0SG/yIkpIG2vIV/qAiAXmCVf7JiYanMe0tA9l+ZTm/mf1KrV6SxUVVoYeFDkjuJkEDqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868778; c=relaxed/simple;
	bh=kG7nQef9EJmn/DA+QVrqGMf53QA4l6040bMMUNiQDvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1KrPaJYZa+MZEoHHAlaZkKi6781wzTivcAO7oEuHo1GNDr7FrAiSeP/lnKzWvmrnufMfmraVyTL2iE84JBou6y7d4Jz55L/X/TAoV4Qkz3Q1hHohJG1jgYQXggLJDp9XHV2dMYBJtm/tsT3pjmX/BllMSpjG4+4ZVqW1lJVjc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNOAg+H8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNOAg+H8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51092C4CEF5;
	Wed, 30 Jul 2025 09:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868777;
	bh=kG7nQef9EJmn/DA+QVrqGMf53QA4l6040bMMUNiQDvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNOAg+H8uIAIahIA21NaJmZCwDG0ZnzJcLJD0McAt6lO5U9jpJWNTqu/dUUmqM7cA
	 3z3diRpcdILv261kx63we4aSxxGGGtu37+aYVhcP+MWEM3nyhyHY0eLjF3aaNFqgms
	 n1pSlImpn4PgoVmsg0ABCLwqBKG57YZmdQDy2tSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khairul Anuar Romli <khairul.anuar.romli@altera.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 072/117] spi: cadence-quadspi: fix cleanup of rx_chan on failure paths
Date: Wed, 30 Jul 2025 11:35:41 +0200
Message-ID: <20250730093236.341291268@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Khairul Anuar Romli <khairul.anuar.romli@altera.com>

commit 04a8ff1bc3514808481ddebd454342ad902a3f60 upstream.

Remove incorrect checks on cqspi->rx_chan that cause driver breakage
during failure cleanup. Ensure proper resource freeing on the success
path when operating in cqspi->use_direct_mode, preventing leaks and
improving stability.

Signed-off-by: Khairul Anuar Romli <khairul.anuar.romli@altera.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/89765a2b94f047ded4f14babaefb7ef92ba07cb2.1751274389.git.khairul.anuar.romli@altera.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1931,11 +1931,6 @@ static int cqspi_probe(struct platform_d
 
 	pm_runtime_enable(dev);
 
-	if (cqspi->rx_chan) {
-		dma_release_channel(cqspi->rx_chan);
-		goto probe_setup_failed;
-	}
-
 	pm_runtime_set_autosuspend_delay(dev, CQSPI_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_get_noresume(dev);


