Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EA42594BD;
	Sat, 12 Sep 2026 13:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220743; cv=none; b=NyDBeRs/EJ7eH89PIcyI8/ZMoFizscVILJVR7EJw4hrTT8ZvFumouhr2bjHKKPm43At+VBRS8ftuEk8LF052tgYsrsNDmmEOwD6i+oRRfJFETayRpDMtkfKsJt0BO0msUfe9KohDLfTrS90yABOy/Z1QhoVpZS33O3zMOu3LNoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220743; c=relaxed/simple;
	bh=KJ5i5iOjdaScgATWLuMKW+zGZNFjpmKbtckfR5uqGN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUuajrTTNhbnieIkfmOlealX18nOU4/tRdMvUotfKAM1Comb0eWA358LAgtZd22rqewLL6Ux73lzpW1aLpzVmJvjfvuIEkvTrySsydhghZHsEeV1PSGPWmfvd6ofNohlP1285rQ1jMFEfy7DFhEadJb7Rkk6Jace0gDFab51WoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8qoDtPW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8qoDtPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF50D1F000FF;
	Sat, 12 Sep 2026 13:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220742;
	bh=TMo/qzl61QNbdaUrmLFYTJ3z5e5rWHqtI8P624YyfNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q8qoDtPWPsPfwKTmr7fUydndDRvyaTPWgDeMR/3L15X6Guj1TntSUBupyuWE+mBR3
	 pE0/f7OyJpWoWa3Gwa0FgGAZNz4/oWPveGa7NGworBWgv67yCxAeIsIWJYeOBVgDn2
	 twXtPSxM8mHpHg+hGu8I8aDD5NbaffoLHoz3C8sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.6 0239/1424] platform/chrome: sensorhub: Bound the EC-reported sensor number
Date: Sat, 12 Sep 2026 08:44:31 +0200
Message-ID: <20260912065612.635271200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 833740a2333c2e4db4e02e3d0ffba04e8718a5f3 upstream.

Each EC FIFO event carries an 8-bit sensor number (in->sensor_num).
cros_ec_sensorhub_ring_handler() validates the FIFO event count, the
per-read count and the ring bound, but not the sensor number, which
cros_ec_sensor_ring_process_event() then uses unchecked to index
sensorhub->batch_state[] - allocated with only sensorhub->sensor_num
entries. A sensor number of sensor_num or larger is an out-of-bounds
read and write of batch_state[].

Validate the sensor number in the ring handler, where each event is read
from the EC, and drop a malformed event before it is used.

Fixes: 145d59baff59 ("platform/chrome: cros_ec_sensorhub: Add FIFO support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://lore.kernel.org/r/20260618-b4-disp-adb3f790-v3-1-3a164ed63cbd@proton.me
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_sensorhub_ring.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/platform/chrome/cros_ec_sensorhub_ring.c
+++ b/drivers/platform/chrome/cros_ec_sensorhub_ring.c
@@ -851,6 +851,14 @@ static void cros_ec_sensorhub_ring_handl
 
 		for (in = sensorhub->resp->fifo_read.data, j = 0;
 		     j < number_data; j++, in++) {
+			/* Skip event if sensor_num from EC is out of bounds. */
+			if (in->sensor_num >= sensorhub->sensor_num) {
+				dev_warn_ratelimited(sensorhub->dev,
+						     "Invalid sensor number %u from EC\n",
+						     in->sensor_num);
+				continue;
+			}
+
 			if (cros_ec_sensor_ring_process_event(
 						sensorhub, fifo_info,
 						fifo_timestamp,


