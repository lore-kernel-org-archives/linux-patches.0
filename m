Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A736B1BD4F7;
	Tue, 27 May 2025 17:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367030; cv=none; b=Y75C0dBnJHCTMC7EAP+h0iFuBxzq5Zt5Yxk8+Hb/FL9rYE0WdqLTP3BY3zO/t4qQxge+1T/v3mOlQwux1qOomSt0Jcv9zctpY5UzNpbfa8eiGIhnzAQoPLVIwqkO6TC+K8R7VoEg/JZeObTaLzLMnFBZs94mOJzQp+uezfUMhvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367030; c=relaxed/simple;
	bh=BGgwKmZWWr8j+25lsSJGlRTnUxW85siob2Q2oItzI2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e+XLVymwl09NgEO3pp6N6wKgRZFyT1U8wS8sOrAPU/a1NJaHt3wsySgEsCLqY3+hFQrvIpyWMC+hsjEGXKBPUy8yTjNH9id+/rjUIEA/Wy025ThOrzFzWIo3s38t0/N4f8JbwMyEGZixfIjLG63UTjHtfkZ/mVBSoQbn10NA2ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KGsI/Cg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KGsI/Cg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8F4C4CEE9;
	Tue, 27 May 2025 17:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367030;
	bh=BGgwKmZWWr8j+25lsSJGlRTnUxW85siob2Q2oItzI2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KGsI/Cgeq8JGrlmPNxD8PnF2r5oVwH+4Kw+/tnS0uFGy5Cvoha15UZhhMbGjqXNm
	 2zrGacJ4k3Dg2uWQ5D3S4hDlrOslYc2SJg0I4x4CkSkJ8ehTr1HAbPdrOSSKMhdgdQ
	 PLQhWw0FZxrd0CDHLyc6pTzqZkozSMY9Y2yP+S5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 248/783] selftests: pci_endpoint: Skip disabled BARs
Date: Tue, 27 May 2025 18:20:45 +0200
Message-ID: <20250527162523.207278629@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit af1451b6738ec7cf91f2914f53845424959ec4ee ]

Currently BARs that have been disabled by the endpoint controller driver
will result in a test FAIL.

Returning FAIL for a BAR that is disabled seems overly pessimistic.

There are EPC that disables one or more BARs intentionally.

One reason for this is that there are certain EPCs that are hardwired to
expose internal PCIe controller registers over a certain BAR, so the EPC
driver disables such a BAR, such that the host will not overwrite random
registers during testing.

Such a BAR will be disabled by the EPC driver's init function, and the
BAR will be marked as BAR_RESERVED, such that it will be unavailable to
endpoint function drivers.

Let's return FAIL only for BARs that are actually enabled and failed the
test, and let's return skip for BARs that are not even enabled.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20250123120147.3603409-4-cassel@kernel.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/pci_endpoint/pci_endpoint_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/pci_endpoint/pci_endpoint_test.c b/tools/testing/selftests/pci_endpoint/pci_endpoint_test.c
index c267b822c1081..576c590b277b1 100644
--- a/tools/testing/selftests/pci_endpoint/pci_endpoint_test.c
+++ b/tools/testing/selftests/pci_endpoint/pci_endpoint_test.c
@@ -65,6 +65,8 @@ TEST_F(pci_ep_bar, BAR_TEST)
 	int ret;
 
 	pci_ep_ioctl(PCITEST_BAR, variant->barno);
+	if (ret == -ENODATA)
+		SKIP(return, "BAR is disabled");
 	EXPECT_FALSE(ret) TH_LOG("Test failed for BAR%d", variant->barno);
 }
 
-- 
2.39.5



