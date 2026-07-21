Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA22F347BC6;
	Tue, 21 Jul 2026 22:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674277; cv=none; b=FSx/pc8StmrG7FKh3os5hQcxG9mK4eS86FtEAi0kI6gTVv2gKaPwTM4RSh/VZDxxFNfI7fgaNRBYiiKpuU65MF2Evf0tPHz+13ew0SlIeB5Nu7GRvUANcgO6LACKJWXiIR7Dp/SKv+pLYsHChG6AZ/5UoYkce9CToscu2ljNGWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674277; c=relaxed/simple;
	bh=3oVcyNePPrcKJiRNiYjUWL0ZD5wYHYNQjtXAczZVK6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LllvtA7vNdqh0z+HynbwCLM1rrRLRtVEDFkROP3BB0uh4ORxatQwuR5Uu54OCEmRGrzelx6Bczm/SLo3feJoL/Nelx04t40urzVdisxVEIDeWNwRIpH2e34eQgj8lt5dzevG2IaQbzWTrqGezHQIyHl+rr9Zlw8nfQ80t0LZvxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuCYs1c8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuCYs1c8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAF41F000E9;
	Tue, 21 Jul 2026 22:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674276;
	bh=K7ZCQzpWFQdWsjX19KdH1wlJugCPxUwETDED+slfxo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yuCYs1c8JB8fd4APOmCuNuslvMjoQ10AC4wc6DVD4RoHXwuzrhfh4W2jWeF/oS4CS
	 aMHqjex6vwSsJ9qQxWhge1z80E/dWE+CkQqrShVFtJLYo/MiJvfLQBjv4jUPXaY8IT
	 tMeFABqjMY3nfny/qGWr1MRRwpfcdhGRULqGvRhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.10 479/699] power: supply: charger-manager: fix refcount leak in is_full_charged()
Date: Tue, 21 Jul 2026 17:23:58 +0200
Message-ID: <20260721152406.506280025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


