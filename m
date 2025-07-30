Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35621296148;
	Wed, 30 Jul 2025 09:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868721; cv=none; b=FmieQn8Iz8/zLpdg9bWxYNFddjuXR136vpuQs5csYO7QK75Sur6LCjjjK3F/xMSrELBpRZSvzZGmVPPgKZVMUCbvuDgL/I1OhRCVnflyMB6DWKF3vZimbXz8lXWpOKFdSXNWb+mH1fLLMgRjTDZwoPG+PxAynrC0oVXsUf1aNAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868721; c=relaxed/simple;
	bh=ro/rzkybLkKaXEhYohOqPf8e9mupnXnPpK82ZLgiWY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyxTCpm1KysXm/szrrwhyI6/EgJ4YNtHBnL1TzzNFZMl1qhLnSCkKPjrxq81m6Zl72M7lmr7oOGNO/khDcvzcqYD9rot5OquLsBJuvoClsrSRv7gr4iJfT+Ge1cP1R80utnU1BqM/4IqTpBaOBFroXsdUCBE4xoMDWBDT2d8kLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWxiPX+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWxiPX+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCF6C4CEF5;
	Wed, 30 Jul 2025 09:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868719;
	bh=ro/rzkybLkKaXEhYohOqPf8e9mupnXnPpK82ZLgiWY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWxiPX+by7BbcyjPvog5cbADUnfomP3VsqYh4bw7405I46f5E4EuZWvdVoLNpPd2P
	 JYD3Wuz60P40QoP+2c5GBeF0HuWhCbJHXgX8ZH1XJUMoF1ppUGgR8AU4QbTDaekyXY
	 PXlXgsNYBrnNIMgLDQkhlS82z4ELQcujPHl0aOkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 059/117] ice: Fix a null pointer dereference in ice_copy_and_init_pkg()
Date: Wed, 30 Jul 2025 11:35:28 +0200
Message-ID: <20250730093235.848800470@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 4ff12d82dac119b4b99b5a78b5af3bf2474c0a36 upstream.

Add check for the return value of devm_kmemdup()
to prevent potential null pointer dereference.

Fixes: c76488109616 ("ice: Implement Dynamic Device Personalization (DDP) download")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_ddp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/intel/ice/ice_ddp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ddp.c
@@ -2277,6 +2277,8 @@ enum ice_ddp_state ice_copy_and_init_pkg
 		return ICE_DDP_PKG_ERR;
 
 	buf_copy = devm_kmemdup(ice_hw_to_dev(hw), buf, len, GFP_KERNEL);
+	if (!buf_copy)
+		return ICE_DDP_PKG_ERR;
 
 	state = ice_init_pkg(hw, buf_copy, len);
 	if (!ice_is_init_pkg_successful(state)) {


