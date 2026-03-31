Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68297425CFF;
	Tue, 31 Mar 2026 16:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975117; cv=none; b=QoI0SAUrStWXS8vWHxlRloLiibduPhLCa+D+R5sFAEuQHEjd5gRAg4KHbASU3PqexeeJwPKBr2P9Y7XGFll1a3IP936Q0I3UV8IamKHX085vHVVQ/shLrC38PqzKCItB8qF/ijPfLoy89BNcZmtUIAGQXfuNZ8AIZV4a2akaALs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975117; c=relaxed/simple;
	bh=QgJMqnqDMMMAIRCQS0i9sHl2OLlYjLLIf/Ul25YdMRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jctZd4TmHxK4CM356u2ccNNEbHG5arrp8T29PFoBiir1a4P1B6IFi2sCxyKdywnVnrsgky/gxBip+BB/hCc22lNsKtTDiUl/wYUKnxZVWtkr5fWZSOlR22UuNRsClbsvq9GG2VYiEc/auxFwSB3/g2Ty+bgY9Uy83UUZmwsURzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8RLlLXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8RLlLXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2181C19423;
	Tue, 31 Mar 2026 16:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975117;
	bh=QgJMqnqDMMMAIRCQS0i9sHl2OLlYjLLIf/Ul25YdMRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8RLlLXBzzNjm2r+HwMYmVR+GVEYvf913LAW07NUGhjQZkmf+Vi9wINlU3t2Px87Y
	 CAqzmy2iBhs92o6nTvoE7N2mEH/hYWnFafHQKXIq+WUmk0zE4PIX727OzzZ6wkOfhR
	 qBycn0wZWCxNv1CE3zjDTH5uN1Sk6xOZ1raP1hiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngjun Park <youngjun.park@lge.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 171/342] PM: sleep: Drop spurious WARN_ON() from pm_restore_gfp_mask()
Date: Tue, 31 Mar 2026 18:20:04 +0200
Message-ID: <20260331161805.302594232@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youngjun Park <youngjun.park@lge.com>

[ Upstream commit a8d51efb5929ae308895455a3e496b5eca2cd143 ]

Commit 35e4a69b2003f ("PM: sleep: Allow pm_restrict_gfp_mask()
stacking") introduced refcount-based GFP mask management that warns
when pm_restore_gfp_mask() is called with saved_gfp_count == 0.

Some hibernation paths call pm_restore_gfp_mask() defensively where
the GFP mask may or may not be restricted depending on the execution
path. For example, the uswsusp interface invokes it in
SNAPSHOT_CREATE_IMAGE, SNAPSHOT_UNFREEZE, and snapshot_release().
Before the stacking change this was a silent no-op; it now triggers
a spurious WARNING.

Remove the WARN_ON() wrapper from the !saved_gfp_count check while
retaining the check itself, so that defensive calls remain harmless
without producing false warnings.

Fixes: 35e4a69b2003f ("PM: sleep: Allow pm_restrict_gfp_mask() stacking")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
[ rjw: Subject tweak ]
Link: https://patch.msgid.link/20260322120528.750178-1-youngjun.park@lge.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/main.c b/kernel/power/main.c
index 03b2c5495c77a..9ce75b1a23ed3 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -40,7 +40,7 @@ void pm_restore_gfp_mask(void)
 {
 	WARN_ON(!mutex_is_locked(&system_transition_mutex));
 
-	if (WARN_ON(!saved_gfp_count) || --saved_gfp_count)
+	if (!saved_gfp_count || --saved_gfp_count)
 		return;
 
 	gfp_allowed_mask = saved_gfp_mask;
-- 
2.53.0



