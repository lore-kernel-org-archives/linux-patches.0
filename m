Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1919341645;
	Tue, 16 Dec 2025 11:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884172; cv=none; b=A+xShAyk5lmWymhm0nKc3iFh8B/nIl0/+PlSh8UzVZniORhTUDVBlN8zWjUB+CtMUy9F02ddyXWBZdF1oRXk/sPli3o5iSK9x485H8H3MHsU/wdN1G/CXLBiwyROTxpsOiiy2T+jARFdX0aQ8XEQTVgwaJjR92fPfBsivsteSaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884172; c=relaxed/simple;
	bh=pwg9a82r1JMdAnpe2Ypq45Tz9u5IwXVB+ZT/E+O9lsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gepszHM0LQXUz34denMjtE9fUVCzdpW+QnEfE3rP9nMsSKW6KkTeVHsBBN6xgiQPyKJ598n4ykkF4EayjECWdgzukR67VH22yoG1/Hoc/bwITLt9V/SW1MehUSEOpE8zMtnq0I+oxhcTm/yqt41aulGGmGLF79iyI3AOBjAZZGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5VHH1V+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5VHH1V+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1E4C4CEF5;
	Tue, 16 Dec 2025 11:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884172;
	bh=pwg9a82r1JMdAnpe2Ypq45Tz9u5IwXVB+ZT/E+O9lsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5VHH1V+i4OT+7riqhM2yy6EeUMmEyRBBJvcOwu1VKzuVVZNvOziSdGbc4/9PF2xX
	 8BgQ+VhaLbEtAdgQZ6ARtf5P1r3oxxTAPpZFlzk5Wd+ioD2cDvpoJKvZaF3XV0RTb6
	 fYYLoWUl9fnyfnFTrKsg1V7/PBZ2JUBXi+aUXT5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ketil Johnsen <ketil.johnsen@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/354] drm/panthor: Fix UAF race between device unplug and FW event processing
Date: Tue, 16 Dec 2025 12:11:21 +0100
Message-ID: <20251216111325.053094475@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 81ea3a79ab49c..1d95decddc273 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -3696,6 +3696,7 @@ void panthor_sched_unplug(struct panthor_device *ptdev)
 	struct panthor_scheduler *sched = ptdev->scheduler;
 
 	cancel_delayed_work_sync(&sched->tick_work);
+	disable_work_sync(&sched->fw_events_work);
 
 	mutex_lock(&sched->lock);
 	if (sched->pm.has_ref) {
-- 
2.51.0



