Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA530576EB5;
	Wed,  9 Sep 2026 14:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963983; cv=none; b=Xx3WWZZ9o0N8Gx9qv+KIsmkR/5S7RssKhrsSceA8kL+cfbyGmsBoFriBZmOPBA3yUH7QJfQNNMVQp4iGTMw7ehmab+GTYhrp2Si7cWVdwocyxRxO2J6vwgYBt12K3xGIoSKNeDToQOAVqjGco1uhsSKndLhHwUgGE/uDipzwyKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963983; c=relaxed/simple;
	bh=ca+bfCjq9B+SdGF47Xesivz1scwWFO9UujybMzs89GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S73lIfTyZc+95yAp1MET8DRjgJOHyJQW7RyMyuKh4r9GLfIYinTlD098L/jkwM/+cNEUZY1qVF0fS23vNJANXc5bmAszIrhZ9DA05iTIUfS3QkzstOqUfv0D/p61e/QcBBNB9pAn/FllvajkUnTiac6VPfwXm9PLmnsvxnAe36o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHY/6HsQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHY/6HsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3431F00A3D;
	Wed,  9 Sep 2026 14:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963981;
	bh=KOgToXIvjlXKbiKUDFzw2CzIqB66SPhJP4s7XuhCiAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VHY/6HsQfc701jnDu6HvmLgk1ILhxIHm6GB5dsYJegw7zy52Dblrn/S2Myktre9dQ
	 Wv3wrQcAkPniQVpZ2M9Fd01+eJijrPmYKD39PsBDyKYwTBBX+1ezkQ7j3FHDU8QHfO
	 wiJ7Auqij64Ibe5Bh+wnTdwQv7FV4gU5mWSZs3nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 264/583] LoongArch: KVM: Free init resources if kvm_init() fails
Date: Wed,  9 Sep 2026 15:39:09 +0200
Message-ID: <20260909134247.243273351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -413,7 +413,11 @@ static int kvm_loongarch_init(void)
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


