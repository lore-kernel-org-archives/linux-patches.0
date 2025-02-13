Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E1E26B0BF;
	Thu, 13 Feb 2025 15:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459992; cv=none; b=E9uOV7cK8MGeQO7bcGF6KLqyL/T6SYLh/tqE4IWAt9QDnow6gDwQd1Elf/FDLpYN8/1SSpFA5zGrCtYEuocVvAojQYsUtkgjT8FlQJ0c268A0j6XwkNJDhuEqbZ0TrAyZWs1V75vuvDHkSz+dTbyNO0gQFD+Nq1erhsAwZErzYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459992; c=relaxed/simple;
	bh=5JOCB+FJYtACfcJI1x76GbDC9yZbFJvY7G8rK1r+t7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xz6TUGyuC9H6G2tpye4woMQ4w3mWg6deaRj6gXQfU9J0jiKT+C+aVWNFIu0opZ1YtHyqnEUWiihJ6ueh3HL216qCdBUPODZvFTrbCExmQ/gyxGDnczEpRvr0Skci9D0l+2S/n2h7aKx6hAF3ozdj7J00Oow0DEahYOJa271Prk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIOuSHM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIOuSHM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7996AC4CED1;
	Thu, 13 Feb 2025 15:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459991;
	bh=5JOCB+FJYtACfcJI1x76GbDC9yZbFJvY7G8rK1r+t7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIOuSHM8Pqe6nJmY2A0KqTW35KBBbkpOA0RxwklvlCg5S4g0I+Yn7tThNfdhNHf/q
	 fQ3K1D/EJAmtgSPksmwqzR8odA45pmFuHyLPO52BfHP+UmZrMXQtHMPZLJA285Q9ea
	 UVSiQPrv6NpVjkhknq/YrjEO4XtNUHMTabks17vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.13 426/443] pinctrl: samsung: fix fwnode refcount cleanup if platform_get_irq_optional() fails
Date: Thu, 13 Feb 2025 15:29:51 +0100
Message-ID: <20250213142457.059597281@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 459915f55509f4bfd6076daa1428e28490ddee3b upstream.

Commit 50ebd19e3585 ("pinctrl: samsung: drop pin banks references on
error paths") fixed the pin bank references on the error paths of the
probe function, but there is still an error path where this is not done.

If samsung_pinctrl_get_soc_data() does not fail, the child references
will have acquired, and they will need to be released in the error path
of platform_get_irq_optional(), as it is done in the following error
paths within the probe function.

Replace the direct return in the error path with a goto instruction to
the cleanup function.

Cc: stable@vger.kernel.org
Fixes: a382d568f144 ("pinctrl: samsung: Use platform_get_irq_optional() to get the interrupt")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241106-samsung-pinctrl-put-v1-1-de854e26dd03@gmail.com
[krzysztof: change Fixes SHA to point to commit introducing the return
 leading to OF node leak]
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/samsung/pinctrl-samsung.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -1272,7 +1272,7 @@ static int samsung_pinctrl_probe(struct
 
 	ret = platform_get_irq_optional(pdev, 0);
 	if (ret < 0 && ret != -ENXIO)
-		return ret;
+		goto err_put_banks;
 	if (ret > 0)
 		drvdata->irq = ret;
 


