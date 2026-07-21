Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E810F4432F7;
	Tue, 21 Jul 2026 22:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672427; cv=none; b=kbwgbzaTbp2YOX0LP65VG+y+bFXgmHbqSRxx6wt1Q8sDUxJuDxuaexsvtGMY0j+hKP+aa/FjWdoszmtO6TV2X/3Qw1vUR/0w5fw154JotEPrfLvmYOxh1XBJt7l1nlfgRopt4C/Eko7bIm2wfnjIVQIUWTPd7yNPystYtw8XsSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672427; c=relaxed/simple;
	bh=5hIfKLFRrHum2DPEL0uCwJG2P2LPbpNzo2AHtSfukgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVUG7zxzRmXdArEAFzjvNJwgJgXW/PFGK3DUhEC3LrsyVt7DUA47yoW58wS8G4LCB6/xINEABXCgNZZWngWR03oqP13eDj1Gnriq3kn1DyXzV2IXzS8+EqFFYZ40lzjmS1IpW9opS6O45+Jp1yezmVfJWTrC3EscBeK1UqBYCHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzczUgXh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzczUgXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D6E1F000E9;
	Tue, 21 Jul 2026 22:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672425;
	bh=JOYOAO9xni6tssq73QJ8qaHmfaGdiFXn8PIzsgel9Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzczUgXhDUC33mxUqL1fzU6evCO3SJjj20WBwMOoD/8J9pTLx9GE+L256++bvDheZ
	 7K9e/MU+hTS33RbE2n8hnstyAHyho0NtKstkJ/V+2b9F3fJbnnRlkvBQUu8B1ezXS3
	 RwbylYJMea2rsJ9uRvEtL4gaxzV6eNQALbsvr7kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 619/843] power: supply: charger-manager: fix refcount leak in is_full_charged()
Date: Tue, 21 Jul 2026 17:24:14 +0200
Message-ID: <20260721152419.985158999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


