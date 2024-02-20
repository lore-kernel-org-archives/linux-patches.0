Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8168612D7;
	Tue, 20 Feb 2024 21:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463530; cv=none; b=W3Q/xi2v2brzXfoYEkAw9RYkYaMTxWkigmnAaIodrY7GlJagbLE/DndJGGQdL/mzey0T4qbwAMF2LQE7uwy7DTG2tVkzMQ+O0LkTJQMxR4KKTgWZaOrKvsLR75pG58BNDoM0hVUYpprtt++IYxhz6wSOprTiC0Y8I7WHdr/mOic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463530; c=relaxed/simple;
	bh=1mjzOXpxe694iedR063Nen99IAxmDtqoTWt0ydiRwM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ow0/5jLeBamYzEsrt4O6EscXzfLZNuuhh9wjJX6ScAe6Xr7Z9AMCFxNrAxE+/k7Nr1OlpFgRvIn2TBsD/IyDjZM3xWQGK5bgGJWpN+f2nrTRttKRMGJ6lJS8OznF7Jru8rXPha0182BYoKudPnVIIrdv1Ru8Jnek19g073hRy/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDnPvKqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDnPvKqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746ECC433C7;
	Tue, 20 Feb 2024 21:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463529;
	bh=1mjzOXpxe694iedR063Nen99IAxmDtqoTWt0ydiRwM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDnPvKqVQ3KYtAWGdFsnruXpT8o0vN7D9sC8yGjmpuvGY12qtgzGFv8YPweGA8/5K
	 40adoljLkL5bglTZACt0tp+2vX0qWYR3AS0ldzo3wEIbGLb3vQVuhu7g+8bHeIwK7n
	 jOfn5rdsmuxJdc/4VmDrS6+A5Ukdk8Lv/QxmFab4=
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
Subject: [PATCH 6.6 054/331] i40e: Fix waiting for queues of all VSIs to be disabled
Date: Tue, 20 Feb 2024 21:52:50 +0100
Message-ID: <20240220205639.287278003@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aad39ebff4ab..9d37c0374c75 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5351,7 +5351,7 @@ static int i40e_pf_wait_queues_disabled(struct i40e_pf *pf)
 {
 	int v, ret = 0;
 
-	for (v = 0; v < pf->hw.func_caps.num_vsis; v++) {
+	for (v = 0; v < pf->num_alloc_vsi; v++) {
 		if (pf->vsi[v]) {
 			ret = i40e_vsi_wait_queues_disabled(pf->vsi[v]);
 			if (ret)
-- 
2.43.0



