Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF00A3A1A3F;
	Sat, 17 Oct 2026 17:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259177; cv=none; b=hqaiV8hcJnId4qrWbGA9lYRZEJjjyjn2BSdJTiBLlx23Nw/H28eqV3j9o/Klua2Kq3cSFMmAH+ATh95YhoSbCG+U4x3mMrZ+igEfALUqEHxKX7Tcc8Y7UUhDlJDbqwIzMgcuac+KcRCmNqn0l8vl7rGgtroVUgBixmuM4iJW9AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259177; c=relaxed/simple;
	bh=5Qpi7Q8+xjK2vffO16S+l4080rLZDB8EFGMcZssc/nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3FdzDnFRIxAP/qxbQwf7JKOblnoNpAdeAZ3mddrEIyiH7vZW3P6VBidp+nQIpSp35m3vsxxdPbd75aaEnE1PbUCcDE33qYrY6l5fvH2azuc1SL8OW0Jv+tJfFWCEgrVeQ2ROhRYEgLIA1vZgd0Bg1aYuGDvqebXf5gIbRmwgKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fugXlVpV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fugXlVpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DDC1F000C5;
	Sat, 17 Oct 2026 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259176;
	bh=zjKQAlK0dBkcyjGNFeD6k/64Rh13ybYPBWzluKKL+Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fugXlVpVh+pK8a3dA+qTnijfx/LUV84zKqdbmShuP81qmciqRt6q31IKEJTSGLU4m
	 MjP32DBCcLLE0mHKwzO5dYHqqC3M7XKpCMMKFVg/yqkoEEH2QfeBMlgMw2QhhZLxNh
	 h5HvrXLcFK/MalOuQA6w1NjMsfOil+r5PG5GmRsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1127/1674] gpio: mvebu: free generic chips on unbind
Date: Sat, 17 Oct 2026 17:56:39 +0200
Message-ID: <20261017160500.088968073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit b11c513ad943f35cf5e8007d3a56279c79b7ed4b ]

irq_alloc_domain_generic_chips() allocates generic chip data that must
be freed via irq_domain_remove_generic_chips(). The devres action
mvebu_gpio_remove_irq_domain() only called irq_domain_remove(), which
only frees the generic chips if IRQ_DOMAIN_FLAG_DESTROY_GC is set.
Call irq_domain_remove_generic_chips() explicitly before
irq_domain_remove() instead.

Fixes: 812d47889a8e ("gpio/mvebu: Use irq_domain_add_linear")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20260707232358.1218077-1-rosenp@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index f58f835d0acb3..4eb0c78067145 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1116,6 +1116,7 @@ static void mvebu_gpio_remove_irq_domain(void *data)
 {
 	struct irq_domain *domain = data;
 
+	irq_domain_remove_generic_chips(domain);
 	irq_domain_remove(domain);
 }
 
-- 
2.53.0



