Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F1678286;
	Mon,  8 Apr 2024 13:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582034; cv=none; b=psbCKJPnnTPRR8kzgIVFVvfsOhN7weHrx0bnEWv8bzz9g70EXhZ0iAnryo+/sLUbuV48XsGjyUTGkgUmYFNSH05c3Sy+Nm1g3ZTxOZ/pR8wzbLO15UMWACuSJx1FqjQnqqxI8WB0RMm33aSchLwZmHMwn9zuXVdK1YwOTPz4WcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582034; c=relaxed/simple;
	bh=WsVjFeAherLOP9mQdhqz+fgFpC8GX4QRjioI4ensOus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkTdCuVbKrIhThZYFMMxZhJoBiy3RYKqigOY0+hIoBBEh1qORnZ4vH/9n9LF9DR1IPPDndwijaX+45pyALU4+txvE8DVarDZSgDaaRHArLXr0XYSO9Fq6FljdUlJFgtBUaiu8Wyo5y6nbbHJxa2MI8HSGt8boLFu13LluAPx5yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcc8vezC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcc8vezC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D163BC433F1;
	Mon,  8 Apr 2024 13:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582034;
	bh=WsVjFeAherLOP9mQdhqz+fgFpC8GX4QRjioI4ensOus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcc8vezCIvHSrSOaflFcrWvi1mTZPnawbPZm6souhCtowK5bjEAtmJwY6ewpHAvwi
	 /cOKfBMvYVmGkM7g4yR8fj70hXG5RkUxyFw/Dd3Eu32r2aTvEPFC41iV6dSt6bQDfa
	 1ZytfepEEA73U/saLyQxBYq3XItUF51IhWSkVIrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 6.1 073/138] i40e: Store the irq number in i40e_q_vector
Date: Mon,  8 Apr 2024 14:58:07 +0200
Message-ID: <20240408125258.495553345@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <jdamato@fastly.com>

[ Upstream commit 6b85a4f39ff7177b2428d4deab1151a31754e391 ]

Make it easy to figure out the IRQ number for a particular i40e_q_vector by
storing the assigned IRQ in the structure itself.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: ea558de7238b ("i40e: Enforce software interrupt during busy-poll exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h      | 1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 7d4cc4eafd59e..59c4e9d642980 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -992,6 +992,7 @@ struct i40e_q_vector {
 	struct rcu_head rcu;	/* to avoid race with update stats on free */
 	char name[I40E_INT_NAME_STR_LEN];
 	bool arm_wb_state;
+	int irq_num;		/* IRQ assigned to this q_vector */
 } ____cacheline_internodealigned_in_smp;
 
 /* lan device */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5be56db1dafda..ee0d7c29e8f17 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4145,6 +4145,7 @@ static int i40e_vsi_request_irq_msix(struct i40e_vsi *vsi, char *basename)
 		}
 
 		/* register for affinity change notifications */
+		q_vector->irq_num = irq_num;
 		q_vector->affinity_notify.notify = i40e_irq_affinity_notify;
 		q_vector->affinity_notify.release = i40e_irq_affinity_release;
 		irq_set_affinity_notifier(irq_num, &q_vector->affinity_notify);
-- 
2.43.0



