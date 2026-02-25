Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DA6243376;
	Wed, 25 Feb 2026 01:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983638; cv=none; b=IYPgoi/7zqr5dCpUPOpNEnK21wiPcKD6qJeHNDtSKPpzDo1Wph6XpIrtFwens/paewor1szf/NXD2M2egaed4AXz+K8+k5Nn6y6H6ci6mZwu6yWJuFr+jWXsuw2fjGmPVkSQm37FMXkA0e+9JQLfhoy8KB8VJfts1qEBrWOXT8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983638; c=relaxed/simple;
	bh=wHNcfAXhMFRn/J6a5//eeDv4UfKL9qHvwG81aC0DzHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSME9IqApwNPLW9kqOjV3aUtTutkdBYMikYRVupUgsezDQbZWARxTQXx+YAtlYxILEuhqDfu5Exc4KVZXdjV3jBCqn0o6M23l4F9mXWtj1kxFP0Tuz2X6WxgSk7YXB4eAmpIC5/Oz8gi7r5IxGaMpGcmwvHmpJwAONMnH+vuXXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAcSueXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAcSueXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66849C116D0;
	Wed, 25 Feb 2026 01:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983637;
	bh=wHNcfAXhMFRn/J6a5//eeDv4UfKL9qHvwG81aC0DzHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAcSueXU7EdfksYNqntAIeYJE86kNiOjrXuVya3V08mPvZLEyewpQZYV2zX5Tz5Oq
	 LOLqcO8360j+ZMWnONcIk4lICGtzvgXfHTy2qFkFze9qF8JUMs8xIrHRhAubOAbVFs
	 QLticck9IjRG3qUoNNHq+ky36N9IYljHM+GGLImM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 726/781] s390/kexec: Make KEXEC_SIG available when CONFIG_MODULES=n
Date: Tue, 24 Feb 2026 17:23:55 -0800
Message-ID: <20260225012417.542555360@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Egorenkov <egorenar@linux.ibm.com>

[ Upstream commit dd3411959b57df6e05a3ccbac67b0a836871c0c4 ]

The commit c8424e776b09 ("MODSIGN: Export module signature definitions")
replaced the dependency of KEXEC_SIG on SYSTEM_DATA_VERIFICATION with the
dependency on MODULE_SIG_FORMAT. This change disables KEXEC_SIG in s390
kernels built with MODULES=n if nothing else selects MODULE_SIG_FORMAT.

Furthermore, the signature verification in s390 kexec does not require
MODULE_SIG_FORMAT because it requires only the struct module_signature and,
therefore, does not depend on code in kernel/module_signature.c.

But making ARCH_SUPPORTS_KEXEC_SIG depend on SYSTEM_DATA_VERIFICATION is
also incorrect because it makes KEXEC_SIG available on s390 only if some
other arbitrary option (for instance a file system or device driver)
selects it directly or indirectly.

To properly make KEXEC_SIG available for s390 kernels built with MODULES=y
as well as MODULES=n _and_ also not depend on arbitrary options selecting
SYSTEM_DATA_VERIFICATION, set ARCH_SUPPORTS_KEXEC_SIG=y for s390 and select
SYSTEM_DATA_VERIFICATION when KEXEC_SIG=y.

Fixes: c8424e776b09 ("MODSIGN: Export module signature definitions")
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 0e5fad5f06ca1..783be50f38f2b 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -275,6 +275,7 @@ config S390
 	select SPARSE_IRQ
 	select SWIOTLB
 	select SYSCTL_EXCEPTION_TRACE
+	select SYSTEM_DATA_VERIFICATION if KEXEC_SIG
 	select THREAD_INFO_IN_TASK
 	select TRACE_IRQFLAGS_SUPPORT
 	select TTY
@@ -301,7 +302,7 @@ config ARCH_SUPPORTS_KEXEC_FILE
 	def_bool y
 
 config ARCH_SUPPORTS_KEXEC_SIG
-	def_bool MODULE_SIG_FORMAT
+	def_bool y
 
 config ARCH_SUPPORTS_KEXEC_PURGATORY
 	def_bool y
-- 
2.51.0



