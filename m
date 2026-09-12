Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CE347986A;
	Sat, 12 Sep 2026 12:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214761; cv=none; b=Xxj68H0a/3HUr51/fqCHbDPEmFBjIizHBbwNGzb2I8NOBxXmNbnavpvBfuKuzChwkV5MhBKCIYRigA48ER5VifYFN5DfxyDyzM7DkTuTKDwF38NOQYCfUoUMkQ3BnUMzqo3NRnMes9VadsPDfeLEo93uP0ozg9ITyULOIwd2rdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214761; c=relaxed/simple;
	bh=eYykKP7jwbto4O4dAJJBpuBAHCeobbD8N5WA9Pl7HRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwA9eBs6GcBb+oJV/L96sw+iJFN9gad+qFhJu/Bx8jj4ifJRMlDQ2Hqm6uKEGI6nNtj/ezvinJAyG7ATolfdiPmoOf43L6/bxwHJ9uPnM1zr8QPKdyxg3IU+UhmMMxbHUBCgq4LUBE2JLZ7qTh2mmFC2tcWLQaDmxuVJOJIxjf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuQd+NTT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuQd+NTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD20C1F000FF;
	Sat, 12 Sep 2026 12:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214760;
	bh=k359ag88K9l31PEepuEVZvseVRzC9klTa577B6+3INY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xuQd+NTTUhO7Xq3AhOz0ZSxrjwDi7NrsfWii/vK2XzjGSABmTf/cm3ZGaNDvIpuD7
	 LcsQcbUXA+d4bWfk9mprmSigewCeFUQAx9QLhbG/GN5prshDd/86HRfaX13yFwSAPU
	 79VCaD0S5+qEtKl8Ag9j448YZ2RCvcsFWEfg3Uak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Figa <tfiga@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0393/1376] platform/chrome: sensorhub: Fix memory overread in ring handler
Date: Sat, 12 Sep 2026 08:46:59 +0200
Message-ID: <20260912065616.305294005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



