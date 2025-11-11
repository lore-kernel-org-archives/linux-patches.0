Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35845306B30;
	Tue, 11 Nov 2025 01:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823883; cv=none; b=ORdTx33ci2gIfbfmAJ1tpjAL6Sg8WJJFqrltxXavzOYX6Q63SBKWU+TEQ5fi74z4K+J1QgpDLKrzpj2mNA3Z20rUEF+Ff1DNO0K6BzsOKtIp7b4kZ9yCpZR39Lxqtwv35OPyY52CotCXlES/LwsSXhr+ckWZ1pr9yZztDZyR0Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823883; c=relaxed/simple;
	bh=LlFPC/wAuQSERExvcY4ka+GCg969bTefk+94EYe+amc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbhMQLdShtqOmjZIgcyUDSLMJjwv2Skb2+MkmDA6g5LxCPDCE21pY5N7L+Z1EigMphwI4AWPWeGejfUraoh9pOVZ+HiHisXU3g2kVZ11MIFcgY7k+88Af3eUWJCtpWf8Dv/QOXCW4YCXeI4fGcQOl/b0+Y2jbv0fbU0QEB7Z+W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+m6nUiW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+m6nUiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A74C116D0;
	Tue, 11 Nov 2025 01:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823883;
	bh=LlFPC/wAuQSERExvcY4ka+GCg969bTefk+94EYe+amc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+m6nUiWk3s6NmWvu3E8Twt99zRXUeGDJummv993j2l580wzCK1cKw9sQQL5kPdih
	 7n+VEHD4vpDA0zR1SyT9TonnMIHHC44bTD/VTGBZJCnm5FOQzcaBeG/EYIEc1elZig
	 +eO7zii9K6c/gYb5vMoRe+tBw6baRVUfVuSsqBJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Bruel <christian.bruel@foss.st.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 368/849] selftests: pci_endpoint: Skip IRQ test if IRQ is out of range.
Date: Tue, 11 Nov 2025 09:38:58 +0900
Message-ID: <20251111004545.320418710@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Christian Bruel <christian.bruel@foss.st.com>

[ Upstream commit 106fc08b30a2ece49a251b053165a83d41d50fd0 ]

The pci_endpoint_test tests the entire MSI/MSI-X range, which generates
false errors on platforms that do not support the whole range.

Skip the test in such cases and report accordingly.

Signed-off-by: Christian Bruel <christian.bruel@foss.st.com>
[mani: reworded description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20250804170916.3212221-4-christian.bruel@foss.st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/pci_endpoint/pci_endpoint_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/pci_endpoint/pci_endpoint_test.c b/tools/testing/selftests/pci_endpoint/pci_endpoint_test.c
index da0db0e7c9693..cd9075444c32a 100644
--- a/tools/testing/selftests/pci_endpoint/pci_endpoint_test.c
+++ b/tools/testing/selftests/pci_endpoint/pci_endpoint_test.c
@@ -121,6 +121,8 @@ TEST_F(pci_ep_basic, MSI_TEST)
 
 	for (i = 1; i <= 32; i++) {
 		pci_ep_ioctl(PCITEST_MSI, i);
+		if (ret == -EINVAL)
+			SKIP(return, "MSI%d is disabled", i);
 		EXPECT_FALSE(ret) TH_LOG("Test failed for MSI%d", i);
 	}
 }
@@ -137,6 +139,8 @@ TEST_F(pci_ep_basic, MSIX_TEST)
 
 	for (i = 1; i <= 2048; i++) {
 		pci_ep_ioctl(PCITEST_MSIX, i);
+		if (ret == -EINVAL)
+			SKIP(return, "MSI-X%d is disabled", i);
 		EXPECT_FALSE(ret) TH_LOG("Test failed for MSI-X%d", i);
 	}
 }
-- 
2.51.0



