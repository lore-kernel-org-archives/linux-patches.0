Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824D2189B84;
	Tue, 11 Nov 2025 01:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824973; cv=none; b=H6hdnYxUDyG2JE6p1aUkiPxIJWMGpu3nYI6vnUcpbKzo+ho28TtKUTtw8qy7+50kP/jy3pPHHhspy07xAQLq+OnsR2Rw+6/QjSKQX14KaMnlW03w/TYY2CQnO2MRDqbd5wAmHkkHVc+wycCy4lbvuppXf0zVK5GQwSODt3vSPwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824973; c=relaxed/simple;
	bh=iTaxvizlyUyhgnfEg4YgeWIw9gjea9r/mUuL1gYPfF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+SidSuz2hRAeWSOhsHE3qcBwQLHXMG92um8oVF/uKWExv5bjSaV47vPCSSOmUqjOCVya1POWo+3OcIB/Vd39hiV6V6E8cJehm/q92B3zVPkQ1ouUlF5eD8cA+m2oyLayULNs5dzvZugYIAqdo9mTkXv9khNUKgGYS+GV+r8YPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVByikz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVByikz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24293C116B1;
	Tue, 11 Nov 2025 01:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824973;
	bh=iTaxvizlyUyhgnfEg4YgeWIw9gjea9r/mUuL1gYPfF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVByikz8LoYylFDLSGMkMDcysJzpVVenRU8Do8qOVE5cHcvpw/Q8BsMTXEgJnEqFR
	 5C0ss4KIhtaEgHj2bzX8sC1AnFfnd86wXaHHnXYb5Ejz/VxBYVfB59EF1O3Rhh03Sd
	 276KXVFISvXX8Zz83LIPP+cwOwW+pYZ/QHbCX3Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 6.12 560/565] extcon: adc-jack: Cleanup wakeup source only if it was enabled
Date: Tue, 11 Nov 2025 09:46:56 +0900
Message-ID: <20251111004539.612765492@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 92bac7d4de9c07933f6b76d8f1c7f8240f911f4f upstream.

Driver in the probe enables wakeup source conditionally, so the cleanup
path should do the same - do not release the wakeup source memory if it
was not allocated.

Link: https://lore.kernel.org/lkml/20250509071703.39442-2-krzysztof.kozlowski@linaro.org/
Reported-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Closes: https://lore.kernel.org/r/22aaebb7-553b-4571-8a43-58a523241082@wanadoo.fr/
Fixes: 78b6a991eb6c ("extcon: adc-jack: Fix wakeup source leaks on device unbind")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/extcon/extcon-adc-jack.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -164,7 +164,8 @@ static void adc_jack_remove(struct platf
 {
 	struct adc_jack_data *data = platform_get_drvdata(pdev);
 
-	device_init_wakeup(&pdev->dev, false);
+	if (data->wakeup_source)
+		device_init_wakeup(&pdev->dev, false);
 	free_irq(data->irq, data);
 	cancel_work_sync(&data->handler.work);
 }


