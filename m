Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5E223BF9F;
	Mon, 23 Jun 2025 13:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685260; cv=none; b=stDQS9yDR/LgaQDA1cqGnWPPfUgWesNezQf+Y6QyNhSPWIWFfJsZ8gvWULSHQJimFfHhS0rsB0GKKVEqfrmgOZxAxsdwx9iBfWxfpVCaox7zCh/S9KVOIQdNJgscWiej1QQC2fpSxKGAy7QojUS5vnxaulVPguxemphWTmioBOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685260; c=relaxed/simple;
	bh=iv/fKRaWWueOKDn1HKNmpAnzM+FNh0vy/ZRyEeTWJiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8XA8fAcXn12DSxZ1JBA4/m9bg9TlHFq29WdR7F3ZxPd0W2YpOIHw4YwbKrz5YWRlGb1NdLwjXmiHH3UKZR+43F+DqgThp44Ccel7IutPfM0EcfiKwpTYgUkzh8twutqv/1bAo7wOUcme8DuMI7+K4+pVT+3k/yKeQ/5469RQts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZmwqWtDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZmwqWtDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969ABC4CEEA;
	Mon, 23 Jun 2025 13:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685259;
	bh=iv/fKRaWWueOKDn1HKNmpAnzM+FNh0vy/ZRyEeTWJiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZmwqWtDguEdgF1BeRgL6tthQCC27hhHL8SQ67cmbtuQiyWe4tqZI532Cvo1lb9uY8
	 IHdLC/TytsXT6WFc25MPnCv0lFRI5ndh1nuUnGF9CK2mhyBX9gjDZFwOReqjmUxXC4
	 8uprZ2ZQptD64MfzNBTp8hlnhqlqrqe+D4BX1kQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Malz <robert.malz@canonical.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/222] i40e: return false from i40e_reset_vf if reset is in progress
Date: Mon, 23 Jun 2025 15:06:54 +0200
Message-ID: <20250623130614.475282979@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 81f428d0b7a4c..783581739417f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1456,8 +1456,8 @@ static void i40e_cleanup_reset_vf(struct i40e_vf *vf)
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
@@ -1476,7 +1476,7 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 
 	/* If VF is being reset already we don't need to continue. */
 	if (test_and_set_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
-		return true;
+		return false;
 
 	i40e_trigger_vf_reset(vf, flr);
 
-- 
2.39.5



