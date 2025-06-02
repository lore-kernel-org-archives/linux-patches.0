Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C72A188907;
	Mon,  2 Jun 2025 14:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874919; cv=none; b=jmBfyrpuK6hV2ylZJx0xWah86F6EJ7+qk2BGZd+OerrmujNVb31fay08Te7jwnYZgPKCaXfFNRVEMG+jygmZsZrtUq08NtjUk6uUDZdSc9HAVDYXHSCKMJIor1ebBGNEqp+jNTcQWTGbkVa0qQEn8KFt5BoVffceYigoEkv/S5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874919; c=relaxed/simple;
	bh=6VS/A7YdtS8LxuVmmkPmTmsvKEbPdS7jZXHOzHMiDYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjsi2JNUY2GFn2uUTOEteTRi1xdTUaKko9ue0LVYHjvsCEYEoCDbAnXmLgzQ0Lo4z65tvEqRMq2W9Qg9ERcPoGCtiZiyC+NYwrtpDqN77OihAKPfBtYuYJbNSVUZfO/YqinWKzqttuMUUGdV+e72XlJDYTVlddNFdlNFpHQU+KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqtKUiL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqtKUiL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05631C4CEEB;
	Mon,  2 Jun 2025 14:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874919;
	bh=6VS/A7YdtS8LxuVmmkPmTmsvKEbPdS7jZXHOzHMiDYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqtKUiL+mBrPDyzWt2b2H75oJ4KFr20cbVhSsnsiAL0Rk+AAR7EQ72N5RpBbQlfhV
	 j6UV6JuJF6ePqjshvPULG+af1d4/aaRh9FAduPDk6NIL5lpiGhYrncNPc5w7tIeKAx
	 /PU2sOl1HRduNSiOBzymZlJ4bbe1e/D2Qx7fuRtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Caron <valentin.caron@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/204] pinctrl: devicetree: do not goto err when probing hogs in pinctrl_dt_to_map
Date: Mon,  2 Jun 2025 15:47:58 +0200
Message-ID: <20250602134301.351436627@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valentin Caron <valentin.caron@foss.st.com>

[ Upstream commit c98868e816209e568c9d72023ba0bc1e4d96e611 ]

Cross case in pinctrl framework make impossible to an hogged pin and
another, not hogged, used within the same device-tree node. For example
with this simplified device-tree :

  &pinctrl {
    pinctrl_pin_1: pinctrl-pin-1 {
      pins = "dummy-pinctrl-pin";
    };
  };

  &rtc {
    pinctrl-names = "default"
    pinctrl-0 = <&pinctrl_pin_1 &rtc_pin_1>

    rtc_pin_1: rtc-pin-1 {
      pins = "dummy-rtc-pin";
    };
  };

"pinctrl_pin_1" configuration is never set. This produces this path in
the code:

  really_probe()
    pinctrl_bind_pins()
    | devm_pinctrl_get()
    |   pinctrl_get()
    |     create_pinctrl()
    |       pinctrl_dt_to_map()
    |         // Hog pin create an abort for all pins of the node
    |         ret = dt_to_map_one_config()
    |         | /* Do not defer probing of hogs (circular loop) */
    |         | if (np_pctldev == p->dev->of_node)
    |         |   return -ENODEV;
    |         if (ret)
    |           goto err
    |
    call_driver_probe()
      stm32_rtc_probe()
        pinctrl_enable()
          pinctrl_claim_hogs()
            create_pinctrl()
              for_each_maps(maps_node, i, map)
                // Not hog pin is skipped
                if (pctldev && strcmp(dev_name(pctldev->dev),
                                      map->ctrl_dev_name))
                  continue;

At the first call of create_pinctrl() the hogged pin produces an abort to
avoid a defer of hogged pins. All other pin configurations are trashed.

At the second call, create_pinctrl is now called with pctldev parameter to
get hogs, but in this context only hogs are set. And other pins are
skipped.

To handle this, do not produce an abort in the first call of
create_pinctrl(). Classic pin configuration will be set in
pinctrl_bind_pins() context. And the hogged pin configuration will be set
in pinctrl_claim_hogs() context.

Signed-off-by: Valentin Caron <valentin.caron@foss.st.com>
Link: https://lore.kernel.org/20250116170009.2075544-1-valentin.caron@foss.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/devicetree.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index 200357094e3be..e9bfb96a2e0e8 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -141,10 +141,14 @@ static int dt_to_map_one_config(struct pinctrl *p,
 		pctldev = get_pinctrl_dev_from_of_node(np_pctldev);
 		if (pctldev)
 			break;
-		/* Do not defer probing of hogs (circular loop) */
+		/*
+		 * Do not defer probing of hogs (circular loop)
+		 *
+		 * Return 1 to let the caller catch the case.
+		 */
 		if (np_pctldev == p->dev->of_node) {
 			of_node_put(np_pctldev);
-			return -ENODEV;
+			return 1;
 		}
 	}
 	of_node_put(np_pctldev);
@@ -268,6 +272,8 @@ int pinctrl_dt_to_map(struct pinctrl *p, struct pinctrl_dev *pctldev)
 			ret = dt_to_map_one_config(p, pctldev, statename,
 						   np_config);
 			of_node_put(np_config);
+			if (ret == 1)
+				continue;
 			if (ret < 0)
 				goto err;
 		}
-- 
2.39.5



