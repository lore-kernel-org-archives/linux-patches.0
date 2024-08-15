Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D436C19E7FA;
	Thu, 15 Aug 2024 13:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729984; cv=none; b=EqXA/4NKDDedQylvm5wiy6XWu9ygFFr0jKtgr527dAlL76mUzqXiZpdT5SSS9Nz9x8+zNZfgzdKcCeTzIT6dR5ARZP7Nn8+DgkpCnvYsg90veeMHwHVE3Qy5a88HWK5oSPXJsXrMYrmNwlgzCWAsULkrCVEc0pa7Yp0A0ACeW9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729984; c=relaxed/simple;
	bh=x8yrq+iehWkNChQZ05YWtgnguJUezq8Kd8IBa5E2OO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UfXw+WuanuwqgAEzqVH87wS2AQo6gfI8Pb6mZpn6YF1u2yVc//Pods2Zal9ns39C+1jX+l9MaLdr70k0A/nyFx9BqvCYar3UuiFocOcqCM3m4gPJY9htgjMEj4tP1f3JZGvAQ1OrmRSN3+lVB7RHVUB36+vbZsP0hUXYuY4wr6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0PjQfW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0PjQfW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45784C32786;
	Thu, 15 Aug 2024 13:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729984;
	bh=x8yrq+iehWkNChQZ05YWtgnguJUezq8Kd8IBa5E2OO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0PjQfW5m8iBCbRbfRxDMg9YYJ9DMNKfzH3idpFWFOxFkFJJaLBZNrpihejtgTC6D
	 WT6APUS/cih/ccfC5PDIqTnB07rdSlFhpHr6WAGqXOb8vmlZrpDBcIE97BA8yzKFB5
	 3pjLHv8nN5Xo881W+NuQkJYTjQ5D7FJoX6PA8bOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 5.15 237/484] drm/i915/dp: Reset intel_dp->link_trained before retraining the link
Date: Thu, 15 Aug 2024 15:21:35 +0200
Message-ID: <20240815131950.559258151@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit d13e2a6e95e6b87f571c837c71a3d05691def9bb upstream.

Regularly retraining a link during an atomic commit happens with the
given pipe/link already disabled and hence intel_dp->link_trained being
false. Ensure this also for retraining a DP SST link via direct calls to
the link training functions (vs. an actual commit as for DP MST). So far
nothing depended on this, however the next patch will depend on
link_trained==false for changing the LTTPR mode to non-transparent.

Cc: <stable@vger.kernel.org> # v5.15+
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240708190029.271247-2-imre.deak@intel.com
(cherry picked from commit a4d5ce61765c08ab364aa4b327f6739b646e6cfa)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3627,6 +3627,8 @@ int intel_dp_retrain_link(struct intel_e
 		    !intel_dp_mst_is_master_trans(crtc_state))
 			continue;
 
+		intel_dp->link_trained = false;
+
 		intel_dp_check_frl_training(intel_dp);
 		intel_dp_pcon_dsc_configure(intel_dp, crtc_state);
 		intel_dp_start_link_train(intel_dp, crtc_state);


