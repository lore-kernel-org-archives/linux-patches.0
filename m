Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAE1357CEB;
	Tue, 21 Jul 2026 21:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670176; cv=none; b=IHaVx5QZzoBu/0yisMPkv2Eq5mZPcaM0oRj5rQoQ6Frsvjfc0S9NN+3Aqhx18KtRm6M8jYKkR/nuTDIbmYtifyoYQ7LLfmI93QZwjTVXF2WMDhW0hzWMJ19+glfXoUEkcbKx3zOTersAfEX7TZke62GfMGSaDPjBGOeIrOypGn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670176; c=relaxed/simple;
	bh=LEwf6wkkZYteU6SimwMJqjVdQXnTk/Ffzi1yXmvDOjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8nSH9M9HQ67Nw3s/M+Th6IidGDs8lXDVDQS5pm6hjRtC8uUDgt8b8RTnHBCeAZt5/cUFPwTFsnHuwrgBgZUJHu5ue2Kvzejl58gMP3vThBXL1WZau/iPOb5LSfwHaz2Z7WL+VzG8UeWUC6ntmNwsMoAiUJWFxU2flU5Nu7ljy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzjaDK6v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzjaDK6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15BB1F000E9;
	Tue, 21 Jul 2026 21:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670174;
	bh=tPOurwidOp5rzc66yLPVf9+9Hbjz062RcnTPcXQhlBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nzjaDK6v+NCM2xV3WOQQHCrWQzcP8EUUutORPb5QLNt12lZGDpOEDbn7cedtDTgn0
	 XZgg3WJ0hdu9K/4lDSi/YzLAwIt+pGDUxEnZ2d0Yom4fvB2MLVFWRyBzWOYcM0lVuN
	 HfAhsAzUDNpx0bD2e5dLK04HIZHoWllNqhRy/XCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 0796/1067] power: supply: charger-manager: fix refcount leak in is_full_charged()
Date: Tue, 21 Jul 2026 17:23:17 +0200
Message-ID: <20260721152442.368683905@linuxfoundation.org>
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

From: WenTao Liang <vulab@iscas.ac.cn>

commit 4373cfa38ead58f980362c841b0d0bdf8c4d956c upstream.

In is_full_charged(), power_supply_get_by_name() is called to
obtain a reference to the fuel_gauge power supply. If the
voltage check (uV >= desc->fullbatt_uV) succeeds, the function
returns true directly without releasing the reference, leaking
the refcount.

Fix this by setting a flag and jumping to the out label where
power_supply_put() properly drops the reference.

Cc: stable@vger.kernel.org
Fixes: e132fc6bb89b ("power: supply: charger-manager: Make decisions focussed on battery status")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260611005322.53096-1-vulab@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/charger-manager.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/power/supply/charger-manager.c
+++ b/drivers/power/supply/charger-manager.c
@@ -302,8 +302,10 @@ static bool is_full_charged(struct charg
 			if (cm->battery_status == POWER_SUPPLY_STATUS_FULL
 					&& desc->fullbatt_vchkdrop_uV)
 				uV += desc->fullbatt_vchkdrop_uV;
-			if (uV >= desc->fullbatt_uV)
-				return true;
+			if (uV >= desc->fullbatt_uV) {
+				is_full = true;
+				goto out;
+			}
 		}
 	}
 


