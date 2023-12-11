Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2F0FBE0;
	Mon, 11 Dec 2023 18:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dr3rXShu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7111BC433C9;
	Mon, 11 Dec 2023 18:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319703;
	bh=43fTJj/43snBKMkAwo6gX6ODXMml8tP/9BUsHQ/Y600=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dr3rXShuZaYb44KA8SN24XY/MZamr89/+4BF+9vcE8b5CxTvkRtzV0O+CIhulBD77
	 F4bYKV8bRAjSs226fkJuBRJe8FItbQXG78P39QmF/CBHQ+kGoulf0uBtJlXxbtG1Lx
	 7HKz74iSKx1zd/nKr1bz8c7PsleSliXu7UqaPSgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 173/244] drm/i915/mst: Fix .mode_valid_ctx() return values
Date: Mon, 11 Dec 2023 19:21:06 +0100
Message-ID: <20231211182053.677981640@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

commit 7cf82b25dd91d7f330d9df2de868caca14289ba1 upstream.

.mode_valid_ctx() returns an errno, not the mode status. Fix
the code to do the right thing.

Cc: stable@vger.kernel.org
Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Fixes: d51f25eb479a ("drm/i915: Add DSC support to MST path")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231127145028.4899-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit c1799032d2ef6616113b733428dfaa2199a5604b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -988,11 +988,15 @@ intel_dp_mst_mode_valid_ctx(struct drm_c
 	 * Big joiner configuration needs DSC for TGL which is not true for
 	 * XE_LPD where uncompressed joiner is supported.
 	 */
-	if (DISPLAY_VER(dev_priv) < 13 && bigjoiner && !dsc)
-		return MODE_CLOCK_HIGH;
+	if (DISPLAY_VER(dev_priv) < 13 && bigjoiner && !dsc) {
+		*status = MODE_CLOCK_HIGH;
+		return 0;
+	}
 
-	if (mode_rate > max_rate && !dsc)
-		return MODE_CLOCK_HIGH;
+	if (mode_rate > max_rate && !dsc) {
+		*status = MODE_CLOCK_HIGH;
+		return 0;
+	}
 
 	*status = intel_mode_valid_max_plane_size(dev_priv, mode, false);
 	return 0;


