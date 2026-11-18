Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026446;
	b=pgJEKVbQ2b/gkSewT0fUTNanzeJgUuk+l2H1Oiq7VJF9n0rMiSgTwarKIQKz2phODmKx
	 A2reK300ArB27EJaL8/Nl1Og7zlEJUtNj9PeicPCH713mug0TzP04PwTVZ57kA3ZwcRR+
	 iQ6kRnF5vvBysB4iZomGnH8W9NDz+v8PNLsDmXh1xUIhCLuvYs9wi6+CALdZvML8kItJ/
	 y0By+NzWoLK91onFqtjOnU1pjsfqeJDfW/5cDH12IVZpZE6Jy6+/XwEBWaSKrcxNx82pi
	 6yXR4Q8rn+40Tg7JBvvOAzQo+mNpV0v65rhhJTVMJ9X0pGhHi6DrBLyeplSbQmFrvZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sqNRRp/m9uJ6kL8JAjPrvg4eIwGxbQj/ntd7bbn4cYc=;
	b=dL5E1jCQM/7qeDVDpxel2FuYxit+/TaMoXYq2W+6TQir0fmX1qhff/8kD4maZIKW+gpJ
	 /kA/gzWAicXdglWEK8Wu705Q6DvrKrgLHV4ygc+AWw4kA6nsQClnuNWoAAAygeaNNMIYH
	 021hBxV4gdgpudj/Tugxx+n0TIPR/qdLD+7oo9u94u7L+bFtGa/Q2XSlLlCCfMoYbv7xk
	 x4MJZcPAem6zDtXKIVj4xgpu/zpebsZ5qsADFiebTyijmaIXi1BAs4CAX+NPYVIEi3oQ3
	 NST/UOE7LnTKz2GkdTtbYElo3/Z2bQZSuxSFCE9xKWeIZ0xL04BWF/s4PHdbeDC+c0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kz4epx0u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12388606A31C;
	Wed, 18 Nov 2026 18:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kz4epx0u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6461F000C4;
	Wed, 18 Nov 2026 18:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026445;
	bh=sqNRRp/m9uJ6kL8JAjPrvg4eIwGxbQj/ntd7bbn4cYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kz4epx0ueic4M7+78aC4ZnzUAYHXo7w0KPkybbaqvHnBBXsz2eeZogZq8iajvTWRU
	 x7Graw4odp/eWuKX7mTnSE7y9yT7hw2gAiwOp7qcE22H6HU+UuqHrt6CiFitwurlvx
	 zlPx04YYn4FzZMCH8j1Fy3YplLT8+AGcc6EzUOAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgi Djakov <djakov@kernel.org>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1421/2151] thermal/drivers/qcom-spmi-temp-alarm: Fix temp_map indexing
Date: Wed, 18 Nov 2026 15:52:36 +0100
Message-ID: <20261118150213.720837811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgi Djakov <djakov@kernel.org>

[ Upstream commit 51c262cf2aa9dfd97591e570d4e82af493ad1689 ]

Fix the following issue noticed when booting on the db845c-dragonboard:

BUG: KASAN: global-out-of-bounds in qpnp_tm_sync_thresholds+0x11c/0x180 [qcom_spmi_temp_alarm]
Read of size 24 at addr ffffdd2495f01200 by task (udev-worker)/371

CPU: 3 UID: 0 PID: 371 Comm: (udev-worker) Not tainted 7.3.0-rc3 #116 PREEMPT
Hardware name: Thundercomm Dragonboard 845c (DT)
Call trace:
 show_stack+0x18/0x24 (C)
 dump_stack_lvl+0xa4/0xf4
 print_report+0x1f4/0x5ac
 kasan_report+0x84/0xcc
 kasan_check_range+0xf0/0x1a4
 memcpy+0x3c/0xa4
 qpnp_tm_sync_thresholds+0x11c/0x180 [qcom_spmi_temp_alarm]
 qpnp_tm_probe+0x3dc/0xae8 [qcom_spmi_temp_alarm]
 platform_probe+0xc4/0x18c
 really_probe+0x17c/0x4fc
 ...

The buggy address belongs to the variable:
 temp_map_gen1+0x60/0xc4 [qcom_spmi_temp_alarm]

It looks like temp_map is a pointer to the complete temperature map.
Indexing it directly advances the entire map, rather than selecting a
threshold row.

Fix this by dereferencing the temp_map before indexing it to select the
requested threshold row.

Fixes: 703f13285a6c ("thermal/drivers/qcom-spmi-temp-alarm: Add temp alarm data struct based on HW subtype")
Fixes: 1f835c6a4c84 ("thermal/drivers/qcom-spmi-temp-alarm: Prepare to support additional Temp Alarm subtypes")
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260928132823.1426513-1-djakov@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/qcom/qcom-spmi-temp-alarm.c b/drivers/thermal/qcom/qcom-spmi-temp-alarm.c
index f39ca0ddd17b6..67eb763276eaa 100644
--- a/drivers/thermal/qcom/qcom-spmi-temp-alarm.c
+++ b/drivers/thermal/qcom/qcom-spmi-temp-alarm.c
@@ -345,8 +345,8 @@ static int qpnp_tm_update_critical_trip_temp(struct qpnp_tm_chip *chip,
 	}
 
 skip:
-	memcpy(chip->temp_thresh_map, chip->data->temp_map[threshold],
-		sizeof(chip->temp_thresh_map));
+	memcpy(chip->temp_thresh_map, (*chip->data->temp_map)[threshold],
+	       sizeof(chip->temp_thresh_map));
 	reg |= threshold;
 	if (disable_stage2_shutdown && !chip->require_stage2_shutdown)
 		reg |= SHUTDOWN_CTRL1_OVERRIDE_STAGE2;
@@ -535,8 +535,8 @@ static int qpnp_tm_sync_thresholds(struct qpnp_tm_chip *chip)
 		return ret;
 
 	threshold = reg & SHUTDOWN_CTRL1_THRESHOLD_MASK;
-	memcpy(chip->temp_thresh_map, chip->data->temp_map[threshold],
-		sizeof(chip->temp_thresh_map));
+	memcpy(chip->temp_thresh_map, (*chip->data->temp_map)[threshold],
+	       sizeof(chip->temp_thresh_map));
 
 	return ret;
 }
-- 
2.53.0



