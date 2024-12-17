Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826301F75BE;
	Tue, 17 Dec 2024 17:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456326; cv=none; b=VCsqmnpa/5CLjC6LCiS4Vr7YUwiYcUNdrbZLssbU8yGMvR0xmkZzVpFk6rtPSCz4ByXqgavYcsBYHHhU99mFSTRw4Cz+KIYVHZUKz1Y3CD7USDzZe3rma00R/bLKZrkYNkj/nAkg9c4ZBSIDRDXehZ3FGRs4hWQocPN9nMXnkD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456326; c=relaxed/simple;
	bh=Nrn7N4lvfgaJUKjj+XdD47HdYkAtJdwM7zY1mu3UI7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9Sjx5Y7w+UirgW+IseKJz82sXjKr7ERvdbaQFn+RLL6PlNmWdDjQaqDd1QLUc6rpteCqtdpXD/1lywsgA37O1HEUts57Ok/PNnf8k3+TCauFpI+7E4A2DHVGDUO8z0VpLG68r36hqRnCta53DeRYUTpn79a1Jl5vjyIJM8SwoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoMwC41Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoMwC41Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50FAC4CED3;
	Tue, 17 Dec 2024 17:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456326;
	bh=Nrn7N4lvfgaJUKjj+XdD47HdYkAtJdwM7zY1mu3UI7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoMwC41ZmVeELb2VpfEFZVpE36OVa1GgShNp0oeZL4NUp0YnITieaKWVbCnO9eIDA
	 tzeP1Xtggu2a7Q0HM8hjy7peiVGQm8o8pJjre+aHbBY2uXf5rIxRRmEzcJgsCJwwH6
	 qQR2htUokyUDiR38ABThPulXsJkvIpszI08YoMi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoyu Li <lihaoyu499@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.12 024/172] gpio: ljca: Initialize num before accessing item in ljca_gpio_config
Date: Tue, 17 Dec 2024 18:06:20 +0100
Message-ID: <20241217170547.264018454@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoyu Li <lihaoyu499@gmail.com>

commit 3396995f9fb6bcbe0004a68118a22f98bab6e2b9 upstream.

With the new __counted_by annocation in ljca_gpio_packet, the "num"
struct member must be set before accessing the "item" array. Failing to
do so will trigger a runtime warning when enabling CONFIG_UBSAN_BOUNDS
and CONFIG_FORTIFY_SOURCE.

Fixes: 1034cc423f1b ("gpio: update Intel LJCA USB GPIO driver")
Cc: stable@vger.kernel.org
Signed-off-by: Haoyu Li <lihaoyu499@gmail.com>
Link: https://lore.kernel.org/stable/20241203141451.342316-1-lihaoyu499%40gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-ljca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-ljca.c b/drivers/gpio/gpio-ljca.c
index d67b912d884d..c6c31e6146c7 100644
--- a/drivers/gpio/gpio-ljca.c
+++ b/drivers/gpio/gpio-ljca.c
@@ -82,9 +82,9 @@ static int ljca_gpio_config(struct ljca_gpio_dev *ljca_gpio, u8 gpio_id,
 	int ret;
 
 	mutex_lock(&ljca_gpio->trans_lock);
+	packet->num = 1;
 	packet->item[0].index = gpio_id;
 	packet->item[0].value = config | ljca_gpio->connect_mode[gpio_id];
-	packet->num = 1;
 
 	ret = ljca_transfer(ljca_gpio->ljca, LJCA_GPIO_CONFIG, (u8 *)packet,
 			    struct_size(packet, item, packet->num), NULL, 0);
-- 
2.47.1



