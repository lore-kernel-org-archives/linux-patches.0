Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764AD26AC3;
	Fri,  4 Sep 2026 05:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499877; cv=none; b=rcvopkgI/osh/75+veQOeGAor/VPR7PGk4XLgoP0JzTqcehifS2N4uyllyHGvIWrXHrsu9+waRm3a4/hC9fM89F1XxNFzKXZHS04UgslpZ8kNrcUixQMwDcrl2gVFVS3G3OfvUBGdXY/qDthVBasz5xN+p8rkSbWyN+fujjpXrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499877; c=relaxed/simple;
	bh=l8ey4f8h4I0EclJwpfE13xlrQMWxyLmCReQSMrdZjvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xtxy41/k9Zth9Np5YZp8UUQXUn80GsTfSCsK4npGWGEeczGD/6btOM/qzbsVR4Ir8H3ZUvj9dS2df6BGRjNBUZAoR3pBeJTeHSzKvego4sZMqu6ojhiIMmPgNUlDLPB6YIdUhIQpJjH3P2h8DVgK3AvEqJ3ZkkYmlID3XxbbU+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fWLNWu8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fWLNWu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A4B1F00A3E;
	Fri,  4 Sep 2026 05:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499876;
	bh=jWcFu3kgwAD764z1JzOYyFYxzvrSA0BdQtCo04a/c10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0fWLNWu8OEfTDkKC0ZXqHf0s7PjTx9baqyTA61eA1YkC5yUj56sDL2PtjhB9VwgMf
	 /hu/LjTygIhEK2FeWN5FGSSLaBYsAv+n69yBpwUK8FW2ypXneo/j3fY5FHJyfGSS+N
	 OMoI9WU6v4o6Q2SP4nAQHbnjFyM3BudiSfQP4kJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 7.2 571/713] platform/chrome: sensorhub: Bound the EC-reported sensor number
Date: Fri,  4 Sep 2026 06:58:59 +0200
Message-ID: <20260904045816.620147370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -890,6 +890,14 @@ static void cros_ec_sensorhub_ring_handl
 
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


