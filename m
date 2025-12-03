Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D6030C37A;
	Wed,  3 Dec 2025 15:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776517; cv=none; b=f8vuGmWtZbRHAJR65xvGEnyAHeeNCQ3QGR7KtUP9/JWL/WRE720+kOKkE6P6v4V8Q5HPgGXxULX5uMp8c49sdTpbCD3yYCOyV7q2zG16NMkBcgPLijnSjnZBRlnVOU8oJi64RQZ5ZERNiDVjySIEwCAT+dFkABoK2BEn1cjcFAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776517; c=relaxed/simple;
	bh=lMYUb+pAEOiU1Ia76nqpvaKw6ei6BjKxQuMD5c3Xbzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pnz0vJHhLAxHM8RtOKRWe9PMhW7OUxpnX0P+jyaCQPJSdq4Gu+nhKImo/aa9YEu1VAxieg39MTFflcEbCG5F0YwA0brYbUXxFqiNdRVC3PRy41v6EkETr/FUgGZnekFzOFprEZDz4IJb7ajGnpWzSM4urY9BrooojVf42twjd3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znhMvGtw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znhMvGtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3144C116B1;
	Wed,  3 Dec 2025 15:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776517;
	bh=lMYUb+pAEOiU1Ia76nqpvaKw6ei6BjKxQuMD5c3Xbzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=znhMvGtwLb9OKoFQtFMlnm/9q1rc0cFZ33JVTe1XNlGIPYyuPY78aquThBAyzGqDu
	 RaHiJ2KYQWq7qickjSXRmdR5wJb8ilQftUjXDDy6/xs50+mKKGm6FMPlc0BIHgAz39
	 jj4jCxY5rEvnh5vnX9YmU9S9+9jxTdxtFOw1KLiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>,
	Andrew Jones <ajones@ventanamicro.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/300] RISC-V: clear hot-unplugged cores from all task mm_cpumasks to avoid rfence errors
Date: Wed,  3 Dec 2025 16:26:18 +0100
Message-ID: <20251203152407.072293592@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>

[ Upstream commit ae9e9f3d67dcef7582a4524047b01e33c5185ddb ]

openSBI v1.7 adds harts checks for ipi operations. Especially it
adds comparison between hmask passed as an argument from linux
and mask of online harts (from openSBI side). If they don't
fit each other the error occurs.

When cpu is offline, cpu_online_mask is explicitly cleared in
__cpu_disable. However, there is no explicit clearing of
mm_cpumask. mm_cpumask is used for rfence operations that
call openSBI RFENCE extension which uses ipi to remote harts.
If hart is offline there may be error if mask of linux is not
as mask of online harts in openSBI.

this patch adds explicit clearing of mm_cpumask for offline hart.

Signed-off-by: Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20250919132849.31676-1-danil.skrebenkov@cloudbear.ru
[pjw@kernel.org: rewrote subject line for clarity]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpu-hotplug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/cpu-hotplug.c b/arch/riscv/kernel/cpu-hotplug.c
index 0e948e87bd813..6cd16a2af2ee0 100644
--- a/arch/riscv/kernel/cpu-hotplug.c
+++ b/arch/riscv/kernel/cpu-hotplug.c
@@ -65,6 +65,7 @@ void __cpu_die(unsigned int cpu)
 	}
 	pr_notice("CPU%u: off\n", cpu);
 
+	clear_tasks_mm_cpumask(cpu);
 	/* Verify from the firmware if the cpu is really stopped*/
 	if (cpu_ops[cpu]->cpu_is_stopped)
 		ret = cpu_ops[cpu]->cpu_is_stopped(cpu);
-- 
2.51.0



