Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51D834F483;
	Mon,  4 May 2026 14:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903247; cv=none; b=VhhSsBJBiB2W5xL+GnR0bK+cIXhbaD2NXCG0qnFW3Yjd13iCn5PqW4m7xx5YayV1jkr6B1L7l++10jNKYz1ROPIh40MjdiWRxwQanXqzrkntpK1GxKp9ruKyJqLXbc4u/N1jboODI8cRgC75Ci5Tmr52j2W+kappcfFDAmki9us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903247; c=relaxed/simple;
	bh=OEykEuped0KiV3nuy18/f5/Vz/feu27KRlB4L9NO/8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTNnusOafWS6OFaaoFu5b57Ld5GHOKyWlt937t4wrf1epwxQcwt7b4cXmPNr/aalHaIIyZkPvLuh8IoUF9Mf+ukG3nNTy4sImWdSyC+l26jcTG4ItVQ9wa4DNzvaQHsSASVfXoA/gJPWk38tkXAfRsWcOWgbtMpghuwHYgMN0i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=De97IWsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="De97IWsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4E8C2BCB8;
	Mon,  4 May 2026 14:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903247;
	bh=OEykEuped0KiV3nuy18/f5/Vz/feu27KRlB4L9NO/8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=De97IWsgnm6oiwXzy46E/DIFJFDaI73eQbAYRAPQW9kMY94Z2UEQptfZ7yZ01u+7k
	 Mx4h+S/BEmIIzt91f/WM9o0OKtxQmZElIdDC2pz4tfp18QiNkB4V2R0JXloJo0G2mK
	 uOrgzCiTRHpB0T+4JjlLD9bEAYoFqtutVodcwXkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.0 160/307] LoongArch: Make arch_irq_work_has_interrupt() true only if IPI HW exist
Date: Mon,  4 May 2026 15:50:45 +0200
Message-ID: <20260504135148.860764512@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 02a6a1f9d77a816fbac01de9bfcd0e0914552f2f upstream.

After commit 7c405fb3279b3924 ("rcu: Use an intermediate irq_work to
start process_srcu()"), Loongson-2K0300/2K0500 fail to boot. Because
IRQ_WORK need IPI but Loongson-2K0300/2K0500 don't have IPI HW.

So make arch_irq_work_has_interrupt() return true only if IPI HW exist.

Cc: stable@vger.kernel.org
Reported-by: Binbin Zhou <zhoubinbin@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/irq_work.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/irq_work.h
+++ b/arch/loongarch/include/asm/irq_work.h
@@ -4,7 +4,7 @@
 
 static inline bool arch_irq_work_has_interrupt(void)
 {
-	return IS_ENABLED(CONFIG_SMP);
+	return IS_ENABLED(CONFIG_SMP) && cpu_opt(LOONGARCH_CPU_CSRIPI);
 }
 
 #endif /* _ASM_LOONGARCH_IRQ_WORK_H */


