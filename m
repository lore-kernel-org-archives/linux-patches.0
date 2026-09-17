Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8B04F5DED;
	Thu, 17 Sep 2026 17:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667855; cv=none; b=egXv5GQ4duMkq3obPIzzj15Ve8pi14xr44dwwQslTILkXYj1AuPMT8MKwAHK64ziD4AWBBBXwxfKnoULSZJMwG0TeL+/3YQRbS0ukvzU2i2P1vm4P7Kw6752KJWi5QJ0QtSDXdLNzYroBv5gxw1JYTR8UbnSBsznUHD5X3quAVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667855; c=relaxed/simple;
	bh=edv9KjSPoRq0LDez2Bdp0YIoQEHtDIcXx+Ui8xahdw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4G+qjB6ZyqRbK6Mpqcuq5WqWHZQ2zo5cOKA7GFRBWQvxneA+8S01FDAKBQ8fSlbq+SB3xx/fj8FTVc2m5pYy2h4eHAKt9QPHOwN7ZNk/mYDhMCpWbFCT3ux5Z/Rll/DmntwF6hTKnufNpXaKWOljm0nU2O6zF2NDOyIub5hqhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdzX2gt+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdzX2gt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857361F000FF;
	Thu, 17 Sep 2026 17:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667853;
	bh=Rys5aLyvZ59ZUSj9fYZY9YZY24vuVzpjPr69d12orM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdzX2gt+iQdVYwHT5+eAi8Ang88mMObUaXsw7v9Ucq3lT4Z+la35OO0MWRrAtGlb9
	 Fwf38nHezsUzLqg5dNqoMQHSyA+HBdxjAtS6DE2deBI9/L11fbC6vSx6FZKAP8J4/5
	 +KwTpmWBXYJUi/cUgXvee8OH9YzUowRaSmuXQoM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0231/1102] drm/amdkfd: Unwind debug trap enable on copy_to_user failure
Date: Thu, 17 Sep 2026 16:02:54 +0100
Message-ID: <20260917151545.384637500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Yongqiang Sun <Yongqiang.Sun@amd.com>

[ Upstream commit 01112e241e37f9ac98b6f418d93ce2e0b87b7ee0 ]

If kfd_dbg_trap_enable() fails while copying runtime_info to userspace,
it had already activated the trap, set debug_trap_enabled, taken an extra
process reference, and opened the debug event file. Return -EFAULT without
unwinding that state, leaving inconsistent trap state and a refcount
imbalance that could break later DISABLE/ENABLE.

On copy_to_user failure, deactivate the trap and undo the rest of the
enable setup before returning.

Signed-off-by: Yongqiang Sun <Yongqiang.Sun@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_debug.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_debug.c b/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
index 3a8df47aa5821..897c402a4e484 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
@@ -816,6 +816,12 @@ int kfd_dbg_trap_enable(struct kfd_process *target, uint32_t fd,
 
 	if (copy_to_user(runtime_info, (void *)&target->runtime_info, copy_size)) {
 		kfd_dbg_trap_deactivate(target, false, 0);
+		fput(target->dbg_ev_file);
+		target->dbg_ev_file = NULL;
+		if (target->debugger_process)
+			atomic_dec(&target->debugger_process->debugged_process_count);
+		target->debug_trap_enabled = false;
+		kfd_unref_process(target);
 		r = -EFAULT;
 	}
 
-- 
2.53.0



