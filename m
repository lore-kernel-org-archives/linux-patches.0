Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574F1278750;
	Tue, 27 May 2025 17:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366211; cv=none; b=rbDDrVoN6RJ38HwcIqMxTuTq4y51IbVnrK3HKi1KiS7HhD5QvE/Zq9EjKbWPYVbUu0s60alKh5AvxOffdkDyWdYwRabmNhz8Kb14TxWcLdQ3WkHhm0rReCDz/utpHW6kfGwGGZtrHllxmIL3/NC+7hOwNi78Fqu372z8WdLDKjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366211; c=relaxed/simple;
	bh=ZwZSiMp7UHmm5nUbVnKNIxANL/VW2llVyGGGgWbwSh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hF5ASecHpNum6XmqjiX5DUvyyakkVpMQkVNxLq3l7InUY8XBIoqeaE6kMBb0Gtgv8Vdxg7WDxZ0lvXG6x09z6mJZe7YBWx98G3WocbrPN3yWg35jnJTw8KTzxf37twbho2p6uPUFH7hWg+bJhvnx0DegHM/vMeujSyDQ4HSPCf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUvGMXl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUvGMXl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9397C4CEE9;
	Tue, 27 May 2025 17:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366211;
	bh=ZwZSiMp7UHmm5nUbVnKNIxANL/VW2llVyGGGgWbwSh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUvGMXl8fnxsFQ3Kkik/tzhkJtKMF/9g9PkhlSiRH8fXhwas2u9y4uSJdguaM8QTH
	 yCH/0isVEEo14F+EOKyeBGC16ohMG1U3kzLDmCk28JijqOhoU5XIkZK5MWhIQdY5XL
	 DtD0KdVP5gqcGusPLrAwi7dOS6pFVQXNFkON2jyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.12 623/626] pinctrl: tegra: Fix off by one in tegra_pinctrl_get_group()
Date: Tue, 27 May 2025 18:28:36 +0200
Message-ID: <20250527162510.311788882@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 5a062c3c3b82004766bc3ece82b594d337076152 upstream.

This should be >= pmx->soc->ngroups instead of > to avoid an out of
bounds access.  The pmx->soc->groups[] array is allocated in
tegra_pinctrl_probe().

Fixes: c12bfa0fee65 ("pinctrl-tegra: Restore SFSEL bit when freeing pins")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Kunwu Chan <kunwu.chan@linux.dev>
Link: https://lore.kernel.org/82b40d9d-b437-42a9-9eb3-2328aa6877ac@stanley.mountain
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/tegra/pinctrl-tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/tegra/pinctrl-tegra.c
+++ b/drivers/pinctrl/tegra/pinctrl-tegra.c
@@ -305,7 +305,7 @@ static const struct tegra_pingroup *tegr
 {
 	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
 
-	if (group_index < 0 || group_index > pmx->soc->ngroups)
+	if (group_index < 0 || group_index >= pmx->soc->ngroups)
 		return NULL;
 
 	return &pmx->soc->groups[group_index];


