Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D325179A3;
	Fri, 24 Apr 2026 13:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037762; cv=none; b=hoHgsIDSVqoAjhCVx8fAW4RWMJdmNhATU3fMdHz5kaUwhMw5brq1md7725PiEnsnYebK5+UP01vD7oElDwmeLCIFwduGuxzXIoDZbsgDuh+R1FrcZ4EyWKLbOI4ez+bJmeeU9PPq6wmuZ8xw/YcmKe3RhDZ1iFDt54ZGL6qJRic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037762; c=relaxed/simple;
	bh=6hsNkATFhzBn4NQhhxDNtioIqXHprq2sI+GJ3d2bdo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNgBX6d3RLerdg2ppdi5QBfV2N4RRWy1Zv6qHLt/bOlBtjXyaZg3Roa05mLrcnZPbNVUJTztv5vb8klyGEMeCewd8zC6izsaXxt+8J3iqvccy5e0UwB9sC+kxchKv/LMSROJEUVxL1sUUVSyTxRqjxUIZc4dfbwIOWg/jACPzX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mu9Yuteh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mu9Yuteh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76CEC19425;
	Fri, 24 Apr 2026 13:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037762;
	bh=6hsNkATFhzBn4NQhhxDNtioIqXHprq2sI+GJ3d2bdo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mu9YutehFjVk29FfP0TUOKedyKuyJoRr9TTLOZouJwdkRkz/ALBQez0en3o/Het/Q
	 1VV66oE3b1Gok0zpE8j3EP1ZGC+fVeUrFfUzs+vshbc4AHl8Spd6oN3Y5hKr7rZT9V
	 E1lzk/62ynEJRb6Jg9sJv7PuN08XByIp/2tWND58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/166] gpio: tegra: fix irq_release_resources calling enable instead of disable
Date: Fri, 24 Apr 2026 15:29:34 +0200
Message-ID: <20260424132545.320152784@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

[ Upstream commit 1561d96f5f55c1bca9ff047ace5813f4f244eea6 ]

tegra_gpio_irq_release_resources() erroneously calls tegra_gpio_enable()
instead of tegra_gpio_disable(). When IRQ resources are released, the
GPIO configuration bit (CNF) should be cleared to deconfigure the pin as
a GPIO. Leaving it enabled wastes power and can cause unexpected behavior
if the pin is later reused for an alternate function via pinctrl.

Fixes: 66fecef5bde0 ("gpio: tegra: Convert to gpio_irq_chip")
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Link: https://patch.msgid.link/20260407210247.1737938-1-samasth.norway.ananda@oracle.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
index ea715582bcf34..dc2a4d3d56a10 100644
--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -597,7 +597,7 @@ static void tegra_gpio_irq_release_resources(struct irq_data *d)
 	struct tegra_gpio_info *tgi = gpiochip_get_data(chip);
 
 	gpiochip_relres_irq(chip, d->hwirq);
-	tegra_gpio_enable(tgi, d->hwirq);
+	tegra_gpio_disable(tgi, d->hwirq);
 }
 
 static void tegra_gpio_irq_print_chip(struct irq_data *d, struct seq_file *s)
-- 
2.53.0



