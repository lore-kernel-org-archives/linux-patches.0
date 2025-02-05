Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745631519B4;
	Wed,  5 Feb 2025 15:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768223; cv=none; b=U0YlVJsm4RP/hSUjtw2TRAjjmaBxuQ8kSg9Z+flu3msc8wjdayzh/jFd3GXWDgrP+umvaD45RcHZZ0zN3MsEkH1fU9BoXuivjxehmXVSWI29mb4dJ+j7MFwNHCIJKyXOLv9mVA0F5mIZJcGeFbARVBb7FtIh37gBRZ06/bKaAnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768223; c=relaxed/simple;
	bh=gKp7aeH3WH593NMbRMvZiD5oeC3uRHtxAtVi3fiBGNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtNN9QQ3zLCbc3MBJXeEnJ83tJXjU87mvWnWybek7z5mZ9n77NsKf9ADMEfi0wTFBYAVvdjYs0LXd4OLiFz4WpvHxS0syW1L5et0Gw+oiJo6GpQa2LCOWAwDu03EOyWsOo6h2qcCRY5D60iPHgPdRM19EHjyDeyxr86K3u7/kAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9jm080Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9jm080Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A56C4CED1;
	Wed,  5 Feb 2025 15:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768223;
	bh=gKp7aeH3WH593NMbRMvZiD5oeC3uRHtxAtVi3fiBGNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9jm080Y3i2o0geWEErJhx4eKv6qkw7UFLAkT7+zRuCQGZc2g0OCj0zUfs2Dez/0/
	 t36cpDFSfX+jaNS5/j9HyxEN8xPzAV4piESzeEPxBHW1HjgLlZ6wMWRe4GdXtd6WkW
	 zBGTLJayco+eXbJEQ7xnV41tetIYHhQny2nZNNZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 514/623] idpf: fix transaction timeouts on reset
Date: Wed,  5 Feb 2025 14:44:16 +0100
Message-ID: <20250205134515.890299922@linuxfoundation.org>
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

From: Emil Tantilov <emil.s.tantilov@intel.com>

[ Upstream commit 137da75ba72593598898a4e79da34f4b2da5d151 ]

Restore the call to idpf_vc_xn_shutdown() at the beginning of
idpf_vc_core_deinit() provided the function is not called on remove.
In the reset path the mailbox is destroyed, leading to all transactions
timing out.

Fixes: 09d0fb5cb30e ("idpf: deinit virtchnl transaction manager after vport and vectors")
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index d46c95f91b0d8..7639d520b8063 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -3077,12 +3077,21 @@ int idpf_vc_core_init(struct idpf_adapter *adapter)
  */
 void idpf_vc_core_deinit(struct idpf_adapter *adapter)
 {
+	bool remove_in_prog;
+
 	if (!test_bit(IDPF_VC_CORE_INIT, adapter->flags))
 		return;
 
+	/* Avoid transaction timeouts when called during reset */
+	remove_in_prog = test_bit(IDPF_REMOVE_IN_PROG, adapter->flags);
+	if (!remove_in_prog)
+		idpf_vc_xn_shutdown(adapter->vcxn_mngr);
+
 	idpf_deinit_task(adapter);
 	idpf_intr_rel(adapter);
-	idpf_vc_xn_shutdown(adapter->vcxn_mngr);
+
+	if (remove_in_prog)
+		idpf_vc_xn_shutdown(adapter->vcxn_mngr);
 
 	cancel_delayed_work_sync(&adapter->serv_task);
 	cancel_delayed_work_sync(&adapter->mbx_task);
-- 
2.39.5



