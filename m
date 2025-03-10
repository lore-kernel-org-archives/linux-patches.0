Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAFF231A42;
	Mon, 10 Mar 2025 17:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626723; cv=none; b=p4NqLHTAaiI3koohOs66nnTLqrtQG9rtJK0hR9WXBPlsVb3I6ekWDUEQE1ReJob4Dl40YrSEYT6kPIS05AaezbB7I0qv+VrVdur9oIlYQoVn3rTkhhDlPFhEkP1aK5fd/PPF1XjS+BpF9AYJNo9HZzdzg8gHQhdjm/4144kH6cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626723; c=relaxed/simple;
	bh=QUHpg5B7OIfvm3wc/L6yV1sNxDcUVV3aO4jnBLADbNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eT9B5E0AzKJOIHBwCJKodakhzYaqG/6OvMVdIKhsa4C7zm2FwdLdQXQ+seIcOpZfQW0J4ALYWuG/+E4b5Mn+7yojPas7Bk0ODfaagwvEhIVGF00Qp2wNZdwSPsnhVRbmPFR3kMa9rOEvajOhy0f+0nXzbMd6mDlqhgoaFgRXF2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lBQOq+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lBQOq+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37493C4CEEB;
	Mon, 10 Mar 2025 17:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626723;
	bh=QUHpg5B7OIfvm3wc/L6yV1sNxDcUVV3aO4jnBLADbNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lBQOq+CrI11R7mDXac1b2tzKmasegtJPSVah8lur72j3DyBGtAUVIENqEG3c70x8
	 MbJ7ZMurx+v4jrsRBIh27fVc8vEoBhmodL25LVT+fz1ksIxkwJIsNtulT5xmuHXUOl
	 XVvKYboMo3xaqSBCIjVVPciLcHBYwFCNtMk5HIcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 090/207] HID: intel-ish-hid: Fix use-after-free issue in hid_ishtp_cl_remove()
Date: Mon, 10 Mar 2025 18:04:43 +0100
Message-ID: <20250310170451.334614127@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index cb04cd1d980bd..6550ad5bfbb53 100644
--- a/drivers/hid/intel-ish-hid/ishtp-hid-client.c
+++ b/drivers/hid/intel-ish-hid/ishtp-hid-client.c
@@ -832,9 +832,9 @@ static void hid_ishtp_cl_remove(struct ishtp_cl_device *cl_device)
 			hid_ishtp_cl);
 
 	dev_dbg(ishtp_device(cl_device), "%s\n", __func__);
-	hid_ishtp_cl_deinit(hid_ishtp_cl);
 	ishtp_put_device(cl_device);
 	ishtp_hid_remove(client_data);
+	hid_ishtp_cl_deinit(hid_ishtp_cl);
 
 	hid_ishtp_cl = NULL;
 
-- 
2.39.5



