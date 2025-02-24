Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C633D2837B;
	Mon, 24 Feb 2025 14:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409112; cv=none; b=dnVcGkKqjINzKpAv/RRXECAK9Y4jRsHtmtXt7U8zHhE75HJ8KUbUp5iDGCzQki8u3GQYbIHj69Rz3USWjuvzUBZ/gsdlKPs9tafqX3/KNQqYV1UCGj4aV+YQQsBtogqFzSNwpe6SRziAPOw3uVUEF0oSVD0uAUIO4pBGc+O8/h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409112; c=relaxed/simple;
	bh=I5NVwoPFI9v2c2V8l9IJ9zeXhztuUY99nyVcf/RqPCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1p0yXCkFaSAaixliVV38RuHpcdaCKLsA0eM8ZiTJq8wQQNw3/MoD6SCAUIvLdnvVq1NrsSO0aSPAV53JaQuUnwlZh6MqbBznvsaMF/UIAnqFU7sgoFYAPyTilNBq/KYgsGj/mrxReIbI8gga850JhREo8cIex/Jzuhq3k/gTic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1Zum6wf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1Zum6wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3913EC4CED6;
	Mon, 24 Feb 2025 14:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409112;
	bh=I5NVwoPFI9v2c2V8l9IJ9zeXhztuUY99nyVcf/RqPCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1Zum6wf+u6Nn+C0uHPLtPsoQxi0LZaheiDeBQ5fBO3vHe8ro8wpISPohWbTFJ9Nw
	 XuwWGsdgzG20G9aiL1oKqrhdFT6zICd/Yn8wXJne/VT1akHc7roI3a/Tldu0yieu8x
	 tYDksl5jkflNwITxA9sNebO23fQ65JpHLf2jXcXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Maciej Patelczyk <maciej.patelczyk@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.13 093/138] drm/i915/gt: Use spin_lock_irqsave() in interruptible context
Date: Mon, 24 Feb 2025 15:35:23 +0100
Message-ID: <20250224142608.134924232@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


