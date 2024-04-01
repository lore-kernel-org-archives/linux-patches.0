Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512E74AECF;
	Mon,  1 Apr 2024 16:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989392; cv=none; b=h1Gn+uuHNYBCV0vmq7XsQ5xDR2K+dwdyhft+AqTccDh1JvsFwPWCApdKleOQr3c4KShdwKzF3vVkiKhB21/1lWjeGFh+p4/89smhDM4/A07fHLdoOfw3+M84y4tbSUYqq3Ua4Elh4sRX51elMFXYpPfJ2Gn9IfIGgy1ftUYiGTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989392; c=relaxed/simple;
	bh=qJMwMb3BkSKfiCXlXLPxHYMbkJ/jbFPENCbFBNuIIww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kekdKwaQ/8Ve3BK2fIUWZ44FzzFhRUzhnt3fz9IQjQw5r8yPL5h6HrqzlLeQKTd/T+hM3OOpjJpvSyo1mumo82G/2oHj4nTua7czMDLfvwQZGPuxsxHB9X6iUqcbahhuob3cWQJ+i+D/ldeXDqVpftqds0e8rpR4LCVGQgPTo6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrdLqGEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrdLqGEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB0DC433A6;
	Mon,  1 Apr 2024 16:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989391;
	bh=qJMwMb3BkSKfiCXlXLPxHYMbkJ/jbFPENCbFBNuIIww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrdLqGEj7O1tmpOwWfcwUjhxV6s6pDFfNs7qKo3vYMgyuMtBUAJQ50TJuXjBRSO17
	 Tgj8+wClFDwvZW8T9Xtni/KEDotG9qH4HcGCg6CH1hY3VZULvljSkBMk+g9zWHs72M
	 XuLdlsmVCiOTLqSg6bvNVZqwArDyQqsH12qlR1Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/396] powerpc/smp: Adjust nr_cpu_ids to cover all threads of a core
Date: Mon,  1 Apr 2024 17:41:24 +0200
Message-ID: <20240401152548.975106803@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 5580e96dad5a439d561d9648ffcbccb739c2a120 ]

If nr_cpu_ids is too low to include at least all the threads of a single
core adjust nr_cpu_ids upwards. This avoids triggering odd bugs in code
that assumes all threads of a core are available.

Cc: stable@vger.kernel.org
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231229120107.2281153-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/prom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 0b5878c3125b1..58e80076bed5c 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -375,6 +375,12 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 	if (IS_ENABLED(CONFIG_PPC64))
 		boot_cpu_hwid = be32_to_cpu(intserv[found_thread]);
 
+	if (nr_cpu_ids % nthreads != 0) {
+		set_nr_cpu_ids(ALIGN(nr_cpu_ids, nthreads));
+		pr_warn("nr_cpu_ids was not a multiple of threads_per_core, adjusted to %d\n",
+			nr_cpu_ids);
+	}
+
 	/*
 	 * PAPR defines "logical" PVR values for cpus that
 	 * meet various levels of the architecture:
-- 
2.43.0



