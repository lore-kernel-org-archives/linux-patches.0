Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CE48486;
	Sat, 30 Dec 2023 12:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSr/CP+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB930C433C8;
	Sat, 30 Dec 2023 12:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937961;
	bh=yO+8BdWCaWJg7tf3k+Z7Tf2Qb6omYu2KwvpeQJZoUMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSr/CP+vly2d8NaqM58LjnZMDKAGJX7fLjefGyFPybEIrATM+tl7X/oEA3Kz7CmZF
	 1MHliQRj7fCFiz4xkst6f/l+bYya2WzbU/ek/YrqldA3BdFarDB59D+aTPe3AdsPvo
	 ri9qnB0di7qlwCvM5Gi8JL/8Wnodexth1i91uTNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 129/156] drm/i915: Reject async flips with bigjoiner
Date: Sat, 30 Dec 2023 11:59:43 +0000
Message-ID: <20231230115816.579118363@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 88a173e5dd05e788068e8fa20a8c37c44bd8f416 upstream.

Currently async flips are busted when bigjoiner is in use.
As a short term fix simply reject async flips in that case.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/9769
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231211081134.2698-1-ville.syrjala@linux.intel.com
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
(cherry picked from commit e93bffc2ac0a833b42841f31fff955549d38ce98)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5977,6 +5977,17 @@ static int intel_async_flip_check_hw(str
 		return -EINVAL;
 	}
 
+	/*
+	 * FIXME: Bigjoiner+async flip is busted currently.
+	 * Remove this check once the issues are fixed.
+	 */
+	if (new_crtc_state->bigjoiner_pipes) {
+		drm_dbg_kms(&i915->drm,
+			    "[CRTC:%d:%s] async flip disallowed with bigjoiner\n",
+			    crtc->base.base.id, crtc->base.name);
+		return -EINVAL;
+	}
+
 	for_each_oldnew_intel_plane_in_state(state, plane, old_plane_state,
 					     new_plane_state, i) {
 		if (plane->pipe != crtc->pipe)


