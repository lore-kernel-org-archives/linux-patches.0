Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD26126F2B6;
	Mon, 13 Oct 2025 15:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369503; cv=none; b=hifx/VWBj9+Vi7iBk1rAdRKvqK4KwdJWorrv9fSF6DO9V8RO4PC37CtSgeTuXJVOudtuXsGJHuYczHQ15Mmx42LN5cpDuE5+YJDtvBzGOAuVJRY7sHaM1z4K/R2lGZ1q3TRup94pL2CGAsaTXa1B+AsUxWUqjg5/y7ttvWiy1mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369503; c=relaxed/simple;
	bh=QPuFdKpe778zl5BOZdDH9jIkecAbO+qtOaloNDG7HzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XECv6z8x/nkJw4CNgr5qvB/nDjbTLo290yTQdZoC8cuPyiiP31qOyDETk7EI/8mwNOg5nAE1QFWnRqV8hrtIFVLBDa2yUQ0IqLIA2NBclrA50ehFfI0rjkzF2YiEz0wLdFHJEyqZfsYWCEcLVp9WwL10Ul/8GxL73ND13HAXaHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RX073LmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RX073LmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3944DC4CEE7;
	Mon, 13 Oct 2025 15:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369503;
	bh=QPuFdKpe778zl5BOZdDH9jIkecAbO+qtOaloNDG7HzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RX073LmVfVNAnfhujt1i0nq0BND2IphnfdCfD7MVcHvNvxg0kgv8NNgMEQ1RS6oGA
	 ptEwztFezM260IyANeeVG6iCZWnO20Yh6zbzxl9M54D12QQ7npp4KfCL7GTl5dKciY
	 8jovTDrC3ylPzJLvvvqV+EH6j2PYb59z2ri9QeBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 237/563] misc: pci_endpoint_test: Fix array underflow in pci_endpoint_test_ioctl()
Date: Mon, 13 Oct 2025 16:41:38 +0200
Message-ID: <20251013144419.872898914@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 1ad82f9db13d85667366044acdfb02009d576c5a ]

Commit eefb83790a0d ("misc: pci_endpoint_test: Add doorbell test case")
added NO_BAR (-1) to the pci_barno enum which, in practical terms,
changes the enum from an unsigned int to a signed int.  If the user
passes a negative number in pci_endpoint_test_ioctl() then it results in
an array underflow in pci_endpoint_test_bar().

Fixes: eefb83790a0d ("misc: pci_endpoint_test: Add doorbell test case")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/aIzzZ4vc6ZrmM9rI@suswa
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pci_endpoint_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 1c156a3f845e1..f935175d8bf55 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -937,7 +937,7 @@ static long pci_endpoint_test_ioctl(struct file *file, unsigned int cmd,
 	switch (cmd) {
 	case PCITEST_BAR:
 		bar = arg;
-		if (bar > BAR_5)
+		if (bar <= NO_BAR || bar > BAR_5)
 			goto ret;
 		if (is_am654_pci_dev(pdev) && bar == BAR_0)
 			goto ret;
-- 
2.51.0



