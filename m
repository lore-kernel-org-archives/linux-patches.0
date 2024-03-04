Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBE91CA94;
	Mon,  4 Mar 2024 21:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587583; cv=none; b=o+e/16EmBDyZavdbDqithBWkBv6KG+e6otEAis7F79/qIvfl+OlW065T2aqxxF95M08hP6SKu0XHPJfIdu+re8JcZ6X8uyGFB8w5pw5XA7Wh3o3YgGEkpOwrKn7UzbPqRy3IJ4wbAscNJy7YPHJUgKS2w1HuK6XAdkd1V14G4a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587583; c=relaxed/simple;
	bh=TYuReQInkYQ2znOQE31OZv1VT2XDEX1/95gM+b2Eb8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5BJz6RPOtCf+IT+tcgmUm2BBYyiG8L8KDBGkBKVuNnGvGCk6qw8Mau3TJOFG/VWf/bQ1VtiZ6fCgjIzFuHtR1s3SfNggklPHpYKzjvT6x1kTQSmdQufcSFu8T9YZ7W0s3ojwaWT/eUZF0DeW9Ko5obAGCKaitOJFh5HR3azN60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6AdrgBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6AdrgBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614AFC433F1;
	Mon,  4 Mar 2024 21:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587583;
	bh=TYuReQInkYQ2znOQE31OZv1VT2XDEX1/95gM+b2Eb8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6AdrgBQ8REYSRZ2n4O1iaSCwyLLlqBjN7UKZVwg1/yNZDM7S2JXBe/LSLsJamWId
	 lfLxvaJdNjlOgFxU8LdydKcRk9FH6St7hI9HCWVi6kFIdjRZjnvxhmUPnrwxQY+NCM
	 iYQI1WXBDHqPZJSph4KwwiQfIRFS5ieGWm5S7Mcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Brady <alan.brady@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.7 004/162] ice: fix dpll input pin phase_adjust value updates
Date: Mon,  4 Mar 2024 21:21:09 +0000
Message-ID: <20240304211551.979700715@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit 3b14430c65b4f510b2a310ca4f18ed6ca7184b00 ]

The value of phase_adjust for input pin shall be updated in
ice_dpll_pin_state_update(..). Fix by adding proper argument to the
firmware query function call - a pin's struct field pointer where the
phase_adjust value during driver runtime is stored.

Previously the phase_adjust used to misinform user about actual
phase_adjust value. I.e., if phase_adjust was set to a non zero value and
if driver was reloaded, the user would see the value equal 0, which is
not correct - the actual value is equal to value set before driver reload.

Fixes: 90e1c90750d7 ("ice: dpll: implement phase related callbacks")
Reviewed-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index 0f836adc0e587..10a469060d322 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -373,7 +373,7 @@ ice_dpll_pin_state_update(struct ice_pf *pf, struct ice_dpll_pin *pin,
 	case ICE_DPLL_PIN_TYPE_INPUT:
 		ret = ice_aq_get_input_pin_cfg(&pf->hw, pin->idx, NULL, NULL,
 					       NULL, &pin->flags[0],
-					       &pin->freq, NULL);
+					       &pin->freq, &pin->phase_adjust);
 		if (ret)
 			goto err;
 		if (ICE_AQC_GET_CGU_IN_CFG_FLG2_INPUT_EN & pin->flags[0]) {
-- 
2.43.0



