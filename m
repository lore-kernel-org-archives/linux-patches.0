Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51C74BEE20;
	Sat, 12 Sep 2026 14:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222773; cv=none; b=MWuwaw3QRHXHwORWPgeQPI0WP+6cF0LvG+xfqQIL6rDWurP36C5rSmkiHg8ptXyuyi0FQfYiF6WOyynR5+xvyrIWl2BgU/E0uqYgG3rvSejt/eXnELP7BQn9Y09JmDvZbTOpqwFs2XjcocUkr9M+8X7s+eSZNjQgAvQFOBRh+Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222773; c=relaxed/simple;
	bh=CItTKhPrlF0pFI1BG12iB/7Sk0YN+7E8DVl+BvXQb6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UB8cvuV7u25hUaVVs3FfheqjMGblDyCjBEZMh0pifCQYSLqPl5gHWqGF8nzA427cmJVhdCEsoaoa4PWskD2m9KGTwEt9tAjAfwejVQZB8jbxzoBApp3JGJAmJlGlGilF6uUFyZ9f/vDDFKmIeOCzQMO9TuG+Nnpa3fKlmHRznlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESFbaNPr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESFbaNPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34821F000FF;
	Sat, 12 Sep 2026 14:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222772;
	bh=ZeILH4jelzWqNgQ0rtPjqtjrbu3jtanxGVglHQl9GbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ESFbaNPreujPoGh4R1KGxpocD3duzUsBVf9qXeAaK+VoX4nGgi4XIJ4Je0F2yLE8t
	 G8kG2HOBkfDScgjro/K0Dj8w+3r8+Ow2o4+BJeTbF8BDi+Jt8i7cqZVw9/AbSYCZkj
	 cKwvtzmAxpIz2BP7O8KpsNLHi4MllSkIBSe7FZiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0654/1424] bus: qcom-ebi2: Fix clock leak on probe failure
Date: Sat, 12 Sep 2026 08:51:26 +0200
Message-ID: <20260912065621.938558431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 64774dea58969194ea5c27fa639954e551a87024 ]

qcom_ebi2_probe() enables the EBI2X and EBI2 clocks before it walks
child nodes and populates child devices. If reading a child node's reg
property fails, or if of_platform_default_populate() fails, probe returns
without disabling either clock.

Route those failure paths through the existing clock cleanup labels so a
failed probe does not leave the clocks prepared and enabled.

Fixes: 335a12754808 ("bus: qcom: add EBI2 driver")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://lore.kernel.org/r/20260620080406.1970447-1-ruoyuw560@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/qcom-ebi2.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/bus/qcom-ebi2.c b/drivers/bus/qcom-ebi2.c
index be8166565e7cc..ab00c75b9e953 100644
--- a/drivers/bus/qcom-ebi2.c
+++ b/drivers/bus/qcom-ebi2.c
@@ -353,7 +353,7 @@ static int qcom_ebi2_probe(struct platform_device *pdev)
 		/* Figure out the chipselect */
 		ret = of_property_read_u32(child, "reg", &csindex);
 		if (ret)
-			return ret;
+			goto err_disable_clk;
 
 		if (csindex > 5) {
 			dev_err(dev,
@@ -372,8 +372,12 @@ static int qcom_ebi2_probe(struct platform_device *pdev)
 		have_children = true;
 	}
 
-	if (have_children)
-		return of_platform_default_populate(np, NULL, dev);
+	if (have_children) {
+		ret = of_platform_default_populate(np, NULL, dev);
+		if (ret)
+			goto err_disable_clk;
+	}
+
 	return 0;
 
 err_disable_clk:
-- 
2.53.0



