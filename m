Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474DE22D799;
	Mon, 10 Mar 2025 17:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627622; cv=none; b=hSzDBd9rLQPnkwVWr4IFYC5LsFqBUFlXYa5B3FbaFSAXPY0oZPurS6YbDcbx37NnwEsz23zTHMnyt0VB8G/svmd/EVkz+WunN2SM/Cfhdco7GNCWM7rt0Dd+1hETyPGbPPcMSubH5lJqYtt59uQzuK4F1nkuFKzw8IfZ/5T2rLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627622; c=relaxed/simple;
	bh=GleDRNYeDaLVGuziNvRZdjhNz5PA5WizY6Uo29aGvcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAXwHDyRkoOgSUj7e6vos41wpTzR7vq4LW14M9/DQv3DH5WDTnmZo1PLgXKng1hG0+yJUlPWPsHTFX/Uh1Vb6BgBfhPUonhnMM9XRm+WMMkHhab+B3qDJDy6BGolEXcperVtgdxEiI54JXrF+aoJw29VeoPRtkgZvBA1P1D4mxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soB5KMh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soB5KMh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDF9C4CEE5;
	Mon, 10 Mar 2025 17:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627622;
	bh=GleDRNYeDaLVGuziNvRZdjhNz5PA5WizY6Uo29aGvcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soB5KMh6kOgCW0gOSho+FN9da97kqJcwrDUdEuIP5o/JmhiNdHLM/zNuAFEPwuOab
	 2HsjqLn7iGr2r22yCnDnCvlxp8OiTIoLYnakXMkDNU5IKU0bJySzqBBQ3oz7PZcbdt
	 SdgLLGYq1uHqTOQxPFis9iNUu844jyGZYDrnP3ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 193/269] x86/sgx: Fix size overflows in sgx_encl_create()
Date: Mon, 10 Mar 2025 18:05:46 +0100
Message-ID: <20250310170505.394590077@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

[ Upstream commit 0d3e0dfd68fb9e6b0ec865be9f3377cc3ff55733 ]

The total size calculated for EPC can overflow u64 given the added up page
for SECS.  Further, the total size calculated for shmem can overflow even
when the EPC size stays within limits of u64, given that it adds the extra
space for 128 byte PCMD structures (one for each page).

Address this by pre-evaluating the micro-architectural requirement of
SGX: the address space size must be power of two. This is eventually
checked up by ECREATE but the pre-check has the additional benefit of
making sure that there is some space for additional data.

Fixes: 888d24911787 ("x86/sgx: Add SGX_IOC_ENCLAVE_CREATE")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: https://lore.kernel.org/r/20250305050006.43896-1-jarkko@kernel.org

Closes: https://lore.kernel.org/linux-sgx/c87e01a0-e7dd-4749-a348-0980d3444f04@stanley.mountain/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index b65ab214bdf57..776a20172867e 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -64,6 +64,13 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	struct file *backing;
 	long ret;
 
+	/*
+	 * ECREATE would detect this too, but checking here also ensures
+	 * that the 'encl_size' calculations below can never overflow.
+	 */
+	if (!is_power_of_2(secs->size))
+		return -EINVAL;
+
 	va_page = sgx_encl_grow(encl, true);
 	if (IS_ERR(va_page))
 		return PTR_ERR(va_page);
-- 
2.39.5



