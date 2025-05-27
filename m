Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C643227A133;
	Tue, 27 May 2025 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367125; cv=none; b=hF70iLoS1t+gVVqmuzDMNzaMZW2aMV3xT/xZYrg8bxoBAEFX55G734cfmT30uGe6hS9OUiX+QE7euYl58DopUfUx9VSXBBJ3D3jIhlfpPCb0UA7w534weNBFvp7NBN1XBQZ5vzchj+/oa/Ei1bTSwIQRaZTAAYbyiYI594+QSHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367125; c=relaxed/simple;
	bh=tdSHUaEm5JHt/tkdKsjaoZwJzYvz59f1N6kOyJu6zS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S/DjxSlEnWxO9WnE70lMhGfK0KNendk/IhtvGZ4XKSbTMnwmxjV9ybrHVwSEgYn7fqY89eK/AyS5w1lEOaOxRDHZMxSn1qRcB8ZqlMpVjbRc8JrWN0xnoKni9z+IZ4EEyEFhpyyT0jOGyTXJwZb9B0MdlO7p1kUD3dW8tdKAKm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRi8G9+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRi8G9+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3198AC4CEEA;
	Tue, 27 May 2025 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367125;
	bh=tdSHUaEm5JHt/tkdKsjaoZwJzYvz59f1N6kOyJu6zS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRi8G9+bmL/0Jmot97TJKjITxoUjaUoYwpjmfXMBch7yoxEFLjCk0lUjQbFKck51i
	 3sd092o2j/tNLAt8YGuZhm1YM6xk9ACVE30gzo3N7laWSheL3hJbgBvdISbTCBJXzm
	 A43sEPO3fIJ7QOo5OiVVnMKecgCgjr37lJ+6lc1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 247/783] misc: pci_endpoint_test: Give disabled BARs a distinct error code
Date: Tue, 27 May 2025 18:20:44 +0200
Message-ID: <20250527162523.167242757@linuxfoundation.org>
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

[ Upstream commit 7e80bbef1d697dbce7a39cfad0df770880fe3f29 ]

The current code returns -ENOMEM if test->bar[barno] is NULL.

There can be two reasons why test->bar[barno] is NULL:

  1) The pci_ioremap_bar() call in pci_endpoint_test_probe() failed.
  2) The BAR was skipped, because it is disabled by the endpoint.

Many PCI endpoint controller drivers will disable all BARs in their
init function. A disabled BAR will have a size of 0.

A PCI endpoint function driver will be able to enable any BAR that
is not marked as BAR_RESERVED (which means that the BAR should not
be touched by the EPF driver).

Thus, perform check if the size is 0, before checking if
test->bar[barno] is NULL, such that we can return different errors.

This will allow the selftests to return SKIP instead of FAIL for
disabled BARs.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20250123120147.3603409-3-cassel@kernel.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pci_endpoint_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 4c0f37ad0281b..8a7e860c06812 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -295,11 +295,13 @@ static int pci_endpoint_test_bar(struct pci_endpoint_test *test,
 	struct pci_dev *pdev = test->pdev;
 	int buf_size;
 
+	bar_size = pci_resource_len(pdev, barno);
+	if (!bar_size)
+		return -ENODATA;
+
 	if (!test->bar[barno])
 		return -ENOMEM;
 
-	bar_size = pci_resource_len(pdev, barno);
-
 	if (barno == test->test_reg_bar)
 		bar_size = 0x4;
 
-- 
2.39.5



