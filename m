Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5A11AD3FA;
	Mon, 23 Jun 2025 21:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715616; cv=none; b=UFvbZrx944OwUYBYV5xY5CzELwY1TplasZrag5jzrt0XLFyS0naL3pog4kBX/3R1T5ZHcho2I5iw149hr1gXGlEqaCOZBfbR8EDyRoiVj1QF02EA+lRt/Pt9KC6wzeZn/S+j5UvGUB4mmxfkytn3So9nQJ5Ze1xTgQHdgi29y3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715616; c=relaxed/simple;
	bh=b6lLiTmQTY8XGyAEZSsHic8iw8xhtEExvwREhp9ojb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZDH50WGkwUH4g3KOK5WBP0VAWP3wwWcYqzyrtfYdwwa2h1mu2cYgcJuGQMucg9rqwD245MXQDqyyBQDRxhA/rQs3/q+p7LluzaHhfeP+nNhX6e1vNQQFiKzphCe8Sa8YrZiKuoNgElA5jWVIPpG0sOZwrMtncp3Wb1GfMe5054=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xi62PR4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xi62PR4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B98C4CEEA;
	Mon, 23 Jun 2025 21:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715616;
	bh=b6lLiTmQTY8XGyAEZSsHic8iw8xhtEExvwREhp9ojb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xi62PR4nYpCO5xdL7AeX12Yz1U7iIXeJKAgks4iGhwbOULJaRJ2re27Mts9Tmn16/
	 pqNHZSETJmUEDWUs0OARrFzUvw3VyReAZmS1Iz5IczjcFqK3UyN/aXYuGUb9gTBEq4
	 8+XnZwGKfB634nhADqQjr0ExlG8LuWYeUgOc8tCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Malz <robert.malz@canonical.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 245/508] i40e: return false from i40e_reset_vf if reset is in progress
Date: Mon, 23 Jun 2025 15:04:50 +0200
Message-ID: <20250623130651.279857817@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 11e9858cc86a0..87d74b54a3337 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1548,8 +1548,8 @@ static void i40e_cleanup_reset_vf(struct i40e_vf *vf)
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
@@ -1568,7 +1568,7 @@ bool i40e_reset_vf(struct i40e_vf *vf, bool flr)
 
 	/* If VF is being reset already we don't need to continue. */
 	if (test_and_set_bit(I40E_VF_STATE_RESETTING, &vf->vf_states))
-		return true;
+		return false;
 
 	i40e_trigger_vf_reset(vf, flr);
 
-- 
2.39.5



