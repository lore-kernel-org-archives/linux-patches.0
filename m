Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDB1249F9;
	Tue, 11 Mar 2025 15:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706252; cv=none; b=Sg6VFgtBn8nU2D7z3p9e4Jxa2X+HiRiP9l3EPNTT1Oq6nj7GG9/qskm4MFX8BONB17l/qvSFCEU9hhBmxAo3v046/y3Yrg0cxJ5DhumrKSiUOcQZWPkdMrFdhTnuLWt8EQeyvPpJYBoSbTmoiQxz+JkqkuwKwK0BTdZmlANn0Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706252; c=relaxed/simple;
	bh=gwdFMQJFulB0SCO9XUvEewwWrvBOjqq9dUCSN7yJMLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjdYf19gI504ZiDxNEhbR+ONoOE9f9YU1rKmuvsOUE/Dyvnj/TAlpRy2cgYqmrBcp7bJpNVRK56Qxy+4XQ+6KzM0RTGHrVLzzuDfTf1V1oQLUrRe3sJbcZI+vhwFxsbR3wuJYeD6iqs0VPz78wwIQwizRLf91e3i7zlPZ/tMry8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRNeDk3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRNeDk3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7D4C4CEE9;
	Tue, 11 Mar 2025 15:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706252;
	bh=gwdFMQJFulB0SCO9XUvEewwWrvBOjqq9dUCSN7yJMLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRNeDk3K5ZFpy7Jd9dUqgSy35eNz7L3aMsvLNqz47xDNvhkvu3vnpXHkbv3Asb37C
	 FbWPNPRfXVmTcIh22m3dinDAB73+41/IKrdxOl4L6yoVdx7OAn9k/MAYOMpHmd20nG
	 I81MFjKtg45IbsCmGvQDB16llwCwrGhj6UYlSg5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 295/328] HID: intel-ish-hid: Fix use-after-free issue in ishtp_hid_remove()
Date: Tue, 11 Mar 2025 16:01:05 +0100
Message-ID: <20250311145726.631749743@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b8aae69ad15d7..ef52368557715 100644
--- a/drivers/hid/intel-ish-hid/ishtp-hid.c
+++ b/drivers/hid/intel-ish-hid/ishtp-hid.c
@@ -263,12 +263,14 @@ int ishtp_hid_probe(unsigned int cur_hid_dev,
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



