Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075AD1875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813DFC433EF;
	Wed, 28 Dec 2022 16:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243367;
	bh=jBE6hruOnRQMIgFsUWDkBDqedX+JURaItPYusGic2g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+AcDAEJJ0QcyvYy3ybJ8bFlXFIdz9uOnWDZL8xrjraG0DQfCfeJjtQqb7Q1Oy38G
	 DDOPqjfHDbwSmQyKnNSaiyBEZj7nNzuyvJrVsiU+FwLRxbCfh83FZgMW/eHhEnTph7
	 3c1jIAWC5jOs0N28NB4Fwv2AnMKY/+b6uvJ6l/Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0485/1146] pinctrl: thunderbay: fix possible memory leak in thunderbay_build_functions()
Date: Wed, 28 Dec 2022 15:33:44 +0100
Message-Id: <20221228144343.355894350@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 83e1bcaf8cef26edaaf2a6098ef760f563683483 ]

The thunderbay_add_functions() will free memory of thunderbay_funcs
when everything is ok, but thunderbay_funcs will not be freed when
thunderbay_add_functions() fails, then there will be a memory leak,
so we need to add kfree() when thunderbay_add_functions() fails to
fix it.

In addition, doing some cleaner works, moving kfree(funcs) from
thunderbay_add_functions() to thunderbay_build_functions().

Fixes: 12422af8194d ("pinctrl: Add Intel Thunder Bay pinctrl driver")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20221129120126.1567338-1-cuigaosheng1@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-thunderbay.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-thunderbay.c b/drivers/pinctrl/pinctrl-thunderbay.c
index 9328b17485cf..590bbbf619af 100644
--- a/drivers/pinctrl/pinctrl-thunderbay.c
+++ b/drivers/pinctrl/pinctrl-thunderbay.c
@@ -808,7 +808,7 @@ static int thunderbay_add_functions(struct thunderbay_pinctrl *tpc, struct funct
 					    funcs[i].num_group_names,
 					    funcs[i].data);
 	}
-	kfree(funcs);
+
 	return 0;
 }
 
@@ -817,6 +817,7 @@ static int thunderbay_build_functions(struct thunderbay_pinctrl *tpc)
 	struct function_desc *thunderbay_funcs;
 	void *ptr;
 	int pin;
+	int ret;
 
 	/*
 	 * Allocate maximum possible number of functions. Assume every pin
@@ -860,7 +861,10 @@ static int thunderbay_build_functions(struct thunderbay_pinctrl *tpc)
 		return -ENOMEM;
 
 	thunderbay_funcs = ptr;
-	return thunderbay_add_functions(tpc, thunderbay_funcs);
+	ret = thunderbay_add_functions(tpc, thunderbay_funcs);
+
+	kfree(thunderbay_funcs);
+	return ret;
 }
 
 static int thunderbay_pinconf_set_tristate(struct thunderbay_pinctrl *tpc,
-- 
2.35.1



