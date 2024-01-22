Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A998D3A8F4;
	Tue, 23 Jan 2024 00:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969878; cv=none; b=d+JVTlG9sm1sMjyWgyLFMhcXP1Fk6qEZFkv2JBYs83uEDlK0MZhn2IS4XFomAlbkrDhSlXk8adLPnfWv0xxxNbfWk2NOOuIhchETCc+YMFH48/FYwdoHgb0gN2XEliKsHi/tTHuyPmcibU96Xypdu5TB8B/TSX8io8N+FMvDOIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969878; c=relaxed/simple;
	bh=r21tBSc4Bd9xAkeMVtenCXwGW8FsVrldpc308MNvA1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OK9rkpw278ZHXxC9SEnJhHiNLCzIEnPpRKVXNTwoBobxiPgOzzTSs3fzgzREVmE5tH5KuJmop/U3dXi3Rq/n3emPFIFIu7rslVAKi3VyYY6tJESd0Win3PlPMOoadojwrb1eIf9mlUVmI/ja3nmThk0rwlm4FVCulaxakxGdIiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDNRTFHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDNRTFHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B58C433F1;
	Tue, 23 Jan 2024 00:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969878;
	bh=r21tBSc4Bd9xAkeMVtenCXwGW8FsVrldpc308MNvA1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDNRTFHauhE4iO9IrtijheomaWdBqp2pZ3ixxgR1W0oD3y4n/gVm8uxFgEh5fd6aM
	 QTyinl5IofQohvr3uWiwJDWkgyBKPCwYJajax+WN6GqSxPGu3AymtaRR4+jJeYXlq1
	 ZGae+fjb0rVA1nspnq8F43NrE29XyxYLRierz28Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yauhen Kharuzhy <jekhor@gmail.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.7 477/641] HID: sensor-hub: Enable hid core report processing for all devices
Date: Mon, 22 Jan 2024 15:56:21 -0800
Message-ID: <20240122235832.986335509@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yauhen Kharuzhy <jekhor@gmail.com>

commit 8e2f79f41a5d1b1a4a53ec524eb7609ca89f3c65 upstream.

After the commit 666cf30a589a ("HID: sensor-hub: Allow multi-function
sensor devices") hub devices are claimed by hidraw driver in hid_connect().
This causes stoppping of processing HID reports by hid core due to
optimization.

In such case, the hid-sensor-custom driver cannot match a known custom
sensor in hid_sensor_custom_get_known() because it try to check custom
properties which weren't filled from the report because hid core didn't
parsed it.

As result, custom sensors like hinge angle sensor and LISS sensors
don't work.

Mark the sensor hub devices claimed by some driver to avoid hidraw-related
optimizations.

Fixes: 666cf30a589a ("HID: sensor-hub: Allow multi-function sensor devices")
Cc: stable@vger.kernel.org
Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
Tested-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20231219231503.1506801-1-jekhor@gmail.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-sensor-hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -632,7 +632,7 @@ static int sensor_hub_probe(struct hid_d
 	}
 	INIT_LIST_HEAD(&hdev->inputs);
 
-	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT | HID_CONNECT_DRIVER);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
 		return ret;


