Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625113;
	b=TdzJBiMUV8eoitjVlq5E5/k/G1LHKA1djuL1bBtJF6NkyhpqP3arOHRo9/uaWSNcGIhB
	 JPWKkMfz70E8jkBM4C64BbUSMuHDK/ipXLl3j9z6QS5nNDM/BGVhxwO9Zz9PM/8ZIuijI
	 CkMYXIim0agA+tFKCN/gl94l12rXiWaFWXBGHeiayH/C+mGtaEQNY6L0JmBHd6XR14YId
	 RVe9/S5Vjv8IJ5/5GUY0/D/byIwSzcRNgu//HQFleTCVTJxWbW9e762v89kOgWa9HRmKH
	 EZTjYboUPVtXjnTCrzPDilcbRKzs0i6CEErjOmSPhvxNWSJOcABorN2pAyFz9nE8yVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=anro231LRbIEgKmH3YL1eBFdq3mwqMQRv6ALbWG5ZE0=;
	b=jU0981w1KAqEPggZsRjKY7ziXJ/opSNtqn2JljNEVrxSA+lUjFtSkB+ODhoN1GttdzbW
	 Bx9s+UQ+71sUl6g20/NJcLdT0o1U8SYFI1aTe1n7JIpSKhkWKwQX9ScwTzhgCVhtPeWRf
	 /GFOWhIPCcTwo0fPVlKjo3gltoZKvU40FV6+aQs5vzt9VmpiCSfpYJp7bsW970trh26aP
	 0Y+dQHyITaAV3koV2KOs+1qWC9SMxRm6BH2oWyJkdFKy4svMlX1/jROU2YZi0EblBGU7E
	 YlP+zLpoIN57HeonCJJwBAORIUS2HT9URhK3of9Dun4X/mCRni99HDMP+TX48nOMu7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=plgfrZDz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E19D606A32A;
	Wed, 25 Nov 2026 16:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=plgfrZDz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3B11F000C0;
	Wed, 25 Nov 2026 16:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625113;
	bh=anro231LRbIEgKmH3YL1eBFdq3mwqMQRv6ALbWG5ZE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=plgfrZDzc5AtNlv+hiIWmqup4dH3VkHtQT/Dh4Oz5+Uhg9J9n6RidluhkrxtWWf7P
	 GYmeHeYwomVqWzPfWQ5XegQh3Kzm7rDttTo+iRVILSEi0opkWJN6RUHiLXKw2JTrHR
	 fpnlLaaH9Ibm7QYsg5AmEfIrVeE0txO+g9jo52wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 409/816] ASoC: SOF: amd: fix amd_sof_acp_remove() teardown ordering
Date: Wed, 25 Nov 2026 15:32:37 +0100
Message-ID: <20261125143858.661287947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit db2167f2e3f72db64d01356cc9f2924d32fd5a51 ]

Call free_irq() before amd_sof_sdw_exit() in amd_sof_acp_remove().
amd_sof_sdw_exit() sets adata->sdw to NULL; if an IRQ fires between
that point and the subsequent free_irq(), acp_irq_handler() may
dereference the now-NULL pdev[] pointer, causing a use-after-free.

Fixes: d948218424bf ("ASoC: SOF: amd: add code for invoking soundwire manager helper functions")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260910132251.1171943-3-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: Context lines differ because the older tree still has the smn_dev pci_dev_put() at the top of amd_sof_acp_remove(); the free_irq()/amd_sof_sdw_exit() swap itself is identical. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index a2abcb6d090ce..919c7bc98bf2b 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -970,12 +970,12 @@ void amd_sof_acp_remove(struct snd_sof_dev *sdev)
 	if (adata->smn_dev)
 		pci_dev_put(adata->smn_dev);
 
-	if (adata->sdw)
-		amd_sof_sdw_exit(sdev);
-
 	if (sdev->ipc_irq)
 		free_irq(sdev->ipc_irq, sdev);
 
+	if (adata->sdw)
+		amd_sof_sdw_exit(sdev);
+
 	if (adata->dmic_dev)
 		platform_device_unregister(adata->dmic_dev);
 
-- 
2.53.0



