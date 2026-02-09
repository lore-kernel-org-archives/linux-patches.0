Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5EE37BE8F;
	Mon,  9 Feb 2026 14:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648414; cv=none; b=iVDG1YNM0GqSoUCmaZYaAkqXqrdVFJt2O+M9nHfFWdPEmOyvAXQW96Yx+xMyuaYuyz6HuaPnrxQ2GJ9TSmKG7pfZzI2qRlvtlJDuitJBsyzr77KYblbW6xDu9Cy1EEYkWuxzA8FOJB3qJyZOnl7xWjSvi8DVj30kLRitsqzegq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648414; c=relaxed/simple;
	bh=QpHvhPjG5lbFZ/3XPNP5k9PJV366zHq/gnV78CERO7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQO44poAeTLyyQo8FfKSHb4SPVagrQVmV2PDOmw30tMGNDduOIwgu1oR0ocpbgOBOaDkXmUqPBS/AlBxhMvRrO4lZ5jMl+DwAvIvLqqJG42GAoTOQ/NtMcZwhtvAOfJ9kXF37OaagGAoX4LEHTPV3GW6MjonCZtchLuhOAaYcUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GY+4AmKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GY+4AmKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FE3C2BCB2;
	Mon,  9 Feb 2026 14:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648414;
	bh=QpHvhPjG5lbFZ/3XPNP5k9PJV366zHq/gnV78CERO7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GY+4AmKmJn6gPEs0BdWeePiRuNBxA7SteGPMyrkHDNaXkXYW5eufpG08J/SQWgKIz
	 2HxrgdLONiQU4h1nIl3YdZ3svTnyKi+wt5XElp6SW4he7J/mgqW9Dz4umYm/yp22JA
	 S5G4Nh2OhKRDTUywgIixt7iSNTynd3B9XEmqJCDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 31/86] HID: intel-ish-hid: Update ishtp bus match to support device ID table
Date: Mon,  9 Feb 2026 15:23:54 +0100
Message-ID: <20260209142305.906580653@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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
index 7fc738a223755..4d97d043aae4b 100644
--- a/drivers/hid/intel-ish-hid/ishtp/bus.c
+++ b/drivers/hid/intel-ish-hid/ishtp/bus.c
@@ -240,9 +240,17 @@ static int ishtp_cl_bus_match(struct device *dev, struct device_driver *drv)
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



