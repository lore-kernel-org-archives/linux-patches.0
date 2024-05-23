Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541131E4B0;
	Thu, 23 May 2024 13:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470120; cv=none; b=WaUFg+tJPsprAMNWOSm0b2x/FvsajAHnUbMnqsOR1g7jaOIYau2BsFVgGCtt3WkJXL3pH4rn5IvCFA5seTgGfMgEVwYrKcGAzF9/kWn+ajsXiomQUdl2riU5fT0fBfLoT48rp1e0c4EukZMJFP037Pq+fKndiTMqc3GUPVXSRfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470120; c=relaxed/simple;
	bh=Lt2M72xlXVupgUdAZvh9NsETjtaseBfpqNUBr3jwhq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S821iH7Guoug5bfOCuJv1zHn8CUJgSLXEG7mo/45V+AJP9UEeb9h2CD4qSrCmZVc6TbEUvmLti2CW4L/Ztc8jBVcDysJGpyXj7BvRyCmB3LKYmcxL6SiXXBCMP6lk4QabQu3Ei9IAd8XIoIM2S4+wbTVaNz73+7zkdwB4qD9mr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJ5hxl7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJ5hxl7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA2AC2BD10;
	Thu, 23 May 2024 13:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470119;
	bh=Lt2M72xlXVupgUdAZvh9NsETjtaseBfpqNUBr3jwhq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJ5hxl7bGRQoUpXkJOPJ8eSagJTCNwQpeUcUonM2rfzLlV+BZH8HSqSendTpNLYDH
	 jdKu8EORB5+hndwaQFiebattGbZY43Un4xxnTC9VlKQbVaRco28qZJ8YbQab1heR7k
	 Ib0eydtHDQvckX/OpQizUGeBSFUjfkog1A/NsWvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Hemdan, Hagar Gamal Halim" <hagarhem@amazon.de>
Subject: [PATCH 5.4 01/16] pinctrl: core: handle radix_tree_insert() errors in pinctrl_register_one_pin()
Date: Thu, 23 May 2024 15:12:34 +0200
Message-ID: <20240523130325.801390965@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
References: <20240523130325.743454852@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -203,6 +203,7 @@ static int pinctrl_register_one_pin(stru
 				    const struct pinctrl_pin_desc *pin)
 {
 	struct pin_desc *pindesc;
+	int error;
 
 	pindesc = pin_desc_get(pctldev, pin->number);
 	if (pindesc) {
@@ -224,18 +225,25 @@ static int pinctrl_register_one_pin(stru
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


