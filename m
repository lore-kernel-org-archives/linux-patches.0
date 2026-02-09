Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABE637BE7F;
	Mon,  9 Feb 2026 14:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647826; cv=none; b=gbfKQJOj5HVlEvp0Xloi1oqeLI+rEp7puYrB7zGg6gTHXExgE1/Tm/WKuJLxt0Ile2eMkRB1M4q4u4qcSA66b3ceccRUQlRsv5ahKVcNX+awf5ESaKdrGfFmbbR3sanYBX0a3NqZWzaknjsDi9W8krCZyM8tkGq03+IEY2JNLHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647826; c=relaxed/simple;
	bh=kduJ6wBp1it3TVxK60XvPuuALzB2tfHKWNdowMvOLNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUhL1U2Js+J0xaxwys/sJSfXGxfFW9SvRgTXeVF/ZJYuNCIlpN8cGFtGtpCLO3KEW6WCSKNEJ2EbnAc2Gmzm8Piazn9ePs329DsH9KTASgOL4ASld8LGnWbAuUH5ewmsk8QTa6QzjQVpbVrNJ9SmIq3cox0R/VmMeEqSVGjBqoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0bpEZbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0bpEZbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D06C19424;
	Mon,  9 Feb 2026 14:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647826;
	bh=kduJ6wBp1it3TVxK60XvPuuALzB2tfHKWNdowMvOLNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0bpEZbQyhPaEfPdw2L0g4XSfrr4X8m933Atkx8iVg5tKruMb9jATWonavczt1YQP
	 IXk1VLWuJibtZJA/NDMW2Ih0jemD7nyHYGkHkxO8hKZLXAcEyinewZH6ywnx0exAeX
	 iqjvr77Ydw5N8teILAJBzuq81qz7QBkwGY421a+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/113] HID: intel-ish-hid: Update ishtp bus match to support device ID table
Date: Mon,  9 Feb 2026 15:23:09 +0100
Message-ID: <20260209142311.648083447@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit daeed86b686855adda79f13729e0c9b0530990be ]

The ishtp_cl_bus_match() function previously only checked the first entry
in the driver's device ID table. Update it to iterate over the entire
table, allowing proper matching for drivers with multiple supported
protocol GUIDs.

Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp/bus.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp/bus.c b/drivers/hid/intel-ish-hid/ishtp/bus.c
index 1ff63fa89fd82..fddc1c4b6cedb 100644
--- a/drivers/hid/intel-ish-hid/ishtp/bus.c
+++ b/drivers/hid/intel-ish-hid/ishtp/bus.c
@@ -240,9 +240,17 @@ static int ishtp_cl_bus_match(struct device *dev, const struct device_driver *dr
 {
 	struct ishtp_cl_device *device = to_ishtp_cl_device(dev);
 	struct ishtp_cl_driver *driver = to_ishtp_cl_driver(drv);
+	struct ishtp_fw_client *client = device->fw_client;
+	const struct ishtp_device_id *id;
 
-	return(device->fw_client ? guid_equal(&driver->id[0].guid,
-	       &device->fw_client->props.protocol_name) : 0);
+	if (client) {
+		for (id = driver->id; !guid_is_null(&id->guid); id++) {
+			if (guid_equal(&id->guid, &client->props.protocol_name))
+				return 1;
+		}
+	}
+
+	return 0;
 }
 
 /**
-- 
2.51.0



