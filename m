Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9B62F12DE;
	Fri, 17 Oct 2025 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715007; cv=none; b=bAaEA34c4Jq0Hb26/nhOAliC4zdINr3RKWwWZMSApUzBQNxvLJH8q41lsztAnDic6Ni3CvXXzToRbvm+j5K3Zvjoqwab2pN5JjlkCgKoJ07PZB7txbubiu+BPDkBvDCdD7YoCYO4DZPUoSLWl8psy/2qkOiS/vwGes6nKOJuKkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715007; c=relaxed/simple;
	bh=hdD1bYoR5kKdEK9bTeQjN5oWawvtwkFpHWbYvtWjUKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IokPopEvBBbl+7kidt855tzZUgYxCmiU2z3ebRF7Y+x7v94lRLIIEQ5iYKEUp0FdWdVVO0iRmB6QDXWqeaVPUTaKa72Jp2MfdFEBWPaeZbsEbb66o/1K4hJi9PsNmbslca/qYr7HyCwpNqYnUbJjVLTHGHP4RzhVbWMfYWtm/+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwP6fz9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwP6fz9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31D1C4CEE7;
	Fri, 17 Oct 2025 15:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715007;
	bh=hdD1bYoR5kKdEK9bTeQjN5oWawvtwkFpHWbYvtWjUKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwP6fz9UD45O2rzhXpE83TUvhji47SmPFIsPFoSlllRlzoQS3Dntca0N3Ob9SLvrw
	 r/xHfsfm8urCzxPg5cyQ7USvo3PIcFNqOTIt9VNz1CUWaLikrbsjblOQVkpi216aMh
	 FgJuTIJH7S5zsK8sqo6GV/qL7WgUcpVshHFFqCNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 066/371] PM: sleep: Do not wait on SYNC_STATE_ONLY device links
Date: Fri, 17 Oct 2025 16:50:41 +0200
Message-ID: <20251017145204.188960438@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit 632d31067be2f414c57955efcf29c79290cc749b ]

Device links with DL_FLAG_SYNC_STATE_ONLY should not affect system
suspend and resume, and functions like device_reorder_to_tail() and
device_link_add() don't try to reorder the consumers with that flag.

However, dpm_wait_for_consumers() and dpm_wait_for_suppliers() don't
check thas flag before triggering dpm_wait(), leading to potential hang
during suspend/resume.

This can be reproduced on MT8186 Corsola Chromebook with devicetree like:

usb-a-connector {
        compatible = "usb-a-connector";
        port {
                usb_a_con: endpoint {
                        remote-endpoint = <&usb_hs>;
                };
        };
};

usb_host {
        compatible = "mediatek,mt8186-xhci", "mediatek,mtk-xhci";
        port {
                usb_hs: endpoint {
                        remote-endpoint = <&usb_a_con>;
                };
        };
};

In this case, the two nodes form a cycle and a SYNC_STATE_ONLY devlink
between usb_host (supplier) and usb-a-connector (consumer) is created.

Address this by exporting device_link_flag_is_sync_state_only() and
making dpm_wait_for_consumers() and dpm_wait_for_suppliers() use it
when deciding if dpm_wait() should be called.

Fixes: 05ef983e0d65a ("driver core: Add device link support for SYNC_STATE_ONLY flag")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Link: https://patch.msgid.link/20250926102320.4053167-1-treapking@chromium.org
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/base.h       | 1 +
 drivers/base/core.c       | 2 +-
 drivers/base/power/main.c | 6 ++++--
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 700aecd22fd34..86fa7fbb35489 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -248,6 +248,7 @@ void device_links_driver_cleanup(struct device *dev);
 void device_links_no_driver(struct device *dev);
 bool device_links_busy(struct device *dev);
 void device_links_unbind_consumers(struct device *dev);
+bool device_link_flag_is_sync_state_only(u32 flags);
 void fw_devlink_drivers_done(void);
 void fw_devlink_probing_done(void);
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index d22d6b23e7589..a54ec6df1058f 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -287,7 +287,7 @@ static bool device_is_ancestor(struct device *dev, struct device *target)
 #define DL_MARKER_FLAGS		(DL_FLAG_INFERRED | \
 				 DL_FLAG_CYCLE | \
 				 DL_FLAG_MANAGED)
-static inline bool device_link_flag_is_sync_state_only(u32 flags)
+bool device_link_flag_is_sync_state_only(u32 flags)
 {
 	return (flags & ~DL_MARKER_FLAGS) == DL_FLAG_SYNC_STATE_ONLY;
 }
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index b9a34c3425ecf..e83503bdc1fdb 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -278,7 +278,8 @@ static void dpm_wait_for_suppliers(struct device *dev, bool async)
 	 * walking.
 	 */
 	dev_for_each_link_to_supplier(link, dev)
-		if (READ_ONCE(link->status) != DL_STATE_DORMANT)
+		if (READ_ONCE(link->status) != DL_STATE_DORMANT &&
+		    !device_link_flag_is_sync_state_only(link->flags))
 			dpm_wait(link->supplier, async);
 
 	device_links_read_unlock(idx);
@@ -335,7 +336,8 @@ static void dpm_wait_for_consumers(struct device *dev, bool async)
 	 * unregistration).
 	 */
 	dev_for_each_link_to_consumer(link, dev)
-		if (READ_ONCE(link->status) != DL_STATE_DORMANT)
+		if (READ_ONCE(link->status) != DL_STATE_DORMANT &&
+		    !device_link_flag_is_sync_state_only(link->flags))
 			dpm_wait(link->consumer, async);
 
 	device_links_read_unlock(idx);
-- 
2.51.0



