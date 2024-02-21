Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD444D5B7;
	Wed, 21 Feb 2024 13:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523167; cv=none; b=bSlUKEz2vrccR9hva3tpgNrwpoighTUHnWkKlUScjcui0qoVh4W/a1jR68eovPmfKS5BdRK903nTZE67RcdjPP08oo2jMvr7ftRZ9vF6R7a4ZmmG4cE+gUoJsFIvEx8K/t7Ve/9m/KkG4ORIRWsnZO9LVBK3wLmEzmO4/+DQpeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523167; c=relaxed/simple;
	bh=5h2skk5KFC7l5nzCti3arsOGGB0bz5D5WoyzPWyqohg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcEsmoEPj4orUSY04cKbylSOGE697/0ktAl04gCp6gO2tYCcOfrPU9Q6aNWLWYYToCgKdCxpo72gSgUkDVyoKCbQgVX5h5jMWGAVfKqGLlLz/mR5IvvFqsph295NBSpSAu+Gc4kDzpJWk6b1iUXkdDnHiwM7eMAE0Atd9MbVPok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gy4efiFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gy4efiFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54832C433C7;
	Wed, 21 Feb 2024 13:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523166;
	bh=5h2skk5KFC7l5nzCti3arsOGGB0bz5D5WoyzPWyqohg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gy4efiFx1K0TlOq8IYi7iC2S1ji7mRqTza2mUpZL3ImNVlFZOMU1OIJF1uPTQUvGI
	 z3wSJQahkbTk7Upss0viYhQSMMFoFp2wZiYBXT5RFIroUUgP0N8QEqDUn68weynxFq
	 4TGZI7Fk0LJU+r/LkDFKM+kbJIlZLyzp3l2d2rZI=
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
Subject: [PATCH 5.15 355/476] i40e: Fix waiting for queues of all VSIs to be disabled
Date: Wed, 21 Feb 2024 14:06:46 +0100
Message-ID: <20240221130021.118794671@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 10737418565f..3d2b92a952a6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5323,7 +5323,7 @@ static int i40e_pf_wait_queues_disabled(struct i40e_pf *pf)
 {
 	int v, ret = 0;
 
-	for (v = 0; v < pf->hw.func_caps.num_vsis; v++) {
+	for (v = 0; v < pf->num_alloc_vsi; v++) {
 		if (pf->vsi[v]) {
 			ret = i40e_vsi_wait_queues_disabled(pf->vsi[v]);
 			if (ret)
-- 
2.43.0



