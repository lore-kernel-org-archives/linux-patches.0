Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E8147125D;
	Tue, 21 Jul 2026 18:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658368; cv=none; b=R4eXT/pbcM5RLcwHlXcOq5242ts15t4AhUAqcdY4LPLqeVIdczL15aGkL+VkOS63POMpwSI0lFjeg8reueXzLC9AydpG041N1wuXis5+4uMQwM5OQEqHD3RJHoflaGlNSq6vU1aAKqnK9hrim18y92O9TzFANTi7Iejt58hVgqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658368; c=relaxed/simple;
	bh=wA/UN6v9Ca+0HMKr3GZe5fvl1rzDFfFpZP3EmBNtuWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPEvLciEEC101QznTnJ9VhBpVlUQwLsutaVxMCoOAE+Xp1DdttpEKrmRgmbHlkkt/DLDVG7jLZam/e2iKKvITWDK04XrrPhrwfMtyE9QeqND8tgIt3ngNtTzvxJxxAKsf+1hgiOyx7G69Le/zI9/ScXuM3I/lfWplTXy6oIVxcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzspNtv6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzspNtv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C451F000E9;
	Tue, 21 Jul 2026 18:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658367;
	bh=4b0kp9RVdErmjlzHArVPBXvKYCjffqGqaBL3DjeqRkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yzspNtv66jVMq5RkuE+BKkdBNysV7BlEdYLQvAHJj3CVIxXIU0gOjQRNcg8YW6fbq
	 c2tk1u6L9vURIB0mu+CBhNz+7piJV3n/y3aL9VlxaAtvkfRF+Q0dVSIP01ZldPbsok
	 7Qu0YW+KbDFAeon9LoSp/S4pPvvTeDuEaeEmQLVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1073/1611] gpio: mvebu: free generic chips on unbind
Date: Tue, 21 Jul 2026 17:19:49 +0200
Message-ID: <20260721152539.542876705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2b5112e3210ba3..39a7ad6585f251 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1111,6 +1111,7 @@ static void mvebu_gpio_remove_irq_domain(void *data)
 {
 	struct irq_domain *domain = data;
 
+	irq_domain_remove_generic_chips(domain);
 	irq_domain_remove(domain);
 }
 
-- 
2.53.0



