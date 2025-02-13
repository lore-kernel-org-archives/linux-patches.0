Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E6926B094;
	Thu, 13 Feb 2025 14:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458402; cv=none; b=rQ9gSHrSZ/OngWY+fzd18e6ebEdYrgX2BQxmAjUO4RIj6P+FfKEa5ahh58H4l3kVnUHA9FgHo/SSOh4n2o6ENpz3PFPB47oFhdsvBEzjx6FZLX1eALGm9J5Rir80tfKMp/4N+TQWa2xi3YUjJE5UV42wNMoVACrq6/ZpIt7ITmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458402; c=relaxed/simple;
	bh=BibHCe312lSB9tYoz3VBXCy3RLE0gab99xoFoCtUOas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDi6Qr/nK758+4myKP804rxqgOkP4A9cpuGZHjtYaQd+7YJalBXWrrD7YDBbSRznqem02+PD9ywJaUN40eTNKr0Nai1PfBeewUZcGXnsZr/4NU5wJJojA4U2bDBM6d3RwdxeP1Cy2dKNpjmld6YxgE6BGRWeqFfjOmbS1x3iEPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpE8SD3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpE8SD3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B102C4CED1;
	Thu, 13 Feb 2025 14:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458402;
	bh=BibHCe312lSB9tYoz3VBXCy3RLE0gab99xoFoCtUOas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpE8SD3ujF4XUKHWboDjOpvdUqnArpou35ESZQJiXIEcDNXKYJ1fzr/y+qM+bsIg0
	 6aoelGw1GSFrhCWCAo1/bll1tMtG8376pYoDBDy3SgEFTGmq2lQM5CH8qpukKuU5JW
	 SEsf0kaIzDWQ4cfwcabDg2Pnievexnz5m60uaj2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.12 389/422] pinctrl: samsung: fix fwnode refcount cleanup if platform_get_irq_optional() fails
Date: Thu, 13 Feb 2025 15:28:58 +0100
Message-ID: <20250213142451.561298951@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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
 


