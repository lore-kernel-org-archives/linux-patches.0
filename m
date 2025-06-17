Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDD22F9492;
	Tue, 17 Jun 2025 16:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177258; cv=none; b=tbhwrJPY7G350f7fwUIgHRAfoaJBCM3wHtQnHJ/H4a0PMRgk+0B4QzEOq4w00q42YX5rqDEOLTigmTWA8SNIvc06ax58mYKKItrBERqcahmlINvJE0Ik9AmWfQyEEkoG7kb/RzBRxnqvDATfoUuu4Xg/k2r87FuS7QQX8m15ks4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177258; c=relaxed/simple;
	bh=k2pVnRAv8qNj22NTVAH/63kYJLru6jhyh2R34yOX3KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDLgQhjb5bz6NDJ+vpK6G31j4X3TT5Fh48Ak2IhidQUlsuav2OkKiwEfsFWlaCd2E0EFiPG/YbtF5y5/3woDdqD3MUaF0fQHATSTxi7VhRQXbWi2mzsxV04NXXUOLpDM/sileuyUICqn3rp8gqPCuYPnJO6vCB1p6lDD0sXkujs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgZZ8rv7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgZZ8rv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839BFC4CEE3;
	Tue, 17 Jun 2025 16:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177258;
	bh=k2pVnRAv8qNj22NTVAH/63kYJLru6jhyh2R34yOX3KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgZZ8rv73IImMbKzEAtKJ63FBOST4ZUBHlJOa5H3ALepldCF43NGQ+RDT0NpEwKPu
	 4sOHrbOo53Ogih6phb8pVUqslFeJ4ZMoHg9TRfcyjtq6wioUEhTvFjfAZccCKjZAHP
	 Yh2hDbDvCAOaKk7ecbru2BCw27ak+cS0IQHK4ulw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 314/512] phy: qcom-qmp-usb: Fix an NULL vs IS_ERR() bug
Date: Tue, 17 Jun 2025 17:24:40 +0200
Message-ID: <20250617152432.339053084@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit d14402a38c2d868cacb1facaf9be908ca6558e59 ]

The qmp_usb_iomap() helper function currently returns the raw result of
devm_ioremap() for non-exclusive mappings. Since devm_ioremap() may return
a NULL pointer and the caller only checks error pointers with IS_ERR(),
NULL could bypass the check and lead to an invalid dereference.

Fix the issue by checking if devm_ioremap() returns NULL. When it does,
qmp_usb_iomap() now returns an error pointer via IOMEM_ERR_PTR(-ENOMEM),
ensuring safe and consistent error handling.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Fixes: a5d6b1ac56cb ("phy: qcom-qmp-usb: fix memleak on probe deferral")
CC: Johan Hovold <johan@kernel.org>
CC: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250414125050.2118619-1-chenyuan0y@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
index 8e2cd2c178d6b..c12efd127a612 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
@@ -2044,12 +2044,16 @@ static void __iomem *qmp_usb_iomap(struct device *dev, struct device_node *np,
 					int index, bool exclusive)
 {
 	struct resource res;
+	void __iomem *mem;
 
 	if (!exclusive) {
 		if (of_address_to_resource(np, index, &res))
 			return IOMEM_ERR_PTR(-EINVAL);
 
-		return devm_ioremap(dev, res.start, resource_size(&res));
+		mem = devm_ioremap(dev, res.start, resource_size(&res));
+		if (!mem)
+			return IOMEM_ERR_PTR(-ENOMEM);
+		return mem;
 	}
 
 	return devm_of_iomap(dev, np, index, NULL);
-- 
2.39.5



