Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAAC1BD519;
	Tue,  2 Jul 2024 17:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941016; cv=none; b=SQiYKTKmDPoTb5rujFk5kbIpACAE+dpAYecTVusNv3CeNH29X1nTwjPcIYP+fX+rKD5251YYCqB91+3zJp797CNrD5MB+fwr+xxkr5tiwnXGemMmfYhoZwya72zd/ILjocMsIwL/fCS9T1n6zXLK4/EZzotBBQ/hDb13DDWaMh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941016; c=relaxed/simple;
	bh=4rdTcDv5+fJUy3BXLGvT6m0H5RmfGAzvkCBFuNB7CwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdcVMCQdicWXZIxusdOXZGUoEbWnrEj+rkXm2jF6X5CxdpeEUnmfzIrGTzRDjXn1mDWd4+7ZeLUHtXh0lvj3HB1sCAWdXeFMwefaD14+L+WMuW00z2g5Td5qaDzMdpCp/FnHNNDwcxTPrr7ailqMXWCy5PdKMiyP8MFRSu7DVDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bi1codYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bi1codYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D887C116B1;
	Tue,  2 Jul 2024 17:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941015;
	bh=4rdTcDv5+fJUy3BXLGvT6m0H5RmfGAzvkCBFuNB7CwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bi1codYv22drX6Rz1RFlHqr8/vFBbmikCIPgxLebDLHERs1kj6/hHZAQFGywNRku9
	 ieZ3wj9W/sxwUA9CHtJlYzO+gKSI4UKBawzrZu0jMh8f2NrVVUDPPpT+4anSpT+EOE
	 QldxDlFC1R87Dybekz3qAnrIwmfO6k45pbWE/jYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/163] gpio: davinci: Validate the obtained number of IRQs
Date: Tue,  2 Jul 2024 19:03:06 +0200
Message-ID: <20240702170235.790978440@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 7aa9b96e9a73e4ec1771492d0527bd5fc5ef9164 ]

Value of pdata->gpio_unbanked is taken from Device Tree. In case of broken
DT due to any error this value can be any. Without this value validation
there can be out of chips->irqs array boundaries access in
davinci_gpio_probe().

Validate the obtained nirq value so that it won't exceed the maximum
number of IRQs per bank.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: eb3744a2dd01 ("gpio: davinci: Do not assume continuous IRQ numbering")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Link: https://lore.kernel.org/r/20240618144344.16943-1-amishin@t-argos.ru
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-davinci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 8db5717bdabe5..aa3ce8aa99dc8 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -225,6 +225,11 @@ static int davinci_gpio_probe(struct platform_device *pdev)
 	else
 		nirq = DIV_ROUND_UP(ngpio, 16);
 
+	if (nirq > MAX_INT_PER_BANK) {
+		dev_err(dev, "Too many IRQs!\n");
+		return -EINVAL;
+	}
+
 	chips = devm_kzalloc(dev, sizeof(*chips), GFP_KERNEL);
 	if (!chips)
 		return -ENOMEM;
-- 
2.43.0



