Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E5B184527;
	Mon, 12 Aug 2024 16:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480373; cv=none; b=OQDkn0UZoZ4pwxxxP5r1jglyaBRQaj2DSYrLGVrceni7aNaoDp/KFxtCDVBVc24TWD62IdJKzrdv9kRQvLMz9svpvI8B1fiC2vzUr9WsJfU6xeeid6qSZ7Gxi3Rc1E3txcSlzUZZsKKz4G5gYzIZyQfqmevBduD6r44/at77aaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480373; c=relaxed/simple;
	bh=WH5Vi8i7eYWxVI0cclLO1EfgIK20d7dNKXdn2MtPQu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQ91niL1xGvhXqNO0XRkv7RGK9KgsYNfsxzIYuNMJqgPxHQPaoYUXbFIP3rPKO1TITILJz4em2xbMLnIL7sXLkQEiK5/dBYbaSKMDb5vtceZFYfvKDsEcVu3Ba7ZuvhYD30sQUAMSMz2gufPrwLirrKz9YR0lygL9rFaCcq2kM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfACpbX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfACpbX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5DCC32782;
	Mon, 12 Aug 2024 16:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480373;
	bh=WH5Vi8i7eYWxVI0cclLO1EfgIK20d7dNKXdn2MtPQu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfACpbX5wCTYO6iOs86nnLiHt7uw1kjXlDVDPR39Zy7H7YVZao5cD+K6odRclWB16
	 ndyKqfarXwtU2AQgPTpGt0Cta7AyGyCVDlk2ILDD3FY95OzUurAumfKBR+uMLwZXfu
	 +FuTqNnU27l3c1HUeS5pmKfBdwkWUZujWLApH4Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.10 177/263] drm/i915/display: correct dual pps handling for MTL_PCH+
Date: Mon, 12 Aug 2024 18:02:58 +0200
Message-ID: <20240812160153.324916104@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>

commit 1b85bdb0fadb42f5ef75ddcd259fc1ef13ec04de upstream.

On the PCH side the second PPS was introduced in ICP+.Add condition
On MTL_PCH and greater platform also having the second PPS.

Note that DG1/2 south block only has the single PPS, so need
to exclude the fake DG1/2 PCHs

Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/11488
Fixes: 93cbc1accbce ("drm/i915/mtl: Add fake PCH for Meteor Lake")
Cc: <stable@vger.kernel.org> # v6.9+
Signed-off-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240801111141.574854-1-dnyaneshwar.bhadane@intel.com
(cherry picked from commit da1878b61c8d480c361ba6a39ce8a31c80b65826)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_backlight.c | 3 +++
 drivers/gpu/drm/i915/display/intel_pps.c       | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_backlight.c b/drivers/gpu/drm/i915/display/intel_backlight.c
index 071668bfe5d1..6c3333136737 100644
--- a/drivers/gpu/drm/i915/display/intel_backlight.c
+++ b/drivers/gpu/drm/i915/display/intel_backlight.c
@@ -1449,6 +1449,9 @@ bxt_setup_backlight(struct intel_connector *connector, enum pipe unused)
 
 static int cnp_num_backlight_controllers(struct drm_i915_private *i915)
 {
+	if (INTEL_PCH_TYPE(i915) >= PCH_MTL)
+		return 2;
+
 	if (INTEL_PCH_TYPE(i915) >= PCH_DG1)
 		return 1;
 
diff --git a/drivers/gpu/drm/i915/display/intel_pps.c b/drivers/gpu/drm/i915/display/intel_pps.c
index 42306bc4ba86..7ce926241e83 100644
--- a/drivers/gpu/drm/i915/display/intel_pps.c
+++ b/drivers/gpu/drm/i915/display/intel_pps.c
@@ -351,6 +351,9 @@ static int intel_num_pps(struct drm_i915_private *i915)
 	if (IS_GEMINILAKE(i915) || IS_BROXTON(i915))
 		return 2;
 
+	if (INTEL_PCH_TYPE(i915) >= PCH_MTL)
+		return 2;
+
 	if (INTEL_PCH_TYPE(i915) >= PCH_DG1)
 		return 1;
 
-- 
2.46.0



