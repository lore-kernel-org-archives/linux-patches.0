Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BD06FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DBBC433EF;
	Mon,  3 Apr 2023 14:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532735;
	bh=fG9Zl/2hEFisguEQyZVMdPw9Itaf1tOsqcR5AgjBkOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyXo8vfOnAbeoWQYJOgLZUcfGC9wDliWgMnwnJZT2avEnVo5EkChzbKjOBNOcdVvs
	 3mYT0oFZzQ9lj/297A/ZMctxVivF7UymjuPLAEbRNxMJH1YDH4M/V9wf2R7/glI1/J
	 8nuIkFw+TNHOp33jG8U1QcA88ULrPTqaBxo8OGmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/181] drm/i915/tc: Fix the ICL PHY ownership check in TC-cold state
Date: Mon,  3 Apr 2023 16:08:52 +0200
Message-Id: <20230403140418.266442533@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit 38c583019484f190d5b33f59b8ae810e6b1763c6 ]

The commit renaming icl_tc_phy_is_in_safe_mode() to
icl_tc_phy_take_ownership() didn't flip the function's return value
accordingly, fix this up.

This didn't cause an actual problem besides state check errors, since
the function is only used during HW readout.

Cc: José Roberto de Souza <jose.souza@intel.com>
Fixes: f53979d68a77 ("drm/i915/display/tc: Rename safe_mode functions ownership")
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230316131724.359612-4-imre.deak@intel.com
(cherry picked from commit f2c7959dda614d9b7c6a41510492de39d31705ec)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_tc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_tc.c b/drivers/gpu/drm/i915/display/intel_tc.c
index e5af955b5600f..8d6dac32c8960 100644
--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -440,9 +440,9 @@ static bool icl_tc_phy_is_owned(struct intel_digital_port *dig_port)
 				PORT_TX_DFLEXDPCSSS(dig_port->tc_phy_fia));
 	if (val == 0xffffffff) {
 		drm_dbg_kms(&i915->drm,
-			    "Port %s: PHY in TCCOLD, assume safe mode\n",
+			    "Port %s: PHY in TCCOLD, assume not owned\n",
 			    dig_port->tc_port_name);
-		return true;
+		return false;
 	}
 
 	return val & DP_PHY_MODE_STATUS_NOT_SAFE(dig_port->tc_phy_fia_idx);
-- 
2.39.2



