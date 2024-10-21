Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD26C16F27E;
	Mon, 21 Oct 2024 10:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506784; cv=none; b=Ju9k9+YP4wAkj0BTS7Gcy7qrlScZxyr0OYRzl4ErGcLPoHdSlF3+i4CSMqol711K+nvmKM48fe1TQLpJyXkfn5jfnl4LQixhIh/Faf9K5q4VFxlKCleFg0xYtYwsyGvv+zlnXK3ev69XlDSNPSUnthe8jW2H9sxlTUv68T+CnnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506784; c=relaxed/simple;
	bh=94GxdMmeznr+am3gvyzm8KOHP0l2jHetUhVwVgRUh38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdKwRU8HF3/EtQbOtT8FLbxbr2LZjUznOKrphZCKWWT0hVdxzBaC9O/+a/8u1YXS1giGagApJvot57ciBO6IWWHAcQaEDHymWW4Qnwi9R76qcjkFVIqvxfnkcy0zm5qrw66YVLIi+ncnL0+ti9UOdVG2XMkU8hvFJowi+wvaGnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKyUztHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKyUztHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC6EC4CEC3;
	Mon, 21 Oct 2024 10:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506784;
	bh=94GxdMmeznr+am3gvyzm8KOHP0l2jHetUhVwVgRUh38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKyUztHNIHdAOgk2QjbpUr3YV1PpX4YwaJgOI9zavhVPq5qC+wLhmtD8Mp0tnG4q1
	 mDYHzRY/SiAFM7EFaZ2rTiwjN4Tb1VMRE1IKaV0UJ2VE1/9JbFdkB8U21+Wwcn3ds+
	 4Jik9rtayPQRWMWS1CZtTWP0UT3Q7u/LH4Bn9UTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.11 121/135] pinctrl: nuvoton: fix a double free in ma35_pinctrl_dt_node_to_map_func()
Date: Mon, 21 Oct 2024 12:24:37 +0200
Message-ID: <20241021102304.066261122@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

commit 3fd976afe9743110f20a23f93b7ff9693f2be4bf upstream.

'new_map' is allocated using devm_* which takes care of freeing the
allocated data on device removal, call to

	.dt_free_map = pinconf_generic_dt_free_map

double frees the map as pinconf_generic_dt_free_map() calls
pinctrl_utils_free_map().

Fix this by using kcalloc() instead of auto-managed devm_kcalloc().

Cc: stable@vger.kernel.org
Fixes: f805e356313b ("pinctrl: nuvoton: Add ma35d1 pinctrl and GPIO driver")
Reported-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/20241010205237.1245318-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/nuvoton/pinctrl-ma35.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-ma35.c b/drivers/pinctrl/nuvoton/pinctrl-ma35.c
index 1fa00a23534a..59c4e7c6cdde 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-ma35.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-ma35.c
@@ -218,7 +218,7 @@ static int ma35_pinctrl_dt_node_to_map_func(struct pinctrl_dev *pctldev,
 	}
 
 	map_num += grp->npins;
-	new_map = devm_kcalloc(pctldev->dev, map_num, sizeof(*new_map), GFP_KERNEL);
+	new_map = kcalloc(map_num, sizeof(*new_map), GFP_KERNEL);
 	if (!new_map)
 		return -ENOMEM;
 
-- 
2.47.0



