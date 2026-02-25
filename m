Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB11F252917;
	Wed, 25 Feb 2026 01:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983971; cv=none; b=Xs9WwLltCJbw1jvgyk4XPp0GWD//dn2IRN9SUTbw+fLefis0JmvJV8Y4ACtBoOFB27Tl5ZwYsGob3BwJvq8LjsD5omhPimCqnG4bxX+3OwCX/moG+A/FPQcKZ8t/ynMNRRQ80SLuugUu+gT5Hn3vh12DWBg3yXHYoR2c0SEMQ1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983971; c=relaxed/simple;
	bh=JFKlbaz7JaZaddA51Y7UkYqtztEsgTzwk+dgIk1r5/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJw9VdtI1419cw7Q75wzM/H4qiFLkcoUhLg3YKGmfRAuf7t87x2xTvzKel1HIhrOfje0Q5wDEZ/wzgdidT4Luyc+cAsmv6fxxdlRcR8Owgq7rFcUAuQCFKzMtSM/yOqEs6eND+u13wcB0bbFnat++Q7IdPHvFBGuDEaxChfo3k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oY/pZvgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oY/pZvgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606FDC116D0;
	Wed, 25 Feb 2026 01:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983971;
	bh=JFKlbaz7JaZaddA51Y7UkYqtztEsgTzwk+dgIk1r5/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oY/pZvgGqvX+vh5L+IQOdssuZEK1PC4mn6gK1Z/3Xzft32J/dQvvpO/Dr07dMkFc0
	 sKl+U+GYx3sUsZj1HOs4FoHwjtmqOzHyz3yB2x/z2YEIboehkPhfoAn6+aejp24Anh
	 j+Vndoh1S1qs74gy7m3+C5ma60F+AmT9Ae+4hNxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lin <ryan.lin@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 226/641] HID: intel-ish-hid: fix NULL-ptr-deref in ishtp_bus_remove_all_clients
Date: Tue, 24 Feb 2026 17:19:12 -0800
Message-ID: <20260225012354.386291966@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Lin <ryan.lin@intel.com>

[ Upstream commit 56f7db581ee73af53cd512e00a6261a025bf1d58 ]

During a warm reset flow, the cl->device pointer may be NULL if the
reset occurs while clients are still being enumerated. Accessing
cl->device->reference_count without a NULL check leads to a kernel panic.

This issue was identified during multi-unit warm reboot stress clycles.
Add a defensive NULL check for cl->device to ensure stability under
such intensive testing conditions.

KASAN: null-ptr-deref in range [0000000000000000-0000000000000007]
Workqueue: ish_fw_update_wq fw_reset_work_fn

Call Trace:
 ishtp_bus_remove_all_clients+0xbe/0x130 [intel_ishtp]
 ishtp_reset_handler+0x85/0x1a0 [intel_ishtp]
 fw_reset_work_fn+0x8a/0xc0 [intel_ish_ipc]

Fixes: 3703f53b99e4a ("HID: intel_ish-hid: ISH Transport layer")
Signed-off-by: Ryan Lin <ryan.lin@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp/bus.c b/drivers/hid/intel-ish-hid/ishtp/bus.c
index c3915f3a060ea..b890fbf97a75c 100644
--- a/drivers/hid/intel-ish-hid/ishtp/bus.c
+++ b/drivers/hid/intel-ish-hid/ishtp/bus.c
@@ -730,7 +730,7 @@ void ishtp_bus_remove_all_clients(struct ishtp_device *ishtp_dev,
 	spin_lock_irqsave(&ishtp_dev->cl_list_lock, flags);
 	list_for_each_entry(cl, &ishtp_dev->cl_list, link) {
 		cl->state = ISHTP_CL_DISCONNECTED;
-		if (warm_reset && cl->device->reference_count)
+		if (warm_reset && cl->device && cl->device->reference_count)
 			continue;
 
 		/*
-- 
2.51.0



