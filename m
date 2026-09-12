Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF414479880;
	Sat, 12 Sep 2026 11:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213694; cv=none; b=FAkKVsW/G62bhK5sXPzZ5yiCKm9rv7UkpOHl3aUPtNqNmRUb08V6EowjcIVp9UstK+Gu5cyWPz/WS0zv7F/VP508z8DrmyN9Wml0HiOWnrkKp/9OSuMJU2gLTqh35J2KG0lNFuob7GBjWt42qkIFUdBCg/PIOcpB0fNRJ8PEq+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213694; c=relaxed/simple;
	bh=Fb3YQRDXjJUGxbOxomSbKjCD3wVNShBM0RVE/tG1p/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j72dYihf/wjDhoCl/XcdRhs3qxyk4HDPjDv/0QvybiqmF8Uv6d6iI+u6kojcovMfMvM2aZx18T65/a5VYJNPP4nkUfEwKOedM9LlfYBgFd8yArx8KZaon0UbMkWN6lhYS/GwFsolcC2M6ykiCgUtBgqCZdqeGdUnySWVPAd6Ay8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qs+9uYwv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qs+9uYwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2431F000FF;
	Sat, 12 Sep 2026 11:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213692;
	bh=NkGkPMyygoAvq4nn30k5+wgESqmvE1RsGbgRgvhDIfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qs+9uYwvQlly48edO312KzJqO44yYIIYSduSkUsWyyTE5Rxn4nQUSytPWt8Zqr0CO
	 jrKzYkqfiqN08HkkpV7KJZVH05Fty/mKZHX3ZhSBQqrql1UPK5ocnUqZ5cAzZHz7Ne
	 OtWFM7Y+0eXV9x4xSkB8Upp72t7PZtcn7GRRE5qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 0173/1376] LoongArch: KVM: Free init resources if kvm_init() fails
Date: Sat, 12 Sep 2026 08:43:19 +0200
Message-ID: <20260912065611.405774014@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -377,7 +377,11 @@ static int kvm_loongarch_init(void)
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


