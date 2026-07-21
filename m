Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079BC3B7B64;
	Tue, 21 Jul 2026 20:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667243; cv=none; b=dIqg13rNp1zGCivYRozP8IFcNL3OVnr3GnfaBSJy0XIjHfuWta/klQw/Q9dAg8a6ueBp/QQCaDnLzMG2tjI0Z7WiuriV5I+Y0W5hDtbBOoFtjdePGFXmd4J654ceXj+MosxpJIoRvQJ44F0KFdzN+5WmH3H7tc7i3Bdi4UG0NbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667243; c=relaxed/simple;
	bh=pp1lR3IH3xjqXSGISXSYQbYuh+KI3XXPVhbl/xG7C1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T05GDM9TAdXIqVdjWO+rEwb9/8+IYsMJphf2NggIQqPFAV1c7HbHis9tAKnL9t6N61yC/b9ATBGTae6dDTi8V4oHQI6jKZxU4M3L6y4x7tZcSgH5lxKHxRQ0QUtsNA7z7R+iri6l2Aw3XcHPKwk/8tkb0fWEiJAKPaIfL7X6djQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL6Dp5Vn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL6Dp5Vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCF41F000E9;
	Tue, 21 Jul 2026 20:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667241;
	bh=hyyjObVbcrC7LHeWDi/kBKJ6KeLjo/+Ovw01snoF9Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eL6Dp5VnWGcxb+2Tc0YR5NaSgH1A5FYTB7Jpni7CAwfdsmC3La6rDVQzC4iXjQBW2
	 xQ9kXudpLd2ACJqtH2mvs0s5MeqTqxi0a7sqLWoGyUtnEoh9O7lVnfJHLaUFGijyhI
	 XGP9f6A3ownqYlC4Rz+MMmydF9sdmjmRlghr6ciE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 0987/1266] power: supply: charger-manager: fix refcount leak in is_full_charged()
Date: Tue, 21 Jul 2026 17:23:44 +0200
Message-ID: <20260721152503.921294491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
 


