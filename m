Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7015F18A6D0;
	Tue, 30 Jul 2024 17:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359421; cv=none; b=bjwoq9fK2eQ3cJh1yRQnEB15g4xluvKxsSjU8zWsGL6cA9ASipqFRyu3VqBVXfF8YHOdHryatreimFD+NgpxRkrLE9FrvZGJ6uEbeTiHgeke6KA8gYwdXDq1c6sfZbXg4udy6FxFLbBGKVrEv9fUmJzZoUGWZfSlkrr+K56nRIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359421; c=relaxed/simple;
	bh=bSXdVHhIuluOZSPqOHac6nid2xjZFYFe5uPlelqIyQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JbITlvj7iTWUDdJayK2DurfjSzMast6Rmb/p1dHcU3cowmtRWMEY3yRE+MU5AEHh4g5aWFEiJg1cNgbkuMDZssS2w5sKonYIlpoQ682tLeG4ZjodQD6vFBeyKtRzoXumxTH6uAPKzkMXJWGEXneVOdj8m/M85efhKsdItkSh6qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxLeGok+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxLeGok+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15ACC32782;
	Tue, 30 Jul 2024 17:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359421;
	bh=bSXdVHhIuluOZSPqOHac6nid2xjZFYFe5uPlelqIyQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxLeGok+w7IHh8aqp+sFWoP8IPAgSPJ7+d69mfAxwHPuX9eOUP4u8NW/fy+RsrL9A
	 O2rmC1X3rfnNmYIucmI0h/AFm0hXcKFm4SDOx59PbQF/RjqsltDDc2hE4wOgS7wkfn
	 neemKVNqxKl7hGhgAnLGrdCf0lpX7txHSVLjYJKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.6 480/568] drm/i915/dp: Reset intel_dp->link_trained before retraining the link
Date: Tue, 30 Jul 2024 17:49:47 +0200
Message-ID: <20240730151658.786867130@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4374,6 +4374,8 @@ int intel_dp_retrain_link(struct intel_e
 		    !intel_dp_mst_is_master_trans(crtc_state))
 			continue;
 
+		intel_dp->link_trained = false;
+
 		intel_dp_check_frl_training(intel_dp);
 		intel_dp_pcon_dsc_configure(intel_dp, crtc_state);
 		intel_dp_start_link_train(intel_dp, crtc_state);


