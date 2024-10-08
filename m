Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9EC1C9B99;
	Tue,  8 Oct 2024 13:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392749; cv=none; b=dgsw1g5mzC0QqT9mmSQ7BH07SWR+kUShc/OGgoiuJpaUSp0IH/aFwJ+nOvF0xISMk212SbtwztbAZnnUZuz2nOIC+qeo7uo75O3daWiFqlvRTFjMQ7zEZc0H8+uKTOAxQOyhygvOmWMU19+nuLqYmejvP55bAHVO7DMDqLtHeFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392749; c=relaxed/simple;
	bh=NilTKBFxrD2lk05NIW9a44Z4hL/MCoimxog0y2TsgX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QklHUGJqioGnMVGkUjF5MJD8/R7sA2eW5+sDbBeg7BWwdHQc/0BJkFzG9zxxeRPtzOur5mmhZALTL/McqcklFeukByPj8il20n6S5pARy//SeaYUcJ+8+nxDnmGoedxcSGcgOvvM7jChT2zv8eCC45IT1SxxMBwUlcvG0oOYzLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxZ+1zU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxZ+1zU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA74CC4CEC7;
	Tue,  8 Oct 2024 13:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392749;
	bh=NilTKBFxrD2lk05NIW9a44Z4hL/MCoimxog0y2TsgX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxZ+1zU5LjSpqZ3tz4P5ETK3TBiJAp4RtBhUvyz3zRV6yrnJHswJ1vnLlx5pZkXOa
	 xM9DedsWJtB8x4ROIJO4usjo4xKa0kvg/LUTgLl3G4jEvkfnl7lpSdPKE5oORjyNiv
	 /w4CBtlmQmcXHvH42r4Jv1p39t0V+XH3zrAfQu6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Ye <jiawei.ye@foxmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 6.11 506/558] mac802154: Fix potential RCU dereference issue in mac802154_scan_worker
Date: Tue,  8 Oct 2024 14:08:56 +0200
Message-ID: <20241008115722.143116041@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Jiawei Ye <jiawei.ye@foxmail.com>

commit bff1709b3980bd7f80be6786f64cc9a9ee9e56da upstream.

In the `mac802154_scan_worker` function, the `scan_req->type` field was
accessed after the RCU read-side critical section was unlocked. According
to RCU usage rules, this is illegal and can lead to unpredictable
behavior, such as accessing memory that has been updated or causing
use-after-free issues.

This possible bug was identified using a static analysis tool developed
by myself, specifically designed to detect RCU-related issues.

To address this, the `scan_req->type` value is now stored in a local
variable `scan_req_type` while still within the RCU read-side critical
section. The `scan_req_type` is then used after the RCU lock is released,
ensuring that the type value is safely accessed without violating RCU
rules.

Fixes: e2c3e6f53a7a ("mac802154: Handle active scanning")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawei Ye <jiawei.ye@foxmail.com>
Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://lore.kernel.org/tencent_3B2F4F2B4DA30FAE2F51A9634A16B3AD4908@qq.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac802154/scan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -176,6 +176,7 @@ void mac802154_scan_worker(struct work_s
 	struct ieee802154_local *local =
 		container_of(work, struct ieee802154_local, scan_work.work);
 	struct cfg802154_scan_request *scan_req;
+	enum nl802154_scan_types scan_req_type;
 	struct ieee802154_sub_if_data *sdata;
 	unsigned int scan_duration = 0;
 	struct wpan_phy *wpan_phy;
@@ -209,6 +210,7 @@ void mac802154_scan_worker(struct work_s
 	}
 
 	wpan_phy = scan_req->wpan_phy;
+	scan_req_type = scan_req->type;
 	scan_req_duration = scan_req->duration;
 
 	/* Look for the next valid chan */
@@ -246,7 +248,7 @@ void mac802154_scan_worker(struct work_s
 		goto end_scan;
 	}
 
-	if (scan_req->type == NL802154_SCAN_ACTIVE) {
+	if (scan_req_type == NL802154_SCAN_ACTIVE) {
 		ret = mac802154_transmit_beacon_req(local, sdata);
 		if (ret)
 			dev_err(&sdata->dev->dev,


