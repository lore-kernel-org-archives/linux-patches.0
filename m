Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2E4386C0D;
	Sat, 12 Sep 2026 08:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203291; cv=none; b=Zxx0j827kTMG0S71MlhuPEVPyHmXwFjxxk3+xDz8PkfJqVRJvFf4RuhTIRuC1e2XQjWQ2KkzM4Bwp0kjz7dkWDtr3FenOntLEIn9pQ2p0llx8pk6u43G5FTBBj6VPM8qvgZxkydjTrEpzIYWo9XcVkxaJ1a2PRjQEp2J9GJ1KzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203291; c=relaxed/simple;
	bh=NWzHGq2ouPybMajRSgSa5YKUTt89HcXUZdHty+O4vYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTnJamiW+b1PMkrLd8sfe3fQMzfDeE++nX7jXads/6UscO049aVUjCFw/bVmv1240iXTDUxSwDO8UR1CQ7q7DMHFsMdDuvnJrJz4FHXFIVi6BVDAFF92GhgzrqEQUQb0JgV3b7WS48DLjzTXHrb+Zsp6v+iGDByi2ctRZBLiVGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsGaOC7X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsGaOC7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6CF1F00899;
	Sat, 12 Sep 2026 08:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203289;
	bh=bVaDp3a/HbMKiybqpPI33IbDUe8NvvQfo4Hqv/cZMsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gsGaOC7X/I3ehRHUpVkF7RVEmUWsaqogybVd1DKH7S2ntdLn+fuRnhs+JVkLlqdPE
	 82TGgDWxxHXewVeL8ndQB1h7Q7l7nZWPzPVBYMIn2RVi8BUPFnBmCmvfeAUbDJ21b7
	 ValJDja1SCyLoJDXcash9c3qm4gog2ifcxONYZOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1371/1815] idpf: add missing cpu_to_le32 in idpf_tx_splitq_build_flow_desc
Date: Sat, 12 Sep 2026 08:52:01 +0200
Message-ID: <20260912065721.215061690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit b802a8c1ca16f9490fa0cb3110c00c10d52b392d ]

idpf_tx_splitq_build_flow_desc performs a 32-bit store to &cmd_dtype
to set the 8-bit cmd_dtype and zero the adjacent 3-byte timestamp
field in a single operation.

Descriptors are in little endian. Add missing cpu_to_le32 and cast to
__le32 to ensure the fields are written correctly also on big endian
platforms.

Fixes: 1a49cf814fe1 ("idpf: add Tx timestamp flows")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index c724d429a7aa9..91ca75e454630 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -2408,7 +2408,7 @@ void idpf_tx_splitq_build_flow_desc(union idpf_tx_flex_desc *desc,
 				    struct idpf_tx_splitq_params *params,
 				    u16 td_cmd, u16 size)
 {
-	*(u32 *)&desc->flow.qw1.cmd_dtype = (u8)(params->dtype | td_cmd);
+	*(__le32 *)&desc->flow.qw1.cmd_dtype = cpu_to_le32((u8)(params->dtype | td_cmd));
 	desc->flow.qw1.rxr_bufsize = cpu_to_le16((u16)size);
 	desc->flow.qw1.compl_tag = cpu_to_le16(params->compl_tag);
 }
-- 
2.53.0



