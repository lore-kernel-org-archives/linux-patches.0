Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F187E2AE94;
	Thu, 23 May 2024 13:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470309; cv=none; b=cGe9jRL8EgztRDkahR0r+6zkpwfZ2d5xR4y1LJ/44qeQV5qLGo7L8KwylYJZJ3ZZcyXCUM7rvc5Nhyc53U2/x56nImTAG6PFbFtzMsrDsjlJh+oqgzpRRRJufb1MMFRxobyUKjt3AGxj0Y7wOaTOuR5TlVs0jpkmd+bu8ungIaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470309; c=relaxed/simple;
	bh=Q33rdetUKd/x7JWaK4jo2LniXHiSQDLLglPJYaougKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6Bj23dmTVrzBEbpicLvzHUUr2MyNqVIgB4jrDvQg1FrHfeRfz7EDZt4gj08IkGZNcWiXy/PA7yUxvy5RIyo1WdINJPTZmGs56maqZZGlpEqUXByoBx3PG5RV0sMTwYFvIgCNYjCR9QyXIBEBYlt9HLGqHc1sHdLd/WGY8r8A2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kREsMDwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kREsMDwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725BDC32781;
	Thu, 23 May 2024 13:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470308;
	bh=Q33rdetUKd/x7JWaK4jo2LniXHiSQDLLglPJYaougKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kREsMDwQA4QZQ0K9sDpz2D/TYEpUAJlxGfsK+T1gsfJkVAIwhLalnd+oaHMZ6mv7/
	 8qLIvZrIAQ6opaZqddb2uQTzn+Jquv2IYU0M2jRQZNMqVtvYFPKko0pNho7DvAKFGQ
	 X4cfAFDEJ0KaJbocdPkGv6eU0qUnf0IjUyXwHbUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Hemdan, Hagar Gamal Halim" <hagarhem@amazon.de>
Subject: [PATCH 5.15 02/23] pinctrl: core: handle radix_tree_insert() errors in pinctrl_register_one_pin()
Date: Thu, 23 May 2024 15:12:58 +0200
Message-ID: <20240523130328.051503093@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
References: <20240523130327.956341021@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit ecfe9a015d3e1e46504d5b3de7eef1f2d186194a upstream.

pinctrl_register_one_pin() doesn't check the result of radix_tree_insert()
despite they both may return a negative error code.  Linus Walleij said he
has copied the radix tree code from kernel/irq/ where the functions calling
radix_tree_insert() are *void* themselves; I think it makes more sense to
propagate the errors from radix_tree_insert() upstream if we can do that...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20230719202253.13469-3-s.shtylyov@omp.ru
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: "Hemdan, Hagar Gamal Halim" <hagarhem@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/core.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -205,6 +205,7 @@ static int pinctrl_register_one_pin(stru
 				    const struct pinctrl_pin_desc *pin)
 {
 	struct pin_desc *pindesc;
+	int error;
 
 	pindesc = pin_desc_get(pctldev, pin->number);
 	if (pindesc) {
@@ -226,18 +227,25 @@ static int pinctrl_register_one_pin(stru
 	} else {
 		pindesc->name = kasprintf(GFP_KERNEL, "PIN%u", pin->number);
 		if (!pindesc->name) {
-			kfree(pindesc);
-			return -ENOMEM;
+			error = -ENOMEM;
+			goto failed;
 		}
 		pindesc->dynamic_name = true;
 	}
 
 	pindesc->drv_data = pin->drv_data;
 
-	radix_tree_insert(&pctldev->pin_desc_tree, pin->number, pindesc);
+	error = radix_tree_insert(&pctldev->pin_desc_tree, pin->number, pindesc);
+	if (error)
+		goto failed;
+
 	pr_debug("registered pin %d (%s) on %s\n",
 		 pin->number, pindesc->name, pctldev->desc->name);
 	return 0;
+
+failed:
+	kfree(pindesc);
+	return error;
 }
 
 static int pinctrl_register_pins(struct pinctrl_dev *pctldev,


