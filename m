Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDB8344DBD;
	Sat, 12 Sep 2026 19:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241586; cv=none; b=kRp690VYzTM5RlPUQv3wVGap2iGctO6AX71Jj2YUSqFmlKjpCgePSS0iMouOtuSKS8Mqntyxk2UWTWGmm/dmDC+uSjMzQ1+hor8HMpjJFcUYeyQFiESgsO+hJicxiCi5g5dsLi0RL5yHEYoXnry5n8qyF9IaPb17vyWSmgZ4Vck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241586; c=relaxed/simple;
	bh=ZiS8lsuwLx5u9FZ+3Cj2HmfoupPbEKHUpRiGTZ4/ldk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbFg8z0Y36oSg6L8GGZKzL6cWxQUvpNrT4Wsozt6ldzWlpqd2Jmqw2ZijaOF2cAoYYNsn7D9EkSwugJfoEjU6rZ8NE1ESoc9SblS2wXk8DCUrDiBKgKnacH3eYGLiuefSZONNcwpMNjP4X5RjL40j/ih/ohq1IxBZFjsgh5f6+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3zmsJ5X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3zmsJ5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879A11F000FF;
	Sat, 12 Sep 2026 19:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241585;
	bh=G08u5Y1kwCubc+aTIEhpvBv3cpD78jTNlB4lM4m2xn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3zmsJ5XMJ//prbbNsiZG7z1yH+W4m3ndUiaQTctB2U2EAabF3ElopkV40Fg263wB
	 Ji/8gq0SPJx7ZgH2c+6AY5LNM66snt6Z8EhMfnwBIt2b7lEC8ookzDjwRs8CeTa05P
	 oz8oAkN2u91Ts6F56VhfHfhpVJSzM5NTaAlQ3QSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 5.10 149/798] platform/chrome: sensorhub: Bound the EC-reported sensor number
Date: Sat, 12 Sep 2026 08:56:17 +0200
Message-ID: <20260912065520.414716640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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


