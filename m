Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8132309DB1;
	Mon, 13 Oct 2025 15:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370078; cv=none; b=khbcPGzIT/QH/rOo1bnIo3FNzwgOegdrNk2QC5cRtYbN+iGyDJ64DpOj/KOeAny12NxJ7wWDLLW0jaNF3LTsFqA+rxcJ/wUMwLvtXAoISoT/WLzsRsUyLMd43Od+uRovim+qQihF5QV/EpfVu8dIh4wl7iJuTM3QAk61X2qA71A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370078; c=relaxed/simple;
	bh=iqjYI+V0nsjvj4/MFFw7sBN2KiopyDaXZeA5L65NiFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtoBf4upk3IPPr7Tah9EoptdDvR82XUiIxRKfMQID9HiQcbXULKkmJwbBZdjEdUSSwYlCBdwekwd+IOKctytM+iE6yc70ivLT0C6M9YfMUKi6Z5PTHpV4x996b9wmGyOEpBiSWSHjfeP39ZjaQyXDg6htti+QznSD/dMBv0Ru50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnW6/Txq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnW6/Txq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8C1C4CEE7;
	Mon, 13 Oct 2025 15:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370077;
	bh=iqjYI+V0nsjvj4/MFFw7sBN2KiopyDaXZeA5L65NiFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnW6/TxqTv92FSNUCEDEepyp9UgPRZBMnDqECqflKfJtPRaujmHTo/s9UYy3u5nLQ
	 ZQ2AzYNkCpUyo8Uskgr/lli0nB7ovMd6jLpje0ua3Ux4yhZJC2Btp2Un/X8SftO5bU
	 L/gaLbAG8uekCvHEj3gXB7wvAyAAzdJGfIpAHg08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 470/563] idpf: fix mismatched free function for dma_alloc_coherent
Date: Mon, 13 Oct 2025 16:45:31 +0200
Message-ID: <20251013144428.316210435@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit b9bd25f47eb79c9eb275e3d9ac3983dc88577dd4 ]

The mailbox receive path allocates coherent DMA memory with
dma_alloc_coherent(), but frees it with dmam_free_coherent().
This is incorrect since dmam_free_coherent() is only valid for
buffers allocated with dmam_alloc_coherent().

Fix the mismatch by using dma_free_coherent() instead of
dmam_free_coherent

Fixes: e54232da1238 ("idpf: refactor idpf_recv_mb_msg")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Link: https://patch.msgid.link/20250925180212.415093-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index 6330d4a0ae075..c1f34381333d1 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -702,9 +702,9 @@ int idpf_recv_mb_msg(struct idpf_adapter *adapter)
 		/* If post failed clear the only buffer we supplied */
 		if (post_err) {
 			if (dma_mem)
-				dmam_free_coherent(&adapter->pdev->dev,
-						   dma_mem->size, dma_mem->va,
-						   dma_mem->pa);
+				dma_free_coherent(&adapter->pdev->dev,
+						  dma_mem->size, dma_mem->va,
+						  dma_mem->pa);
 			break;
 		}
 
-- 
2.51.0



