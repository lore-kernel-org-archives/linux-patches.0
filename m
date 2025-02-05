Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED3A15EFA1;
	Wed,  5 Feb 2025 15:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767620; cv=none; b=aszNRIMMLgM3l3+8fZYTzdofKHr3MDghKPIYVRPy3L9SgUmt3ABMv0vNzMSFuQ9A4tM7TZPmcWRkJlkm3dqcSOdN2aDUhgoG097EufPwe6gKjsV9YkUHBTglupwhW8WsS4QfW2fPfSRQC2utDPbpcW5m0nlC78NP9IuNf43d2mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767620; c=relaxed/simple;
	bh=Rl3rzVkGtbAHOcf/4fezL1kIuBq03u9riR94VDtw6Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CapYOt7CToZjRKnIZT9W6Ze3cbKTPVd9g4DsqUyqnZ2YoN7QZFJv0XOQllN+1fwWLpBz0K36wgM0tP49xNrMV1x029bIgauabfTX2LhrbUKZvYbeB6NyxPCe2EYWQqWyodT5+34Rxggw/VW6Fyrkpam5KTWRTJ+uBoi/vNTcLSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avZ2pV0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avZ2pV0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17CCC4CED1;
	Wed,  5 Feb 2025 15:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767620;
	bh=Rl3rzVkGtbAHOcf/4fezL1kIuBq03u9riR94VDtw6Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avZ2pV0H+ShUdJ4Uq0bFehVcl9/TEMJVamZoMjpdLWdelb26AEeqdhWJ/ASOJdhgL
	 lo29P5C88q6arNoETryLGjlcN78r3AsVEWXdiW24/XBBCmjF4V+EqE27SZUG4vE64N
	 P9By94otXE4Inbp1LxWlQU9NDFpo4c3m2EQkSAx0=
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
Subject: [PATCH 6.12 483/590] idpf: fix transaction timeouts on reset
Date: Wed,  5 Feb 2025 14:43:58 +0100
Message-ID: <20250205134513.741031263@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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



