Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420DC53816;
	Wed, 21 Feb 2024 13:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521731; cv=none; b=UHiXcl1uSC2qlAFRxEdgi/ciy+uyJHrgohoBqgUtHukcre/sbQz8Ukd2SsMFi933NTtWtiwHGPo+X7f+FaG8kr50kfuB1IGFkevfHtiNwu8z3rLy/L7DAIF5r3kc6sMLVwE4NrssBpGSgDD43uIylsSSDImdESnSkN8IRw5ooF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521731; c=relaxed/simple;
	bh=ndCCF/MhfZA89RXNxNTnjpb6JA/8Y1hiquJTrOjueD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0ahEFyicYvRiGf1P0kub+MFciLhzW1kSHZ/k7iyYFWNyAGc2GnHHT9mriAuDuDhC/KQoK21qdbz2buHIDVUrElxQC8oSi4kGIUOqXyFRD1c4E1AN62DZFwPXfW41sJ7OMnIO8YdNwb/uVGXIbnuEMBMkffykedD4Mp1rhpn4Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yH/xzMh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yH/xzMh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CECC433F1;
	Wed, 21 Feb 2024 13:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521731;
	bh=ndCCF/MhfZA89RXNxNTnjpb6JA/8Y1hiquJTrOjueD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yH/xzMh4nrRdNcYrheKfYuIYAyAhegpTuRYIIPPin/lZnpT/HwlQetvX8l9NnN6DY
	 h4CSuvh+P3hDCh4h2ydf9w1ml+d3KR32s4j1ytAd3v9nJb9BgpXQBMe36yFGXfLois
	 56i49FrA8q5jW8jGrFHwO7DCDZDAk8duz2U6duvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 4.19 172/202] i40e: Fix waiting for queues of all VSIs to be disabled
Date: Wed, 21 Feb 2024 14:07:53 +0100
Message-ID: <20240221125937.335082256@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit c73729b64bb692186da080602cd13612783f52ac ]

The function i40e_pf_wait_queues_disabled() iterates all PF's VSIs
up to 'pf->hw.func_caps.num_vsis' but this is incorrect because
the real number of VSIs can be up to 'pf->num_alloc_vsi' that
can be higher. Fix this loop.

Fixes: 69129dc39fac ("i40e: Modify Tx disable wait flow in case of DCB reconfiguration")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 97cf144a4ff9..491e5c776306 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4966,7 +4966,7 @@ static int i40e_pf_wait_queues_disabled(struct i40e_pf *pf)
 {
 	int v, ret = 0;
 
-	for (v = 0; v < pf->hw.func_caps.num_vsis; v++) {
+	for (v = 0; v < pf->num_alloc_vsi; v++) {
 		if (pf->vsi[v]) {
 			ret = i40e_vsi_wait_queues_disabled(pf->vsi[v]);
 			if (ret)
-- 
2.43.0



