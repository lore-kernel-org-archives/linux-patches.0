Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788513EDE4E;
	Tue, 12 May 2026 17:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608788; cv=none; b=Pryoe3sLTQdIOAh1Pq/Ao2Ru9u3alBWKl+Gn2n9xZCXjqzYW3A7iDN+ZLQsqw86ypVKcPl3kN2HS+KHcFw47ooTE+H643agAinOoC29b/IcKJaLM2gcCH172be1/i0qJGtzNTqeqoXk6bAympN1p30IwEy45HBSVA5FN0Y0dTkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608788; c=relaxed/simple;
	bh=kiOLdcQNK1KkWp2SzAjisT6l61iyaVL+ZHDhh7d9f1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dC5eP42mlrONnhlQhzHFZNSYBsK+ylSWIDz0VXw+kSIgLSHiorA5dtDKBF4or5GsKK90NSuY+eZymGsyIn2P2UiRORrMIyPlvOFWqJ1+lkINDoK4Mri23WGO4xV5jcQPCX53P7qfAeC49sBVxxXnBjmPLiYAhXr4MsPEgRgyCu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/xmWnsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/xmWnsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5ABC2BCB0;
	Tue, 12 May 2026 17:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608788;
	bh=kiOLdcQNK1KkWp2SzAjisT6l61iyaVL+ZHDhh7d9f1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/xmWnsEViS00iDzJOdYTigMSpC/ZxCE6rjvxH0fSGcjr7cK6CNMKruZOl5cHfz+q
	 brehJfgxrrUaf2smAmNCS2MkRTo1fCmkb2BKqMn+pPbdNnNJd+5UeRrWT6J2ra0AR7
	 DJs6SeeDdXPAblWOlzUYHPfIlufO8tEvSOrSWM58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Andy Chiu <andybnac@gmail.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.18 173/270] riscv: kvm: fix vector context allocation leak
Date: Tue, 12 May 2026 19:39:34 +0200
Message-ID: <20260512173942.090365910@linuxfoundation.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit b7c958d7c1eb1cb9b2be7b5ee4129fcd66cec978 upstream.

When the second kzalloc (host_context.vector.datap) fails in
kvm_riscv_vcpu_alloc_vector_context, the first allocation
(guest_context.vector.datap) is leaked. Free it before returning.

Fixes: 0f4b82579716 ("riscv: KVM: Add vector lazy save/restore support")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Andy Chiu <andybnac@gmail.com>
Link: https://lore.kernel.org/r/20260316151612.13305-1-osama.abdelkader@gmail.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kvm/vcpu_vector.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/riscv/kvm/vcpu_vector.c
+++ b/arch/riscv/kvm/vcpu_vector.c
@@ -80,8 +80,11 @@ int kvm_riscv_vcpu_alloc_vector_context(
 		return -ENOMEM;
 
 	vcpu->arch.host_context.vector.datap = kzalloc(riscv_v_vsize, GFP_KERNEL);
-	if (!vcpu->arch.host_context.vector.datap)
+	if (!vcpu->arch.host_context.vector.datap) {
+		kfree(vcpu->arch.guest_context.vector.datap);
+		vcpu->arch.guest_context.vector.datap = NULL;
 		return -ENOMEM;
+	}
 
 	return 0;
 }


