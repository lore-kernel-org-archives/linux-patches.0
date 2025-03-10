Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7C41C3F34;
	Mon, 10 Mar 2025 18:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630847; cv=none; b=PQGXJjTRw8HffFpyAWu+U2iD9QNEUjnu+KCz72L3bqZkSCz8ghmJhohX9WnL8cWaSO9zU7UociH/AxVlbvJXSV65cYYiO+8PXRrUIw/03I10ZQxj96cSx9UP8ciLB9R4LHIpzJW6r1IfxUBXuefbkmXpVHanO+8rp22vGHtABDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630847; c=relaxed/simple;
	bh=ol6CODX3k8P5NkFPy3cmnH8/gajJsfIgyo+5CJ/YETE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pM6pMyk15qCBfbbbrhKgUtlGM1EaM+UaIE+zw8zHm+av1huPsOBC5+NuVd+q4g2olz8LPgcvt6rIqf8/HjBmSNw0SCBtr04/dTaGzcDqEfNZcQjGQO0HtQ8XQgRKXUQpYmlALjHRa/vlj6TahxvlewukZD3w/fVkezH8xxwbtKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJXZWu9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJXZWu9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DF4C4CEE5;
	Mon, 10 Mar 2025 18:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630847;
	bh=ol6CODX3k8P5NkFPy3cmnH8/gajJsfIgyo+5CJ/YETE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJXZWu9KsRjJUM0vpSsOBxkCb564xodJFbqtKAHLzefqMDEbO1+4U8atq9cjbKzFq
	 H8cDMiGrCyLcyTsA/IrPyPk4+cNJEVZopPT9hrvduEGeSv3gHUwfL2WQTin1OjdgDh
	 D1QBFaeoyx3D8l5jMfP7yd4m8y92qlbhPxkYCnzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 554/620] HID: intel-ish-hid: Fix use-after-free issue in ishtp_hid_remove()
Date: Mon, 10 Mar 2025 18:06:40 +0100
Message-ID: <20250310170607.416869364@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit 07583a0010696a17fb0942e0b499a62785c5fc9f ]

The system can experience a random crash a few minutes after the driver is
removed. This issue occurs due to improper handling of memory freeing in
the ishtp_hid_remove() function.

The function currently frees the `driver_data` directly within the loop
that destroys the HID devices, which can lead to accessing freed memory.
Specifically, `hid_destroy_device()` uses `driver_data` when it calls
`hid_ishtp_set_feature()` to power off the sensor, so freeing
`driver_data` beforehand can result in accessing invalid memory.

This patch resolves the issue by storing the `driver_data` in a temporary
variable before calling `hid_destroy_device()`, and then freeing the
`driver_data` after the device is destroyed.

Fixes: 0b28cb4bcb17 ("HID: intel-ish-hid: ISH HID client driver")
Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp-hid.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp-hid.c b/drivers/hid/intel-ish-hid/ishtp-hid.c
index 14c271d7d8a94..0377dac3fc9a0 100644
--- a/drivers/hid/intel-ish-hid/ishtp-hid.c
+++ b/drivers/hid/intel-ish-hid/ishtp-hid.c
@@ -261,12 +261,14 @@ int ishtp_hid_probe(unsigned int cur_hid_dev,
  */
 void ishtp_hid_remove(struct ishtp_cl_data *client_data)
 {
+	void *data;
 	int i;
 
 	for (i = 0; i < client_data->num_hid_devices; ++i) {
 		if (client_data->hid_sensor_hubs[i]) {
-			kfree(client_data->hid_sensor_hubs[i]->driver_data);
+			data = client_data->hid_sensor_hubs[i]->driver_data;
 			hid_destroy_device(client_data->hid_sensor_hubs[i]);
+			kfree(data);
 			client_data->hid_sensor_hubs[i] = NULL;
 		}
 	}
-- 
2.39.5



