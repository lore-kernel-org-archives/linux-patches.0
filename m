Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC93C2DA775;
	Wed,  9 Sep 2026 14:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962563; cv=none; b=WwlDD049jZm3+BttdyUjT9a9uDjrHFwT6ETGSskUEh92H9zNmA+Kuct84GQzYFC1MgEOJQc09k5bLlCD9rHXJ3iAtkYObl0Xo8xXIFwvd2Hl2pkdbgoF5oR6tPhQXJTenLShogd3UMSrYduYVqFb85efBN6Q29OTll7wF/PGUnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962563; c=relaxed/simple;
	bh=U2ZSTUXkcaiS6yW1JX8vSfC+XS2c4DnutllQpSioDFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ja9977kiAgnEqPLC7eRBRp2lDgZDlC5MSQsE/ECxsOxpud0ojWY2sVVK87G25hy/rYSB3N2bgESEmu86acPXdvN2MgqMOoafk45RYaV13c+ItpANvrVyJvQ3LmlTsbSFrFi3rhL3tFTAO9HhBYceD5e9qnBE9MdGYSYWFVohjqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKj8VUX6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKj8VUX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FD41F00A3A;
	Wed,  9 Sep 2026 14:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962561;
	bh=m/f85qKIgcimnXH7ftHbeIT5ud6wI3SMaJ8YeBei0ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IKj8VUX6q1nGo4DRlJzx6wfxblVIqP2WGD51vwd9FVkFcN3utrMka35gsv0+GNdTB
	 MU0rJKPsPBT9B3EauDgJNShnx8bOHVK9VgrJ78IxqK1gLJ0QaWmSlX9QehvsQ9BAUR
	 Afq/DC3jPI2Y4TOX54+Z2EFaXwKe7JBoXhtZ+ayw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 332/556] LoongArch: KVM: Free init resources if kvm_init() fails
Date: Wed,  9 Sep 2026 15:40:12 +0200
Message-ID: <20260909134242.332115576@linuxfoundation.org>
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

From: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>

commit f7a1064cce3b100b54780c68529176232d8eb01e upstream.

kvm_loongarch_init() calls kvm_loongarch_env_init() to allocate the
per-CPU kvm_context (vmcs) and kvm_loongarch_ops and to register the
perf callbacks, and then calls kvm_init(). If kvm_init() fails its
result is returned directly, but since module_init() does not run the
module_exit() stuff on failure, so kvm_loongarch_env_exit() is never
called and those resources are leaked.

So call kvm_loongarch_env_exit() when kvm_init() fails, matching the
teardown-on-failure pattern used by riscv_kvm_init().

Cc: stable@vger.kernel.org
Fixes: 2bd6ac687261 ("LoongArch: KVM: Implement kvm module related interface")
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/main.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -453,7 +453,11 @@ static int kvm_loongarch_init(void)
 	if (r)
 		return r;
 
-	return kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+	r = kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+	if (r)
+		kvm_loongarch_env_exit();
+
+	return r;
 }
 
 static void kvm_loongarch_exit(void)


