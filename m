Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2596733A6F4;
	Tue, 16 Dec 2025 11:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885526; cv=none; b=LSq+CkIexZZq5mJHnA2gyBMsi0gXPcos3TjCmk5+3XAzte3T+pKv+hGn4sGwSTIjpbANhE45R5EKBEj2JQ7rBq1RY0/roWlbKsrHzGHPIopbqqCG76R4NQpGJ6+A+54rhQ7tt9vlh2+q1v5w5Qq/lif4AKB/odzWjf1LNYzbwDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885526; c=relaxed/simple;
	bh=PUiN6cS6ygd+uvEbfESeFROI2co6dD/bNlKPgSWxm2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRqblVrnIeqEWpITIlpP3DGo57uYZpgy+XkrGR1Ua/fCYajeTWw1gSbw9MtB7vK7FORuDVYnIFIDnfmpypfqpxxRlBuxltfN9a2b2maELS6k4gaAt4mCrO2+Aylo4cM6V4ii9j7NTPp3Lycp/CqohXDNW3DoHC9tUiUwvrQs12s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wz1/vzx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wz1/vzx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACDDC4CEF1;
	Tue, 16 Dec 2025 11:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885526;
	bh=PUiN6cS6ygd+uvEbfESeFROI2co6dD/bNlKPgSWxm2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wz1/vzx/BQMOmS5wcehe9oc81ZW/OjiEIEEflurVy/liDECBt5iaF1rttjh12TcoJ
	 YliAf6uQoHY4j3hHkR3IYCUZd/61zCphQJan/7GC7H651UEy3oMaRcLEfpPf/P1/Ic
	 lR1gHB/0lPXMLqx/1J0BW1fUQFilUXhcYQlOWQkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ketil Johnsen <ketil.johnsen@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 164/507] drm/panthor: Fix UAF race between device unplug and FW event processing
Date: Tue, 16 Dec 2025 12:10:05 +0100
Message-ID: <20251216111351.460625720@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Ketil Johnsen <ketil.johnsen@arm.com>

[ Upstream commit 7051f6ba968fa69918d72cc26de4d6cf7ea05b90 ]

The function panthor_fw_unplug() will free the FW memory sections.
The problem is that there could still be pending FW events which are yet
not handled at this point. process_fw_events_work() can in this case try
to access said freed memory.

Simply call disable_work_sync() to both drain and prevent future
invocation of process_fw_events_work().

Signed-off-by: Ketil Johnsen <ketil.johnsen@arm.com>
Fixes: de85488138247 ("drm/panthor: Add the scheduler logical block")
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20251027140217.121274-1-ketil.johnsen@arm.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 552542f70cabd..99ce0948f2bae 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -3826,6 +3826,7 @@ void panthor_sched_unplug(struct panthor_device *ptdev)
 	struct panthor_scheduler *sched = ptdev->scheduler;
 
 	cancel_delayed_work_sync(&sched->tick_work);
+	disable_work_sync(&sched->fw_events_work);
 
 	mutex_lock(&sched->lock);
 	if (sched->pm.has_ref) {
-- 
2.51.0



