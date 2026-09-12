Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C28221FD4;
	Sat, 12 Sep 2026 15:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227721; cv=none; b=juuK4Nlt1OHC6NmF58c3tjJmi/V0HhN4RPVQa0CSBA5VvFsw9R1cJX9KwhL2gySXm0qi49VXVDtWz1Rd927p5ERcWoDcOhYx95RAy8Y0fF0hJFk1Vie67O3NbRBkaX9OFqQKpnzR/CpKtyKEVS538ShQwRr27MG8FsQcVC5MtFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227721; c=relaxed/simple;
	bh=FfzRCTEUgLSUEVjb/P8Pwj0tdO4/fgTXcneLW3B4pGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdFIkhA1tWEmQc6z2PXWZXMEk0dlIoAHeFIthKpStI2V5lar02qstkynTs3AHRJmmSfkz8TphHemruxzYGJMtvUSAdTTHrgiKx5KUc7lafU1FGx0NXc00s0bIl+N1+Lpch+7cdh1hQ6kiSjC84i3vENK9zmcx4ubwlM8LKJr97o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MHb7JPU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MHb7JPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D45F1F000FF;
	Sat, 12 Sep 2026 15:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227720;
	bh=3NtD0eXqgqPg0ayyXVGVGsl9mM2bo+7728NN1F3Ybio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2MHb7JPUKPp8R5kCXv0QFXM76XElokeAOTrWRZ9RTDxfSH02HD1AwT8i2nXQtnEQY
	 nThlS/WJWga03ztvHfCcNBmubifUlKNO3ut42TkVn3x3JQCpECsZLoCAuKm0rnlALV
	 OycS9mCUFFLnCZw32ANy5/eGts6Pv358lQCM+sgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.1 0197/1191] platform/chrome: sensorhub: Bound the EC-reported sensor number
Date: Sat, 12 Sep 2026 08:48:45 +0200
Message-ID: <20260912065552.638860276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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


