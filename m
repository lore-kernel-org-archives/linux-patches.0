Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174657FBDD;
	Wed, 21 Feb 2024 14:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524611; cv=none; b=nLh9mObpKrmNaRhDcadr6v2sGFhuzAq0HHXcicOUZldl8P2WaDA6g/MmvbhgCo7DH5stNj9ACiHNAU2Z9uPJAKwYue3I0EvLGSvJK3/4h9zcI6dew9gc03U/cVN3ODa96rcpZX+ngMJ20sOHVCIfPbCnjT+cZ5fXIK8TuMA3hD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524611; c=relaxed/simple;
	bh=abpdRLyhi3xokhumDTPqxPk0gAZ3DRbI8G+xw/3Isn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hayfD2pWZ9YOzxPks7odJ8SPz515VBdP3arNJl/OJpSRAK7JDYTkmxCqP2AADgJ7iju3mtdr6VG8qA7ypHkWBCvFgo6PD+31f2323KdGceCNx2lHRR5eN0HCHO/Tvg1G54aoy3DrN7DMSzpNX/2JWvSzFWZCsl1I3ZEEwvsuNiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0g1aHQh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0g1aHQh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39961C433C7;
	Wed, 21 Feb 2024 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524610;
	bh=abpdRLyhi3xokhumDTPqxPk0gAZ3DRbI8G+xw/3Isn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0g1aHQh9MlgHb9wD3EX4/ap2roXa27HP1lmBC69IVSwlFUUcpWH4Nrfd50E3Lk8hc
	 2Bu1/+TTECG8PbV8YCctL98PobcM0zKEYmVMM7omg34JJzZpK4ko2gc6+s4a2nf0y3
	 VvjUoJ6rIhLseZafrmcc1pT2vPlOEtPxyhuolLSc=
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
Subject: [PATCH 5.10 296/379] i40e: Fix waiting for queues of all VSIs to be disabled
Date: Wed, 21 Feb 2024 14:07:55 +0100
Message-ID: <20240221130003.676472044@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d83b96aa3e42..135acd74497f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5153,7 +5153,7 @@ static int i40e_pf_wait_queues_disabled(struct i40e_pf *pf)
 {
 	int v, ret = 0;
 
-	for (v = 0; v < pf->hw.func_caps.num_vsis; v++) {
+	for (v = 0; v < pf->num_alloc_vsi; v++) {
 		if (pf->vsi[v]) {
 			ret = i40e_vsi_wait_queues_disabled(pf->vsi[v]);
 			if (ret)
-- 
2.43.0



