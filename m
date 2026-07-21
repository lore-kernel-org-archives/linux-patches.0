Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AE040244D;
	Tue, 21 Jul 2026 17:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654477; cv=none; b=P3iwuOdI6za8CUTC16+Pzq+2P/hgCCJMTtfsvHynN3VtZw85DFgu5T+PKuV8ZtGaxM8t/lwWE95eOcmUktgQtlngO77rbd6qRFz00giqWqOSJtq7CLffijfv1NePV8nxRaosBIZJsf2sFDexw+IMle8IrqtWOnI1Gawt15loF4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654477; c=relaxed/simple;
	bh=B8dUpPf7ZwtAg1KnX4HfE6YTlK2CzfmozfrWXUAdJnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLZgFTevzGZ+V22Stt3IzNDq6n7Imz+S2awlbbI4kvB9qGC3i6e6MAB/q7SJKUHi20S4ndWPfJ2J/lzFNuVWeFFTMNgIOX8IYy/CpClDFJd/qC1+x9GGLQx0iJUt4gfhwRNmnkmdOopWr/7Yc50Zu7iskW7r4znfmKR/Qlmikrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UM4HetBW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UM4HetBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E571F000E9;
	Tue, 21 Jul 2026 17:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654476;
	bh=D1F/dgiU7DEQqsVk8rXSpyf4Wtc0W6WRn1BmU9nLa88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UM4HetBWQLp3Ypbw3D2iT5UzLbJArfae68F9K9gLSdmbQ08mHOGuYWxQfvyn+LICd
	 NCeeoS+YO0NUOOmE3k2huRtKEJiDMTcDQhQeUkWtMh5B5rxnXMx/wof2zqaNHJFX1v
	 wn2XVyXabAnEjQPBD3YCKjqyA04CL8gmnUZY76kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.1 1720/2077] power: supply: charger-manager: fix refcount leak in is_full_charged()
Date: Tue, 21 Jul 2026 17:23:13 +0200
Message-ID: <20260721152633.323307659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -303,8 +303,10 @@ static bool is_full_charged(struct charg
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
 


