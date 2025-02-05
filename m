Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349F91591E3;
	Wed,  5 Feb 2025 15:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768230; cv=none; b=AQVUJSVavhwEiil0EbkYX99i1qzPleFDrBKWB4g1are7zqwvW3x6fQt3F8f1TQ3cl6eredyAop82mSCitXK1vlREI0xK5Bbkw89THfYAlusXf8H+ESegIdD2raBknJ/kX1pdyLXoaB0pq7tVhLp2xrp29C7R9WbOYg565y6AVwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768230; c=relaxed/simple;
	bh=aXovm00uClhS8lY8o8cyY8+i+k0L/0hL+siyaauL6RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+vkl8KCkKAlYHFO4jE9AWvaFcfT2E+cpAotmCavRYGkKIbhoyU4ueXMcesGCGZKX61vb9TDdwfgcIt1mSK9KeTCl0eO6A6w00y9AtMla+mOAoAxv2It70qlNTmYu9Jub5QAwxQc7o0+zLKA4lsDO9I+YTttJNWyxuN6YN30L9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0YGvQja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0YGvQja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B42C4AF09;
	Wed,  5 Feb 2025 15:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768230;
	bh=aXovm00uClhS8lY8o8cyY8+i+k0L/0hL+siyaauL6RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0YGvQjaaevkqAKMyJhKV179DpZ1gShEX5D4WoYi+0CYHchdTw7T4VWYwhtITRx5n
	 AtJoxdMSO6WwaI3zt9A+14m3fOFGqLQ1P6q8cvQWq1F3AhUrUgcFO+F7mkIUsPydU4
	 mLVLbpeLmHBScKTPeNLWu9+hF7S9Mc+iIhgO8/PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manoj Vishwanathan <manojvishy@google.com>,
	David Decotigny <decot@google.com>,
	Brian Vazquez <brianvv@google.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 515/623] idpf: Acquire the lock before accessing the xn->salt
Date: Wed,  5 Feb 2025 14:44:17 +0100
Message-ID: <20250205134515.928404726@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manoj Vishwanathan <manojvishy@google.com>

[ Upstream commit d15fe4edd7decdf14d8ad2b78df100ea23302065 ]

The transaction salt was being accessed before acquiring the
idpf_vc_xn_lock when idpf has to forward the virtchnl reply.

Fixes: 34c21fa894a1 ("idpf: implement virtchnl transaction manager")
Signed-off-by: Manoj Vishwanathan <manojvishy@google.com>
Signed-off-by: David Decotigny <decot@google.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index 7639d520b8063..99bdb95bf2266 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -612,14 +612,15 @@ idpf_vc_xn_forward_reply(struct idpf_adapter *adapter,
 		return -EINVAL;
 	}
 	xn = &adapter->vcxn_mngr->ring[xn_idx];
+	idpf_vc_xn_lock(xn);
 	salt = FIELD_GET(IDPF_VC_XN_SALT_M, msg_info);
 	if (xn->salt != salt) {
 		dev_err_ratelimited(&adapter->pdev->dev, "Transaction salt does not match (%02x != %02x)\n",
 				    xn->salt, salt);
+		idpf_vc_xn_unlock(xn);
 		return -EINVAL;
 	}
 
-	idpf_vc_xn_lock(xn);
 	switch (xn->state) {
 	case IDPF_VC_XN_WAITING:
 		/* success */
-- 
2.39.5



