Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F28C44AB6D;
	Tue, 21 Jul 2026 21:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668748; cv=none; b=Y3vtWb/tLt5n0GnxiZeLt1FlCOx4cQ1qZbTwuGk4lyNMiH+rwZDCNmRtQgtAXhpKEsfd8ExoTwKeFtqiO4ZvorSGTabrxsE1v/vlX6SyG3lkqbU/kKPFhSWz2dJckizNLy7eFZF8KN1fLyvEHLNW33N0sQCc9W1Injzpy93V2OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668748; c=relaxed/simple;
	bh=1bxYmMEa/VlsDnKaeUvVc79K5A+BMA1OF+fxRmZxRpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7RtwU7CzAtHcrnqM+5l9K3V5ewY7CcSJLDEruZvY6QFv+d84veAAlCKikjhKmLqIUe8Tdt+DBfyi4KmkENJx/oohmPbsRoS3L9N7PXPe1lnuMY0pDQGypr+bn8EhQ2JxdXqcUEC1sZ5bxMZkN65cbnnhzZYdeEua4zt0DYQUoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRJpyOR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRJpyOR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C4F1F000E9;
	Tue, 21 Jul 2026 21:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668747;
	bh=zByUnNpCqhbNL6zugLCizfWwBmUTpjk8zOc4DsJmPv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRJpyOR/Ywdq23a5bKbo4desQt6LoG6uSxsSjs8vMf8HpmPHQ8Wxy8yejniwQLuAq
	 qRa5npXaqtVdXtQJ+KzjYbD3g6Y6S8mevnvCSUKGRm+C6MAgI81jwnFKvUtzGsGQHY
	 AeGbjb0O/kYCqx6svecn5do2jYonoOggozMNznyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0294/1067] pinctrl: sunxi: fix regulator leak in sunxi_pmx_request() error path
Date: Tue, 21 Jul 2026 17:14:55 +0200
Message-ID: <20260721152431.179282228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 334f7bcbdc79dc8e5b938ac3372453a5368221cf ]

In the error path of sunxi_pmx_request(), the code calls
regulator_put(s_reg->regulator) to release the regulator. However,
s_reg->regulator is only assigned after a successful regulator_enable().
This causes a memory leak: the regulator obtained via regulator_get()
is never properly released when regulator_enable() fails.

Fixes: dc1445584177 ("pinctrl: sunxi: Fix and simplify pin bank regulator handling")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index df2e721297fc9d..508aa911c8d995 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -878,7 +878,7 @@ static int sunxi_pmx_request(struct pinctrl_dev *pctldev, unsigned offset)
 	return 0;
 
 out:
-	regulator_put(s_reg->regulator);
+	regulator_put(reg);
 
 	return ret;
 }
-- 
2.53.0



