Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F63A156861;
	Mon, 10 Mar 2025 18:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630897; cv=none; b=Jepbi797gjHVNA+OvabykX7zstJS0EQhkbUsKjF3EN0TP1fsetpoNXD4J71QPdk6NkCoHLJnj3OeRZ3IqwfbXiS+oqQ2xaHeapMLbJuMVglvY27n4QsNz6Z5EiwNJCKjA1uKJ6TvhUhL3N9cqM0lvmdHDBrCGeck5hh/nkbWH9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630897; c=relaxed/simple;
	bh=qjV47PCCBSJvXmFd1K+M2Ctx/6w3O/YdD34M/Ipi3BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmzK65iAtc13HqGu5sbMUBl5YY4gdW4NnqfHEJT/Bz2JAtTredCUncJy47i2AkEC3KGSy+ykPwY4FzQLPjq0JdpBnbkCUT0O0I6qXnALjujfNK5RLrgdeIQZHBh86fnH2g68NqUC/NiqU/Kz+jdlWi7Trt8wwBci31sF7xf5B/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Unmhurd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Unmhurd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC301C4CEE5;
	Mon, 10 Mar 2025 18:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630897;
	bh=qjV47PCCBSJvXmFd1K+M2Ctx/6w3O/YdD34M/Ipi3BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Unmhurd7RON4lvxeW9DkjB6ZTWSXkWzHN8TXpHgbEJACS60HaiLCqGSG+FEObS0Oo
	 hf0p6w7YKOlnf73Y3sd3qVyD0jvEWk/iScuSmFlhch3zP99IBSGDGcrheq34NqS2zi
	 UraXTPHDg7/oYuMVq6LFf/TkuM9mONkeL8mheV8A=
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
Subject: [PATCH 5.15 573/620] x86/sgx: Fix size overflows in sgx_encl_create()
Date: Mon, 10 Mar 2025 18:06:59 +0100
Message-ID: <20250310170608.158030551@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4de31b0b0dd5d..14ee6d2180034 100644
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



