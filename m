Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEEE2FE591;
	Tue, 12 Aug 2025 17:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020290; cv=none; b=hlVw34GqUrhuu6+LdilHuCZMomjix0bKjSL2AvUQ4QIuApTQ/wLhORs6y5THhz9rcSb8xqa/szQ440kxPtjPXqPwhauzbg0ncP/BM6mN8X/wfadz4dVpzz86C7E5sZBZw6i+eS3AKT30R+exGJQ/2Hhe4Mau1Jyofn5cOfQ8N28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020290; c=relaxed/simple;
	bh=hMdCDfECN6DqbLVOiqFeqltArl/ocSHeFClJ4Z5yVWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1bhMhmXO87ZxY2ozUp/IOMgV51nY+xjdbA803T/Nj9Gkcqkx4y0AhP+g8e6Imj9jvF7RjCQayJU/dt9kzvTDGPWlXTsUKBxnFb/wpyhoW33M/vqvnVcRRBqGyk6SQaVwGWmwqC2WyyAjDfiUOMFGNjaAegcXfKq9ko+i+aUUvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRwno6ux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRwno6ux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A0DC4CEF0;
	Tue, 12 Aug 2025 17:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020290;
	bh=hMdCDfECN6DqbLVOiqFeqltArl/ocSHeFClJ4Z5yVWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRwno6ux3sTO4vrliUJ6zrDPo/9/Mp2KuiuLrABsPMm0lxm3y1+NsakOycbpYuaOf
	 64J/OzYanX6J5l3uqkoOPvEXV2z08JRRJefK2CQuUro2L/NjU5KKCyhGiRvxHTgITM
	 i5X4lSYMfFhoEHu6vwo6wQYOz+4kCFMeycaChG50=
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
Subject: [PATCH 6.1 037/253] ice: Fix a null pointer dereference in ice_copy_and_init_pkg()
Date: Tue, 12 Aug 2025 19:27:05 +0200
Message-ID: <20250812172950.310613449@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1753,6 +1753,8 @@ ice_copy_and_init_pkg(struct ice_hw *hw,
 		return ICE_DDP_PKG_ERR;
 
 	buf_copy = devm_kmemdup(ice_hw_to_dev(hw), buf, len, GFP_KERNEL);
+	if (!buf_copy)
+		return ICE_DDP_PKG_ERR;
 
 	state = ice_init_pkg(hw, buf_copy, len);
 	if (!ice_is_init_pkg_successful(state)) {


