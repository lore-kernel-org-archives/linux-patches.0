Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6876A3F104F;
	Sat, 12 Sep 2026 07:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197419; cv=none; b=BGL0K6jS55n5ggHOHE98cRAwX/AYjLuGp4y+EJ6zF6iJpi6gl0Jd0YEqO2aHD5QgEIF25BuziWZdZ3c/LcIqGtzJKPOWcXvHJz+AYeDTrBjZQbjGGreqxQ2cST9PDV6oXqgWxkDrg5g+Wf9ME7J/6nwrQ85o5nAcClFm66B/tb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197419; c=relaxed/simple;
	bh=bxVjQKKH7Th8c9dSQWxKE/hGOK7xtTiqj7XUTKpIo/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0C/Jjo/hJkEjTvhujSeomAtuLGeGwoksSYzfYYh3qSVSZYEcc5F7PNo5WViikL0DvBYyYm/guWDoNDys316p9E6/XjMTwCXQ6LGbOhaMbk1PNVzjc4hsGj8H+ZDTcP8rcUGTiH8Ks2kR3/RX6hzLjnlHCugQrIw6zrlk/vUDMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVYErSG3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVYErSG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4941F000FF;
	Sat, 12 Sep 2026 07:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197417;
	bh=biozp/8lrC+AnLqQqy9vc4wGGH5WG5WQbM9vpOLz+0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVYErSG3Znk24u2ZPfDtVyms2cGC49b0NzgtgsDaoqV0vWseKJ14rglsmvwH2lniN
	 NYvcBNQFPLrCM6mdUGBGodmZp3D7cuExdVWsfZU7l2zVdknU+GdF6q0Go/Cplcd+W1
	 zFDABDIzr5CgDe5o9QyzK2XvLVtDUQ9ZYOrKCv3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Figa <tfiga@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0169/1815] platform/chrome: sensorhub: Fix memory overread in ring handler
Date: Sat, 12 Sep 2026 08:31:59 +0200
Message-ID: <20260912065652.973680447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index e613dce244302..d92b602137207 100644
--- a/drivers/platform/chrome/cros_ec_sensorhub_ring.c
+++ b/drivers/platform/chrome/cros_ec_sensorhub_ring.c
@@ -836,8 +836,15 @@ static void cros_ec_sensorhub_ring_handler(struct cros_ec_sensorhub *sensorhub)
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



