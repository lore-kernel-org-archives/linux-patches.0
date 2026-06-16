Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F41B44103A;
	Tue, 16 Jun 2026 16:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626082; cv=none; b=TkGUrO+y+S7Wvq8MDD3XuMS0ljoTwPwrIDvwgi81UIJiP/GC/a12vp+R/Qp+Oh4/P31X7JzEeZpBMLUDlwE/2VlEYh8MFS/GbveUvRmUT6ba37bS6ZSmIJoTNR+QIEjKOr/5hGZprcYd7OiYa+gWGJwCIo7w5mH2cu7n00w09Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626082; c=relaxed/simple;
	bh=TximLTSjrvBASSfnzc3iLg122yV3uuOln9zgHTrRCe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmOxRhbF6NiHFxijIdmFI2WvjZF6WQvMDHWwZqbDRJZZAvl4j20lSSjnX9nKpidbIai77XPYRMFvae+SO/g+YsRYy9H8P6jo3r+ZRPB0Jtn8UmBl0r0wBFNnsPq7Q4SsmJVNq71u2o40mTAQ0F3Tl0HBTJkgw2uG8T9DqUc7NAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Adp48ZUy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Adp48ZUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407181F000E9;
	Tue, 16 Jun 2026 16:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626081;
	bh=hGaiQEeESs5EnZTuocWBJS8+ZSMKeTtwwhLAPhDDUtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Adp48ZUyItFFtN2cEkalqbPdkzuB6LcLKDLKLPk7uN83Fx+UNK4jAkt5QWAV8+/oU
	 d6C7E1xzCKkVv/hFujGkDxyDUSugEbxtATinrLxssYGRqKJMkInH3rQJ4LynqI8AwZ
	 4JPT4ZVKpxkO3iofrhIaU2fm/kWRNxKsvJWC7lJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 262/325] pmdomain: imx: fix OF node refcount
Date: Tue, 16 Jun 2026 20:30:58 +0530
Message-ID: <20260616145111.657040336@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit fba0510cd62666951dcc0221527edc0c47ae6599 upstream.

for_each_child_of_node_scoped() decrements the reference count of the
nod after each iteration. Assigning it without incrementing the refcount
to a dynamically allocated platform device will result in a double put
in platform_device_release(). Add the missing call to of_node_get().

Cc: stable@vger.kernel.org
Fixes: 3e4d109ee8fc ("pmdomain: imx: gpc: Simplify with scoped for each OF child loop")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/gpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/imx/gpc.c
+++ b/drivers/pmdomain/imx/gpc.c
@@ -487,7 +487,7 @@ static int imx_gpc_probe(struct platform
 			domain->ipg_rate_mhz = ipg_rate_mhz;
 
 			pd_pdev->dev.parent = &pdev->dev;
-			pd_pdev->dev.of_node = np;
+			pd_pdev->dev.of_node = of_node_get(np);
 			pd_pdev->dev.fwnode = of_fwnode_handle(np);
 
 			ret = platform_device_add(pd_pdev);


