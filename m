Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4BB2139CD;
	Tue, 30 Jul 2024 16:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355301; cv=none; b=JXkAw8aogVdd5HhdKxY1DMW8PhsivjJqi9jUEnRvli4mk60vDOGISR2aKV9MZ4RA8ZRwW5kt8vLATRnFAi1Y5bf4ohTZk0oparVu+kT/Ds6oTbvcg4tr4QxUCb9WA6cO8AUE1TrrKuU4FN8jZYAquOAduS16TNy/Qyw6yvsQ4mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355301; c=relaxed/simple;
	bh=C/QwaI0rONMMlWOWY57js27V5wxtWLTV2/Ea6Bfp3jU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aJItXRNUffHsughjhrO2zuHiJm7/BOT3G+RVisHGxfHuGfZ9kfKrGNN/eKz/C/6PsJYHtGRF1GmDXxsCiiOlsWWfu3fBScM1hwE8CRihNyom5B6Ej/erDtlS7idIbsAaUL9Mg+aV/24kficJ50MImQ1EPWHjb44EqihwpQNvSlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhjKj2b+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhjKj2b+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E118C32782;
	Tue, 30 Jul 2024 16:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355300;
	bh=C/QwaI0rONMMlWOWY57js27V5wxtWLTV2/Ea6Bfp3jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhjKj2b+ohjQPEmY4l96GktJ0xQj+H4H2PPmqcuVEmTA/wnz8BjumA8iRpIi+e+gM
	 pUxdkV7Z1IgWzjA5feWFv9Irh4/tHFS6QmuS17SKM9KFkKC2+DPKiqzeXvn9VPRTYo
	 8i+NHTGI5p42Z+XMFFk40IGruJ+c0HMMiDBRvBxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/440] firmware: turris-mox-rwtm: Initialize completion before mailbox
Date: Tue, 30 Jul 2024 17:45:14 +0200
Message-ID: <20240730151618.923974778@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 49e24c80d3c81c43e2a56101449e1eea32fcf292 ]

Initialize the completion before the mailbox channel is requested.

Fixes: 389711b37493 ("firmware: Add Turris Mox rWTM firmware driver")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/turris-mox-rwtm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/turris-mox-rwtm.c b/drivers/firmware/turris-mox-rwtm.c
index 98bdfadfa1d9e..c3d49fcc53305 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -499,6 +499,7 @@ static int turris_mox_rwtm_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, rwtm);
 
 	mutex_init(&rwtm->busy);
+	init_completion(&rwtm->cmd_done);
 
 	rwtm->mbox_client.dev = dev;
 	rwtm->mbox_client.rx_callback = mox_rwtm_rx_callback;
@@ -512,8 +513,6 @@ static int turris_mox_rwtm_probe(struct platform_device *pdev)
 		goto remove_files;
 	}
 
-	init_completion(&rwtm->cmd_done);
-
 	ret = mox_get_board_info(rwtm);
 	if (ret < 0)
 		dev_warn(dev, "Cannot read board information: %i\n", ret);
-- 
2.43.0



