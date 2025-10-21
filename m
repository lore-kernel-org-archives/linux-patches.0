Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DCA273D66;
	Tue, 21 Oct 2025 19:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076655; cv=none; b=qRpYd5AYQWR3NIeOn5cyyh3MJ8T8zD+KArkp3avaSJ8g+OBvDZPLZZh9NJBNBYr8jRjKRVZUX7s47ekP7DghCHhupHWUPt5v/Vmev0+NCS4CXM9u76ShrH9o4KLKJnZOKTOR0dooezDYp5DO+BMCnqwMeED+705Me0YKsXSQcMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076655; c=relaxed/simple;
	bh=tNvlNYja77FPsWuLQ4Kvx0ko7aGGkXE/nVDnelrhbC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcPRHSzZ5UoBGtTJMcYyeX3yfgihgQR+xcjMjHFAkoXLpKeEbA7cNURhRtdOExHEnMIgUv2D7OKQkODOhEFpoG1pIiE/Trh4QOan47MlblO8ara1Vp7kr0lDJkshm+0vIoM1ZHVqjUBUTELiJjr2p6iSFcu34BrNnGXKx9xCHKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ufu7eJiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ufu7eJiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91542C4CEF5;
	Tue, 21 Oct 2025 19:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076655;
	bh=tNvlNYja77FPsWuLQ4Kvx0ko7aGGkXE/nVDnelrhbC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ufu7eJiGXxp8DFcM8LS/Ql54JMQxE/2SW1MJHxCMeMX1XPHjaa2LUPq5f82rhwF2N
	 VKhebPH3IC6WRH+hNC7dTLWE8lNsoKyGNhZMXyOZ33mI95SxVQZr8Jj1cSP+NFmXJk
	 ZXOhcfEeWFwSfBEcOOisjbnsUZdr2CILl6ZFYXRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhanjun Dong <zhanjun.dong@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/105] drm/i915/guc: Skip communication warning on reset in progress
Date: Tue, 21 Oct 2025 21:51:08 +0200
Message-ID: <20251021195023.078227632@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 97eadd08181d6..38fad14ffd435 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c
@@ -1281,9 +1281,16 @@ static int ct_receive(struct intel_guc_ct *ct)
 
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



