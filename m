Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C7749890A;
	Wed,  9 Sep 2026 14:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962548; cv=none; b=fPmmNZAlniLECNw9LMDXOBEslU4/H9LdyjF5NYW2MtA05rsZ6ASaqs0sg+A5KY8v6QAPiz+MBimdmlaIZW099foUc8JydllTtphSdzEj4rhdSNYLNAif0h8RUavC2jWx3s43SskevyvWlDWIN2p60td+9rdsvjYbtdIqE9ikJik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962548; c=relaxed/simple;
	bh=nu6b9LVYsW56XlqqmN7fk8KZj07bH/CZ63NRtypHCdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gsHBf7Oy2lrbBlnxDRirLOtuRQYAYJG8GiQmkG/k/GVcG4RIdybKs3KqZv9XtKgUrdq9R/O3vUVF9djA5hwd0LV1S8mQ8bMxKneUtJQ00qaX5HimmE1bMTUmIuTbR2NUNvw7ooY6p9tkoVCroHepnACJtjATl+PYMIhBB1mb790=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhwyDbmW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhwyDbmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB99E1F00A3A;
	Wed,  9 Sep 2026 14:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962547;
	bh=RcLjM8lIzhnXrnB6gWiTYycyhjHoSrWKW8Ple81dTGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lhwyDbmWh/oIt6Usy/TyMtqDHTRDxu2PIKHdT8mZdeOU+F57IkxYCa4PhzoIw2hAD
	 ynL/f1YZASeLAvRe71NFM2mHQWPJZ0bhZddQ1Si9/3CLuh5Tzg2q1+aqK5kGPZCCVa
	 gP5zeet5Mo790edelgNeGzQfPtah5KJUw78QEd/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 327/556] LoongArch: KVM: Fix uninitialized stack variable issue with dmsintc
Date: Wed,  9 Sep 2026 15:40:07 +0200
Message-ID: <20260909134242.160092160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 81aa3a58b542ed88819115c80a17acd86eacb89d upstream.

Variable vector[] is declared on stack in function dmsintc_inject_irq()
and sometimes it is used without initialized. Here fix this issue.

Cc: stable@vger.kernel.org
Fixes: 03de5eecb0f0 ("LoongArch: KVM: Add DMSINTC inject msi to vCPU")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/dmsintc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/loongarch/kvm/intc/dmsintc.c
+++ b/arch/loongarch/kvm/intc/dmsintc.c
@@ -19,8 +19,7 @@ void dmsintc_inject_irq(struct kvm_vcpu
 
 	for (i = 0; i < 4; i++) {
 		old = atomic64_read(&(ds->vector_map[i]));
-		if (old)
-			vector[i] = atomic64_xchg(&(ds->vector_map[i]), 0);
+		vector[i] = old ? atomic64_xchg(&(ds->vector_map[i]), 0) : 0;
 	}
 
 	if (vector[0]) {


