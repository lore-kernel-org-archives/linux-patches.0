Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB3E303A07;
	Tue, 31 Mar 2026 17:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976854; cv=none; b=pKOzvnKoPpNkpOSXTKMdZxCNvhqQHbxxr/Prx1bvkuQ8157cJTygr6xfMSTqYQWOI31wfnCqgoDcaPhv3hooJHaoX/G54Z4IBh6JmxIaVuB0GwDnxU9wzHR9VGjq6Wi671ccq3My7e4bnwWjMT47S5NT+2CyfnGVGm4JyGeixGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976854; c=relaxed/simple;
	bh=vjjQHZMDGkxhKkb3z+auWZtXu7X8c6IDMgt0dVo7S4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ANwLdmcbiqURxAsU9ewGAZjM+jY1h+tF3Gw5aQCKMaCwcZCSvc8ailV5zngSbaf68kNpt2RC4UaBuKrDhTSum3Rkc9c+RzWea9pxa6h4xNyQB0KITZX5y49r2t7AuhmiuHeUrDSPLx5/DPlIT3T89HqQXVD21ov9DITm8gHOyO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMkMA4K8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMkMA4K8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A20C19423;
	Tue, 31 Mar 2026 17:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976854;
	bh=vjjQHZMDGkxhKkb3z+auWZtXu7X8c6IDMgt0dVo7S4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMkMA4K8kAV4Jm1KQaATunmjqiK8gZiq8022pWzwLd2lVg64/6DKlVhY9kuWWv55w
	 vdkUnX3CSoAzL5bYFtOavr6Cd8PNuxEcoOlouDQlprTsmmbCLwUA3IIaXnmI4TMtS1
	 NypyfpkIkbv58npZkBHfkKGZ/mk/zwDbQv4DF0KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.18 236/309] drm/i915: Order OP vs. timeout correctly in __wait_for()
Date: Tue, 31 Mar 2026 18:22:19 +0200
Message-ID: <20260331161802.264432535@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 6ad2a661ff0d3d94884947d2a593311ba46d34c2 upstream.

Put the barrier() before the OP so that anything we read out in
OP and check in COND will actually be read out after the timeout
has been evaluated.

Currently the only place where we use OP is __intel_wait_for_register(),
but the use there is precisely susceptible to this reordering, assuming
the ktime_*() stuff itself doesn't act as a sufficient barrier:

__intel_wait_for_register(...)
{
	...
	ret = __wait_for(reg_value = intel_uncore_read_notrace(...),
 			 (reg_value & mask) == value, ...);
	...
}

Cc: stable@vger.kernel.org
Fixes: 1c3c1dc66a96 ("drm/i915: Add compiler barrier to wait_for")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260313110740.24620-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit a464bace0482aa9a83e9aa7beefbaf44cd58e6cf)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_wait_util.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_wait_util.h
+++ b/drivers/gpu/drm/i915/i915_wait_util.h
@@ -25,9 +25,9 @@
 	might_sleep();							\
 	for (;;) {							\
 		const bool expired__ = ktime_after(ktime_get_raw(), end__); \
-		OP;							\
 		/* Guarantee COND check prior to timeout */		\
 		barrier();						\
+		OP;							\
 		if (COND) {						\
 			ret__ = 0;					\
 			break;						\


