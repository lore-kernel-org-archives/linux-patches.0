Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B482ED172;
	Tue, 17 Jun 2025 16:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176787; cv=none; b=CegSmS2l0izHiY5pEI3ShOQNhZrXSqbZCeuJ5A6FQGOoocG3qW8bz0F0IDVF1uDtbG18Yo5KsyiWqxtSVJ4DqM6Pga21h6S8W0rSs6hVNxRkVLRSqmw0f5wZB6Kio9pLI+jxTa0/xCzBbh/SYObPMEQWDIP6cH3L2vhEudHjWQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176787; c=relaxed/simple;
	bh=W4GtbGS0G6RNg7+bf9Y9lSxuAZ4xUad7ERANDXkVFRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhNUSFwiMPuyUrtLdwP50L+3Rn1aeli42qq1UsLSYAjsf52Ldf5OlooE3COuhJYSh8J985AQTTyFKcQA7lRp4IFxmz39B6GTv1F8xcttPsT4u8hbm2jttCBlbdWSND+B3y5+fxsdX0btIYNFO9jM4JizkLVjsxiyd0yA+DdDuzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFWmiPR6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFWmiPR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC510C4CEE3;
	Tue, 17 Jun 2025 16:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176787;
	bh=W4GtbGS0G6RNg7+bf9Y9lSxuAZ4xUad7ERANDXkVFRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFWmiPR6nwPAFEySJsBslT1T6BshS4L4n85I4L0ZL0kpMEyW+CFC8JWkHmwegrraf
	 qp4gktrcRLJim0gtmQ9TdQN5YuCuzribcl1HaQpE19IepiTT86yXo6refxr2NJoej3
	 p70PIP2mKrgVdb5OoOPRlMNO9alh7X7+3CMUjmTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Malz <robert.malz@canonical.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 313/356] i40e: return false from i40e_reset_vf if reset is in progress
Date: Tue, 17 Jun 2025 17:27:08 +0200
Message-ID: <20250617152350.762702123@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Malz <robert.malz@canonical.com>

[ Upstream commit a2c90d63b71223d69a813333c1abf4fdacddbbe5 ]

The function i40e_vc_reset_vf attempts, up to 20 times, to handle a
VF reset request, using the return value of i40e_reset_vf as an indicator
of whether the reset was successfully triggered. Currently, i40e_reset_vf
always returns true, which causes new reset requests to be ignored if a
different VF reset is already in progress.

This patch updates the return value of i40e_reset_vf to reflect when
another VF reset is in progress, allowing the caller to properly use
the retry mechanism.

Fixes: 52424f974bc5 ("i40e: Fix VF hang when reset is triggered on another VF")
Signed-off-by: Robert Malz <robert.malz@canonical.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index d5509bc16d0d5..348869f05020f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1552,8 +1552,8 @@ static void i40e_cleanup_reset_vf(struct i40e_vf *vf)
  * @vf: pointer to the VF structure
  * @flr: VFLR was issued or not
  *
- * Returns true if the VF is in reset, resets successfully, or resets
- * are disabled and false otherwise.
+ * Return: True if reset was performed successfully or if resets are disabled.
+ * False if reset is already in progress.
  **/
 bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 {
@@ -1572,7 +1572,7 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 
 	/* If VF is being reset already we don't need to continue. */
 	if (test_and_set_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
-		return true;
+		return false;
 
 	i40e_trigger_vf_reset(vf, flr);
 
-- 
2.39.5



