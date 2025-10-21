Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D5525A355;
	Tue, 21 Oct 2025 20:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077424; cv=none; b=Fqkc+ApxB9gCPTe/ruNL8KDCS2CN27LXxH1Jy0j8BQfAbQdkpGQVANEE9tKIMxRxnqdseLCA69c0Z+w6tJ+MmV5uFSO9vcn6FHOF456RjT3sGSrbi1Z/cBaE373IShMBBNPVCGG3ambR5ycX/Z/Mud25oTRB/akG4LDG5nNbLUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077424; c=relaxed/simple;
	bh=HXo+pvAZEJI21pDAPfmGt2KvbV80cwAmQP2Fu3QP57Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwFPFD/Qzt+a+rpBxJM5T09gK1pIcHXxxG/qxCHH8mTIA5k31sjDM7sjoKsjg+Nm8YA+q/9Is72YzmKLg6kiKtR7MydtyWpQOStmAbktt4+Q95Yjw2veHQ+kmCjND17QH+PPQPB5/8J8uE3uKU3lgpCj/UU4W/XKQxj2r/JFdI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkZRKjRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkZRKjRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F960C4CEF1;
	Tue, 21 Oct 2025 20:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077424;
	bh=HXo+pvAZEJI21pDAPfmGt2KvbV80cwAmQP2Fu3QP57Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkZRKjReijRc2in55qShmAeAIRioHsE+AMXJUswrvosULRlDn9OhbXWBTKSIsNRqj
	 0MnqZaJsdZuBKK+CauFnMH0tclx/icsdJYG+e04aJ2u5We2/pLP1DAe6QtxnxussjZ
	 aYyjsOGSKD6HHfx4GXTC924K3OBIPr/wjlL4buKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhanjun Dong <zhanjun.dong@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 102/159] drm/i915/guc: Skip communication warning on reset in progress
Date: Tue, 21 Oct 2025 21:51:19 +0200
Message-ID: <20251021195045.637287205@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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



