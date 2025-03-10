Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5164233729;
	Mon, 10 Mar 2025 17:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627569; cv=none; b=hXRTieIW7NFyNspDJ07JOypeHeQ7KlFd81qmuknEEq4IWv5HRdkt+HiCV+P95ejHS+OPjyc/Q4TolkOv2FQA29UOjiuIeSHmQOrR6RIjxkX6cW2ps9ZG4ruiKr3I+RexXElwpAtAOoA3HbyNMLIZSuUi07AcWPBvo2kDJDcp9b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627569; c=relaxed/simple;
	bh=0oLxBfyXtEnB3oqMzdOVkwUXggd21fRa3QgcJG9oExc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVi1lkgIWzGP/DmTlZijtosLdtfO9AC3F6epb/A3IyUfwRdC3uAuIcVMnZSpFUZ9Ll3wN1GR6kj5zCuHbK3VJZshuVHPZmSSIXykjQAEkNOmWvjzY0kvg3WIhHSOWTdXJ1Yyy6/B2RQ8nArTUJ78CXX7K+Fn9PGl1gwsGrudpsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MebD7Vs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MebD7Vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A868C4CEEE;
	Mon, 10 Mar 2025 17:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627569;
	bh=0oLxBfyXtEnB3oqMzdOVkwUXggd21fRa3QgcJG9oExc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MebD7VsmUp5etiu/WC2PrJHIktJ29wtCyyyqZq5aoqo33QW+4H87bMw3KHVNcxJB
	 NB0DVN/VC0qKJkQC8ejzmjDpM8rLx+PmkuOATqAOOAvhSol1GD5SHx0GTV4EUGj33g
	 bX5bidKnOKWADu+h2GhJWClB5f7N09tzkwgG/6rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/269] HID: intel-ish-hid: Fix use-after-free issue in hid_ishtp_cl_remove()
Date: Mon, 10 Mar 2025 18:05:00 +0100
Message-ID: <20250310170503.575709292@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit 823987841424289339fdb4ba90e6d2c3792836db ]

During the `rmmod` operation for the `intel_ishtp_hid` driver, a
use-after-free issue can occur in the hid_ishtp_cl_remove() function.
The function hid_ishtp_cl_deinit() is called before ishtp_hid_remove(),
which can lead to accessing freed memory or resources during the
removal process.

Call Trace:
 ? ishtp_cl_send+0x168/0x220 [intel_ishtp]
 ? hid_output_report+0xe3/0x150 [hid]
 hid_ishtp_set_feature+0xb5/0x120 [intel_ishtp_hid]
 ishtp_hid_request+0x7b/0xb0 [intel_ishtp_hid]
 hid_hw_request+0x1f/0x40 [hid]
 sensor_hub_set_feature+0x11f/0x190 [hid_sensor_hub]
 _hid_sensor_power_state+0x147/0x1e0 [hid_sensor_trigger]
 hid_sensor_runtime_resume+0x22/0x30 [hid_sensor_trigger]
 sensor_hub_remove+0xa8/0xe0 [hid_sensor_hub]
 hid_device_remove+0x49/0xb0 [hid]
 hid_destroy_device+0x6f/0x90 [hid]
 ishtp_hid_remove+0x42/0x70 [intel_ishtp_hid]
 hid_ishtp_cl_remove+0x6b/0xb0 [intel_ishtp_hid]
 ishtp_cl_device_remove+0x4a/0x60 [intel_ishtp]
 ...

Additionally, ishtp_hid_remove() is a HID level power off, which should
occur before the ISHTP level disconnect.

This patch resolves the issue by reordering the calls in
hid_ishtp_cl_remove(). The function ishtp_hid_remove() is now
called before hid_ishtp_cl_deinit().

Fixes: f645a90e8ff7 ("HID: intel-ish-hid: ishtp-hid-client: use helper functions for connection")
Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp-hid-client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp-hid-client.c b/drivers/hid/intel-ish-hid/ishtp-hid-client.c
index fbd4f8ea1951b..af6a5afc1a93e 100644
--- a/drivers/hid/intel-ish-hid/ishtp-hid-client.c
+++ b/drivers/hid/intel-ish-hid/ishtp-hid-client.c
@@ -833,9 +833,9 @@ static void hid_ishtp_cl_remove(struct ishtp_cl_device *cl_device)
 			hid_ishtp_cl);
 
 	dev_dbg(ishtp_device(cl_device), "%s\n", __func__);
-	hid_ishtp_cl_deinit(hid_ishtp_cl);
 	ishtp_put_device(cl_device);
 	ishtp_hid_remove(client_data);
+	hid_ishtp_cl_deinit(hid_ishtp_cl);
 
 	hid_ishtp_cl = NULL;
 
-- 
2.39.5



