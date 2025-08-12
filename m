Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218DE2FDC53;
	Tue, 12 Aug 2025 18:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025001; cv=none; b=JmWTG6HMbBXxdzS81nsauIFSV63mgG+zRPWYo+x5koAxguVitAJZAepKlUizDEVGB8ofAQfi4F622R6xgP3QR/KeXwKxISxJIwhYaTnnRUHZeAX9PKpKqQ7wBZY+vAcS607F8l8A4qp7lrovo0QjNCExzBsuvlQ3mPUW7b47i5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025001; c=relaxed/simple;
	bh=v/QcgZGpqTG6wcnZCX5Vor2ldRU8QbwkkGouMUUqKuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ow6DehzFdW+QqkbUmURaAokbbkJ9U5bHZw/PS+UJD76g6GKlfmYdyxM9q7SXOWbvCqfp1Eq5o+KS8WH0857027u3u1pU9wPTQ4J6epW2vScds6+pmPWuF2+JtkV3Dxh057SKewYW+y/nZAKIDgmG4OFSMake03gWoAtApBIl8HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSyYUysx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSyYUysx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BE3C4CEF0;
	Tue, 12 Aug 2025 18:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025001;
	bh=v/QcgZGpqTG6wcnZCX5Vor2ldRU8QbwkkGouMUUqKuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSyYUysxFOa/Lv95LGU4U9j3DZys2Y7Bqrg6pnFFIhILpcoQaKPtc6GNIaFP7i550
	 vd7e40UtU2ZMqv5dciOembtyw/BdHX8K+eITYaWpgf+9kJkXaHmJ9wamgun6VLVYbE
	 STYQ5m7hxtCvUog61U7m567xc61maIB7NzGdan8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 541/627] ipa: fix compile-testing with qcom-mdt=m
Date: Tue, 12 Aug 2025 19:33:56 +0200
Message-ID: <20250812173452.487251904@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2df158047d532d0e2a6b39953656c738872151a3 ]

There are multiple drivers that use the qualcomm mdt loader, but they
have conflicting ideas of how to deal with that dependency when compile-testing
for non-qualcomm targets:

IPA only enables the MDT loader when the kernel config includes ARCH_QCOM,
but the newly added ath12k support always enables it, which leads to a
link failure with the combination of IPA=y and ATH12K=m:

    aarch64-linux-ld: drivers/net/ipa/ipa_main.o: in function `ipa_firmware_load':
    ipa_main.c:(.text.unlikely+0x134): undefined reference to `qcom_mdt_load

The ATH12K method seems more reliable here, so change IPA over to do the same
thing.

Fixes: 38a4066f593c ("net: ipa: support COMPILE_TEST")
Fixes: c0dd3f4f7091 ("wifi: ath12k: enable ath12k AHB support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20250731080024.2054904-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
index 6782c2cbf542..01d219d3760c 100644
--- a/drivers/net/ipa/Kconfig
+++ b/drivers/net/ipa/Kconfig
@@ -5,7 +5,7 @@ config QCOM_IPA
 	depends on INTERCONNECT
 	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
 	depends on QCOM_AOSS_QMP || QCOM_AOSS_QMP=n
-	select QCOM_MDT_LOADER if ARCH_QCOM
+	select QCOM_MDT_LOADER
 	select QCOM_SCM
 	select QCOM_QMI_HELPERS
 	help
-- 
2.39.5



