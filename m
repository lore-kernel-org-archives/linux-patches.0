Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF98523E356;
	Tue, 12 May 2026 18:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608858; cv=none; b=uR2NLSgPO2TTH2TX6JrvW1SmF43v9kJl7q0KOGa0dBE6lQClOjP0tY4HK+czdlQmfchAf/Jj3Jdx7dDr60SfA4DtUsno6Pl/WZGfBXp4vS19nlkzTFAEu6zqGKXq3900txUXkiOJuApXl3G5Stv2yiFXGuEFaYbs1QYbZ4G8nHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608858; c=relaxed/simple;
	bh=EMqy3pRgW9LihjMV+D9LxUTYCUrtciJ5VQ+j7miLij4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3SfAXBl373eia2vY+/pwgn+3+IS5cLDSa01T/ZFKItKIiwWRA9c91MRjD26UtqcbDx86GOmfoIjLQnOq5lm6RKKL3oIgDsUW5Pkhf08PYbUJJXEwotxXFueauFVLM7RWNx8OKjYfDMcyKe8ERkiIVlLp1Bg/7jvtrBkWjYuEQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17O3zTju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17O3zTju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2420AC2BCB0;
	Tue, 12 May 2026 18:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608858;
	bh=EMqy3pRgW9LihjMV+D9LxUTYCUrtciJ5VQ+j7miLij4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17O3zTju6/iY0bOFgntEmmmof0drJr2K24s8PolpM+jc3z0ZXmTRsemkDbzGFAZ33
	 oqy6Wn+j0bk97i4a0J7pywkdYHqu9vDZQSPFL1cbGb/RMVVkOTSsm//TxSWdT0UtPV
	 ppP6Xv3Hh0spzD0sjYt98x50SCgz/fTABpbrfveo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianglai Li <lixianglai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 241/270] LoongArch: KVM: Fix "unreliable stack" for kvm_exc_entry
Date: Tue, 12 May 2026 19:40:42 +0200
Message-ID: <20260512173943.513920293@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xianglai Li <lixianglai@loongson.cn>

commit b323a441da602dfdfc24f30d3190cac786ffebf2 upstream.

Insert the appropriate UNWIND hint into the kvm_exc_entry assembly
function to guide the generation of correct ORC table entries, thereby
solving the timeout problem ("unreliable stack") while loading the
livepatch-sample module on a physical machine running virtual machines
with multiple vcpus.

Cc: stable@vger.kernel.org
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/switch.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -111,7 +111,7 @@
 	.p2align PAGE_SHIFT
 	.cfi_sections	.debug_frame
 SYM_CODE_START(kvm_exc_entry)
-	UNWIND_HINT_UNDEFINED
+	UNWIND_HINT_END_OF_STACK
 	csrwr	a2,   KVM_TEMP_KS
 	csrrd	a2,   KVM_VCPU_KS
 	addi.d	a2,   a2, KVM_VCPU_ARCH


