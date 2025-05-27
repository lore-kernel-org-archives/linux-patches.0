Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D681A27F4CB;
	Tue, 27 May 2025 16:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364911; cv=none; b=J+hFmyGc4K3K3FAUa/mPASynBZErEp4z3Kv/l7mJqYAoRS0bSJoMmBEMwrFnupy36yI3W4UvXhto++1hw4m8GQ3PqQi2Evf/V5tz/0RiO3HsuAjL5DgHNzWFSr4q/FZSv//b/bhqzkUdkfAw7DHA4Y8VqPHH0p6b8AwJfbjdBiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364911; c=relaxed/simple;
	bh=XdveT+lXC9rTJb727HrEoqvUPQPbx3zwmiMnrLY6Yv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BoUCcxPuvxQ/3/++Lt77YLvg5G1XtiZZJ/ZiX9djtTruDfVXwGtk9F18WxczQ97kEz1Afh9Jj5qk+OcEGpm9HOkpX6RRq6fbvcUyoAUwigX0r+mi+/PlJPgateG1edyucUJLpSUvtfh2OBYJRBRsC+q6mZcXqxkTkDqTfluPFXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8fqe9Z4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8fqe9Z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C2DC4CEE9;
	Tue, 27 May 2025 16:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364911;
	bh=XdveT+lXC9rTJb727HrEoqvUPQPbx3zwmiMnrLY6Yv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8fqe9Z4tnZriCt9JyjlJMRUirY2wfZQ5O8eOczN63Nh3LHFwunthXO+eSIvqTubm
	 47JGwUmH4CHllC0kHrkmYsvsVZ/fdTzeHNIEuUx05pt/x++E7j7LZ/7py4/mV+7eyL
	 REldQUylXbY+jdzRCcdJ0Lp9rnlk491+vQVnsh68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Christian Bruel <christian.bruel@foss.st.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/626] PCI: endpoint: pci-epf-test: Fix double free that causes kernel to oops
Date: Tue, 27 May 2025 18:21:38 +0200
Message-ID: <20250527162453.349913243@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Bruel <christian.bruel@foss.st.com>

[ Upstream commit 934e9d137d937706004c325fa1474f9e3f1ba10a ]

Fix a kernel oops found while testing the stm32_pcie Endpoint driver
with handling of PERST# deassertion:

During EP initialization, pci_epf_test_alloc_space() allocates all BARs,
which are further freed if epc_set_bar() fails (for instance, due to no
free inbound window).

However, when pci_epc_set_bar() fails, the error path:

  pci_epc_set_bar() ->
    pci_epf_free_space()

does not clear the previous assignment to epf_test->reg[bar].

Then, if the host reboots, the PERST# deassertion restarts the BAR
allocation sequence with the same allocation failure (no free inbound
window), creating a double free situation since epf_test->reg[bar] was
deallocated and is still non-NULL.

Thus, make sure that pci_epf_alloc_space() and pci_epf_free_space()
invocations are symmetric, and as such, set epf_test->reg[bar] to NULL
when memory is freed.

Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Christian Bruel <christian.bruel@foss.st.com>
Link: https://lore.kernel.org/r/20250124123043.96112-1-christian.bruel@foss.st.com
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index 14b4c68ab4e1a..21aa3709e2577 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -703,6 +703,7 @@ static int pci_epf_test_set_bar(struct pci_epf *epf)
 		if (ret) {
 			pci_epf_free_space(epf, epf_test->reg[bar], bar,
 					   PRIMARY_INTERFACE);
+			epf_test->reg[bar] = NULL;
 			dev_err(dev, "Failed to set BAR%d\n", bar);
 			if (bar == test_reg_bar)
 				return ret;
@@ -878,6 +879,7 @@ static void pci_epf_test_free_space(struct pci_epf *epf)
 
 		pci_epf_free_space(epf, epf_test->reg[bar], bar,
 				   PRIMARY_INTERFACE);
+		epf_test->reg[bar] = NULL;
 	}
 }
 
-- 
2.39.5



