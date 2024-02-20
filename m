Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5821A14F9C8;
	Tue, 20 Feb 2024 21:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465007; cv=none; b=HxtsTUitZiHv9nnfptKNyezO5bRrFTy8kCwSnGExs6lK+9/DmhBEIQryWyRvt6Ma5amEhCM8bcZyOUNIOmjoG/4XsKchTxkhOOta8wuf4eQdvYoCotOtzj0M9lyU/a3SuSWVQN/Yh3cV47byX0mqaL/2YJzJQ+SKjSjd3xkLsjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465007; c=relaxed/simple;
	bh=3+F91Ou1iSjZ/EbrPY4SrMyEXFG6QGzJ65/srlQ3eYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EL9mmZciWB06DgfJiqEAl2g5zOKUqcqOuNw+xJ52zQ+EdaUdcED2Y6VZ2RQw1cUy/OwW6JA46+undl9nMNqDPm/g/HTGTCctzC/hk9+gehdLQU+xz2C46KIPpd+UR5tTGJQPswTRQRjlfNEeffwNHyIKbawPWsxqOsCmoj+fcyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGo7rVAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGo7rVAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB684C433C7;
	Tue, 20 Feb 2024 21:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465007;
	bh=3+F91Ou1iSjZ/EbrPY4SrMyEXFG6QGzJ65/srlQ3eYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGo7rVASCcKKjTn6HFApJwMb66COUZ+8rGUkomb1uLm54g23rWOlhdyiCtCV6UJ5A
	 lL/vd57/cPkwa/7vsh65fozq6b1qSWRGdzUfutT9Kqisnizzl4AftDAzQr54gZn3rC
	 XknUTt+p/s0MTk6YBFmBLJRFkjnuMtp8uxwvVmRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.7 207/309] drm/i915/dp: Limit SST link rate to <=8.1Gbps
Date: Tue, 20 Feb 2024 21:56:06 +0100
Message-ID: <20240220205639.663588010@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit ad26d56d080780bbfcc1696ca0c0cce3e2124ef6 upstream.

Limit the link rate to HBR3 or below (<=8.1Gbps) in SST mode.
UHBR (10Gbps+) link rates require 128b/132b channel encoding
which we have not yet hooked up into the SST/no-sideband codepaths.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240208154552.14545-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 6061811d72e14f41f71b6a025510920b187bfcca)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2275,6 +2275,9 @@ intel_dp_compute_config_limits(struct in
 	limits->min_rate = intel_dp_common_rate(intel_dp, 0);
 	limits->max_rate = intel_dp_max_link_rate(intel_dp);
 
+	/* FIXME 128b/132b SST support missing */
+	limits->max_rate = min(limits->max_rate, 810000);
+
 	limits->min_lane_count = 1;
 	limits->max_lane_count = intel_dp_max_lane_count(intel_dp);
 


