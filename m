Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877DB31283B;
	Wed,  3 Dec 2025 16:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779941; cv=none; b=ID0VlKW9u6Gpss+/ebcBfqrj6Jyc5lXvnjPqMA/DTZDBA+dIJNJrIlgrGYdA17x04uTGTVWIZfDBq/iEow2rtQ6bRStZX1ot/NuES1/6T/5eyoamn+q8FruKDziQ/yub6KSj5iuxBCY/cJ0qPsBwiXOuTZ3OrWG2QptqXfJcHeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779941; c=relaxed/simple;
	bh=VKvky0QXEFXoH3iSMFISqDJ4CIiUhoypMkCV4JF3kOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwGDAcag6X5I4NehJfOtwUlA3xphRdidqcCUf87/o5qDP51RXxXwjgknWI8IR9IdhVOk8n2KyovS5s6zscJVFRY6WojZK4bS1t2OGrAWi7QojNpeoiZnfDJQGkmnJ2iZglvBLLKvYRJmNq4qp5gBdpKcTKMwlaMfbczSKqQr56w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8xzuDvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8xzuDvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB151C4CEF5;
	Wed,  3 Dec 2025 16:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779941;
	bh=VKvky0QXEFXoH3iSMFISqDJ4CIiUhoypMkCV4JF3kOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8xzuDvk7a2TmgDhaoPok7v7dzYuz8UEa9rOY36wHGBRB89wOvO6l4tm5pys9V8EH
	 t8Dsr6OtyLtEz9ywleXmwZjSRz54FgoA27MAemHfICaxDl13v4LraWrZyVW4yPkOE0
	 b1/Y4uql2ECq4UuHUnmq6dwO2fiwdXwvsBd9lQeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 408/568] LoongArch: Use physical addresses for CSR_MERRENTRY/CSR_TLBRENTRY
Date: Wed,  3 Dec 2025 16:26:50 +0100
Message-ID: <20251203152455.630263456@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -657,8 +657,8 @@ static void configure_exception_vector(v
 	tlbrentry = (unsigned long)exception_handlers + 80*VECSIZE;
 
 	csr_write64(eentry, LOONGARCH_CSR_EENTRY);
-	csr_write64(eentry, LOONGARCH_CSR_MERRENTRY);
-	csr_write64(tlbrentry, LOONGARCH_CSR_TLBRENTRY);
+	csr_write64(__pa(eentry), LOONGARCH_CSR_MERRENTRY);
+	csr_write64(__pa(tlbrentry), LOONGARCH_CSR_TLBRENTRY);
 }
 
 void per_cpu_trap_init(int cpu)


