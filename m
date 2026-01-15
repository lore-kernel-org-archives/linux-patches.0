Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8592C08AC;
	Thu, 15 Jan 2026 17:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497555; cv=none; b=KoNBrn+ZPeVYYe96MWdVqo/+zCJV3VwvVjutc9soQJNctr+oktwJs764uBA+LTzSKNx7UQ7e7pQdJBrMAAtq5Yk1xT7AiteYYgJ3wFD0FmEuf7wrAAFjd1Qwy609KyWMEPcDEkemWq4nYTD/yK+tcllOZWsjpINKrhBnq/wnRfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497555; c=relaxed/simple;
	bh=heBOUv38ptK+ryuv+7mEStlFukhWYzTw0E9qNdKIPWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOatPtZeKkCFM01JNYNj1lR9znlQR0X7POsADmj9u+PYyAoQ+LE8EYAkWyQlfUW6qqEo+9I9FrMF7BaxAbxuaTqSwbYfypHsDJsmGbHekyMvFqDKakepnNAy8vvW5Z65rpksbiNlHAWh1Rx8XMI6yjaBEUZrTGyxKYZX4Ba0HzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alGRx5tl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alGRx5tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EA9C116D0;
	Thu, 15 Jan 2026 17:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497555;
	bh=heBOUv38ptK+ryuv+7mEStlFukhWYzTw0E9qNdKIPWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alGRx5tlhUX4spNymxqITgAelM0OpIkhXe7Pnq6541HUrhF9tM1e12DzXRh3gmnGy
	 A0vq3DHuvYEQTlLBvDYDQ9tMpHLPt6yAM4eycCT4mPIl91wlFqVRfmaEZlMwqasqsd
	 ZcRt9QYH4cyta7eJLVDuKFTYsoO7L2SjAJX0z9sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/554] mfd: mt6358-irq: Fix missing irq_domain_remove() in error path
Date: Thu, 15 Jan 2026 17:43:08 +0100
Message-ID: <20260115164250.664712677@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 384bd58bf7095e4c4c8fcdbcede316ef342c630c ]

If devm_request_threaded_irq() fails after irq_domain_add_linear()
succeeds in mt6358_irq_init(), the function returns without removing
the created IRQ domain, leading to a resource leak.

Call irq_domain_remove() in the error path after a successful
irq_domain_add_linear() to properly release the IRQ domain.

Fixes: 2b91c28f2abd ("mfd: Add support for the MediaTek MT6358 PMIC")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251118121427.583-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mt6358-irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/mt6358-irq.c b/drivers/mfd/mt6358-irq.c
index 83f3ffbdbb4ca..1129f4ea54529 100644
--- a/drivers/mfd/mt6358-irq.c
+++ b/drivers/mfd/mt6358-irq.c
@@ -262,6 +262,7 @@ int mt6358_irq_init(struct mt6397_chip *chip)
 	if (ret) {
 		dev_err(chip->dev, "Failed to register IRQ=%d, ret=%d\n",
 			chip->irq, ret);
+		irq_domain_remove(chip->irq_domain);
 		return ret;
 	}
 
-- 
2.51.0



