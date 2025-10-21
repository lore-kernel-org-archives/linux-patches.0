Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB4D350A2C;
	Tue, 21 Oct 2025 20:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076910; cv=none; b=gjdfuhrgFu8Nr2rjp74H2lNTAzlEL0cTWw9poz7W1eP8Tnte4FfT+XLojAlyU7p52L7qUbTFGHOBcznGNtsi9r54wivfk7bwga5LoWXKyCOpuJotku3KIfnt+nxJMa1gF/ZM1QrYvkHNJaTKHVZsIn6zL7EkZ0BpmSPhEGi77e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076910; c=relaxed/simple;
	bh=oHGOpscUARyeq4u7M1CHmxA/ZBZfzOVTnIMeDFkxFBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSB1iHBnkW0PyyCTQUbavJqXhCgudYIcMHpMKxrC9F8vI4d4kE88dlxLChLGvpGQtMY+rotZCVXTXk0RJR9sT8bpoGJGOB0LCDWC/Io/eIEYDndtQl2RLPqmlEFu5d7gSRwKXUPv6gGB4AfT3pGuNXQwsqDnZhgRTWvrWCWjlwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUPo7wh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUPo7wh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CCCC4CEF1;
	Tue, 21 Oct 2025 20:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076910;
	bh=oHGOpscUARyeq4u7M1CHmxA/ZBZfzOVTnIMeDFkxFBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUPo7wh1g1v4vTMJRz3HXbrvmBgPtUBGt4HYZtF0gq8StF7ih9p4qFaHhNYW2mfLs
	 H2muMxh8lWyaIXd894JPHzJkJcG9eThP53x2alUSWT1rxh/O+mJPXdkPLWGJz6pld0
	 buzaRqTYqYc7zeia31WtJSWcLzEdzgdma08PFrn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhanjun Dong <zhanjun.dong@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/136] drm/i915/guc: Skip communication warning on reset in progress
Date: Tue, 21 Oct 2025 21:51:03 +0200
Message-ID: <20251021195037.776565600@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

From: Zhanjun Dong <zhanjun.dong@intel.com>

[ Upstream commit 1696b0cfcf004a3af34ffe4c57a14e837ef18144 ]

GuC IRQ and tasklet handler receive just single G2H message, and let other
messages to be received from next tasklet. During this chained tasklet
process, if reset process started, communication will be disabled.
Skip warning for this condition.

Fixes: 65dd4ed0f4e1 ("drm/i915/guc: Don't receive all G2H messages in irq handler")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/15018
Signed-off-by: Zhanjun Dong <zhanjun.dong@intel.com>
Reviewed-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://lore.kernel.org/r/20250929152904.269776-1-zhanjun.dong@intel.com
(cherry picked from commit 604b5ee4a653a70979ce689dbd6a5d942eb016bf)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c
index 0d5197c0824a9..5cf3a516ccfb3 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c
@@ -1324,9 +1324,16 @@ static int ct_receive(struct intel_guc_ct *ct)
 
 static void ct_try_receive_message(struct intel_guc_ct *ct)
 {
+	struct intel_guc *guc = ct_to_guc(ct);
 	int ret;
 
-	if (GEM_WARN_ON(!ct->enabled))
+	if (!ct->enabled) {
+		GEM_WARN_ON(!guc_to_gt(guc)->uc.reset_in_progress);
+		return;
+	}
+
+	/* When interrupt disabled, message handling is not expected */
+	if (!guc->interrupts.enabled)
 		return;
 
 	ret = ct_receive(ct);
-- 
2.51.0



