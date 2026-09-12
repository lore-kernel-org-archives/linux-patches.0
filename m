Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6002A2264A6;
	Sat, 12 Sep 2026 09:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206559; cv=none; b=CfEQPdRlWNKVo0purgTeOm53wUqV6YoFr76b5h3nQ8BcAt4A2sE8yxOhwGthWrvL5r3pAmGeQqM4by+zEtVDm0dYELXNQ64DX7mfK/51uVr3aUqG+aZ6Q271iQzqiD6ymWsielHqa0p51vEX8B9Am1d0BeSSr09wA7h8rJS42pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206559; c=relaxed/simple;
	bh=AiFxXzbG6G/eRpQUgp0hV8cYVHK5Q8/J9IIhBKe9Tv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O98A08ehezn3+hqHMh7xW6Hmh5rhQ6j7CSS6ZXMykuOSwl/MJ/4uwdIJGJio6p+/cZ6G3zzpNCeZT5QcR3vEalQv8tpKDRghsAPLUfDbXPurp0ZUfUcoWKowloOdmtw7xDKCyRq2A8F4J/7kcq++ONCXZDvxxb5rcgQalm5YkTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTePFPXs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTePFPXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003881F000FF;
	Sat, 12 Sep 2026 09:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206558;
	bh=n9y3/ZfwBTwPbONiiXlbK+qUylgdg2jndvsDrkZmnX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTePFPXsAV2ISdZDICPMOHSHA/vngDROWd+caXTUlmUa23FSwiooSR/C3RUF9rkvw
	 fdwbnn7j6c5ndQtqIJXy6b7w3bDtmuD6+YTqNobE8IS82sOyT08+inLl0h2NORVYVT
	 j0a9+Cv3ZUSGx7vpwp5MWRy7hLixM/K+uRt5ILio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Figa <tfiga@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0188/1518] platform/chrome: sensorhub: Fix memory overread in ring handler
Date: Sat, 12 Sep 2026 08:39:17 +0200
Message-ID: <20260912065627.742703141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit d1ceb2b2324717fa30b44d56ef0c52813e239569 ]

`max_response` and `sensor_num` are read from different EC commands:

- `max_response` is from cros_ec_get_proto_info().
    ec_dev->max_response = info->max_response_packet_size -
                                    sizeof(struct ec_host_response);

- `sensor_num` is from cros_ec_get_sensor_count().
    sensor_num = cros_ec_get_sensor_count(ec);

With a malfunctioning EC firmware, it is possible that the `msg->insize`
(i.e., `fifo_info_length` in the context) could be clamped in
cros_ec_cmd_xfer() because `msg->insize` is greater than `max_response`.

    int fifo_info_length =
            sizeof(struct ec_response_motion_sense_fifo_info) +
            sizeof(u16) * sensorhub->sensor_num;

This means the number of read bytes could be less than expected.  As a
result, the subsequent memcpy() in cros_ec_sensorhub_ring_handler()
overreads the `resp->fifo_info` buffer.

Check the return value of cros_ec_cmd_xfer_status() and abort if the
number of bytes read does not match the expected length.

Fixes: 145d59baff59 ("platform/chrome: cros_ec_sensorhub: Add FIFO support")
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Link: https://lore.kernel.org/r/20260702082745.1014968-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_sensorhub_ring.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_sensorhub_ring.c b/drivers/platform/chrome/cros_ec_sensorhub_ring.c
index 302d037b90a1f..b5970e8620bf0 100644
--- a/drivers/platform/chrome/cros_ec_sensorhub_ring.c
+++ b/drivers/platform/chrome/cros_ec_sensorhub_ring.c
@@ -825,8 +825,15 @@ static void cros_ec_sensorhub_ring_handler(struct cros_ec_sensorhub *sensorhub)
 		sensorhub->msg->outsize = 1;
 		sensorhub->msg->insize = fifo_info_length;
 
-		if (cros_ec_cmd_xfer_status(ec->ec_dev, sensorhub->msg) < 0)
+		ret = cros_ec_cmd_xfer_status(ec->ec_dev, sensorhub->msg);
+		if (ret < 0)
+			goto error;
+		if (ret != fifo_info_length) {
+			dev_warn_ratelimited(sensorhub->dev,
+					     "Mismatch read length: size %d - expected %d\n",
+					     ret, fifo_info_length);
 			goto error;
+		}
 
 		memcpy(fifo_info, &sensorhub->resp->fifo_info,
 		       fifo_info_length);
-- 
2.53.0



