Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBD218BC26;
	Mon, 24 Feb 2025 14:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408622; cv=none; b=gzkTwKRaPZvFf1HQgv/jnh9D8a24W61xRUm780OJywq+8GLpaHM9ny/ZCbixfvf5gO97/W13ebyYQ5pt9DffIXS0o7k+Vxpy6jtRTTUAtGkkFyIYRNPhlkEtrOl2Pu/XJMLFSUojcUyrcoSWMPD4yPI1xRRduOZDIhQs6Fd+0as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408622; c=relaxed/simple;
	bh=nYmeEMg58j9pH+mLMTM6zyUVFT18bhYp0YO4Kua+F6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7PrHVph52IBSWE0w354CN2+9mZRndKlCV4qfJ3TGgFMx3THmvj0Ix0805S3YsdsiQsne3ZrnowkPQDJLwBNdEhEXqgWZDRIFpBhC442V1WqUq6UWO0rOFBeJ9bGRUod7f+bOkItarVfUmo45E/lzoIe2ah1JTjoiaC0PGAniMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vy1avdlg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vy1avdlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C279C4CEE6;
	Mon, 24 Feb 2025 14:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408622;
	bh=nYmeEMg58j9pH+mLMTM6zyUVFT18bhYp0YO4Kua+F6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vy1avdlgoGBVnmJPdILu6j98SAeJ5C2ydIagm1RaujOouhmWTxVNUjm9NMzKXvZ/O
	 FnWaia9B8Xnn9hguL8mfepRblHxHOHyO50BiESdfw0oS5ZVNNNYt0LnyF85V0g4Eac
	 +icKFoRgfJlLbKHDBrmPZRQB/KCFnQlNO8pUmXUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Maciej Patelczyk <maciej.patelczyk@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.12 111/154] drm/i915/gt: Use spin_lock_irqsave() in interruptible context
Date: Mon, 24 Feb 2025 15:35:10 +0100
Message-ID: <20250224142611.400686882@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Karas <krzysztof.karas@intel.com>

commit e49477f7f78598295551d486ecc7f020d796432e upstream.

spin_lock/unlock() functions used in interrupt contexts could
result in a deadlock, as seen in GitLab issue #13399,
which occurs when interrupt comes in while holding a lock.

Try to remedy the problem by saving irq state before spin lock
acquisition.

v2: add irqs' state save/restore calls to all locks/unlocks in
 signal_irq_work() execution (Maciej)

v3: use with spin_lock_irqsave() in guc_lrc_desc_unpin() instead
 of other lock/unlock calls and add Fixes and Cc tags (Tvrtko);
 change title and commit message

Fixes: 2f2cc53b5fe7 ("drm/i915/guc: Close deregister-context race against CT-loss")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13399
Signed-off-by: Krzysztof Karas <krzysztof.karas@intel.com>
Cc: <stable@vger.kernel.org> # v6.9+
Reviewed-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/pusppq5ybyszau2oocboj3mtj5x574gwij323jlclm5zxvimmu@mnfg6odxbpsv
(cherry picked from commit c088387ddd6482b40f21ccf23db1125e8fa4af7e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -3425,10 +3425,10 @@ static inline int guc_lrc_desc_unpin(str
 	 */
 	ret = deregister_context(ce, ce->guc_id.id);
 	if (ret) {
-		spin_lock(&ce->guc_state.lock);
+		spin_lock_irqsave(&ce->guc_state.lock, flags);
 		set_context_registered(ce);
 		clr_context_destroyed(ce);
-		spin_unlock(&ce->guc_state.lock);
+		spin_unlock_irqrestore(&ce->guc_state.lock, flags);
 		/*
 		 * As gt-pm is awake at function entry, intel_wakeref_put_async merely decrements
 		 * the wakeref immediately but per function spec usage call this after unlock.


