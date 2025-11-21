Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1CE1F09B3;
	Fri, 21 Nov 2025 13:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731953; cv=none; b=G+cshJXJOa7wjtyFpM6CCHvrgpX46vqm9Ts9pXOgNp1bCw7Rn4SYo16tn1aFiZyOkOI7Pk5ZslSUdt+AUM5mgOOyx1riGAIZaGv9rdsbrJv5702QJ0Sr5vtgjjqxh7mnEhq0A+YOXC4sFrCJpCQzQhPSqWyXYFG3rar8cGPyCHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731953; c=relaxed/simple;
	bh=k4RLjh2J8JbMGmhA80DHfQZ06AqT+BIkhcy2LJbB6I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHRLOdci+FsqSWV7ss3gaVKfqbtpX2yiKAcwNnmb7FdEfv08ngR1KypQclD5dKVv9GNa1gowpELfRYZ/L908mocV/cIj5M3Gxg4o3HAcnR+F2S3B7MRt0MaaUSk0fQ+RyYYe5FnGqIUH1kfP9kyInMtL+Ox51oBwAmGZyukZBVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fi8PO4yN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fi8PO4yN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E72C4CEF1;
	Fri, 21 Nov 2025 13:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731953;
	bh=k4RLjh2J8JbMGmhA80DHfQZ06AqT+BIkhcy2LJbB6I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fi8PO4yNhEvDmi9zkKOMLgykEzfkDvM1ajCjhuex4PqWezUyHXXZIBcvRMlI5uFXS
	 2AZRm1x2Kskv92j3wc4YYpENc5/KXyrsjv4Mvk8d5+eHwUvfMU1eppJEoo1jk/aA51
	 DOk0B6Vii6YcXNTUFQvslxOMc5RJJ1UZF5h/RMFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 139/185] LoongArch: Use physical addresses for CSR_MERRENTRY/CSR_TLBRENTRY
Date: Fri, 21 Nov 2025 14:12:46 +0100
Message-ID: <20251121130148.891221755@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 4e67526840fc55917581b90f6a4b65849a616dd8 upstream.

Now we use virtual addresses to fill CSR_MERRENTRY/CSR_TLBRENTRY, but
hardware hope physical addresses. Now it works well because the high
bits are ignored above PA_BITS (48 bits), but explicitly use physical
addresses can avoid potential bugs. So fix it.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/traps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kernel/traps.c
+++ b/arch/loongarch/kernel/traps.c
@@ -1123,8 +1123,8 @@ static void configure_exception_vector(v
 	tlbrentry = (unsigned long)exception_handlers + 80*VECSIZE;
 
 	csr_write64(eentry, LOONGARCH_CSR_EENTRY);
-	csr_write64(eentry, LOONGARCH_CSR_MERRENTRY);
-	csr_write64(tlbrentry, LOONGARCH_CSR_TLBRENTRY);
+	csr_write64(__pa(eentry), LOONGARCH_CSR_MERRENTRY);
+	csr_write64(__pa(tlbrentry), LOONGARCH_CSR_TLBRENTRY);
 }
 
 void per_cpu_trap_init(int cpu)


