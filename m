Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EF73370EA;
	Tue, 16 Jun 2026 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622213; cv=none; b=H/CmD09zFDCq38+8x/mbeGH7WRhHEmwITa1PZaVE33Ae+WpBWBuX9gtOgn8o5i8h9AjMSGSEwvpt4+MqBHS7jLy6X/w2pS6vNZ10HyY0Xq0jNLZMTuQ4qFpdkV9EYimoGlMsaxvSL055I2KK0AqGcWNSt7yRm1iEicH60I5DsC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622213; c=relaxed/simple;
	bh=eYe3x0EI555uGi8gc2ou88j87W+qa72B6JNA0P1/VRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HShZ7NJVKL7b7Mqd8bH2DfDVXiIilE3oC+zMbZFtrgAgis0dxDdgedAYpttbZ+/rRuY24+3R/5DP/9Q0jGuEojxWf9Ic5smWvNifdO3xLU5M5Q75fEO5T8RL+V7lXbVSVX1HKFDA38Tid1kq8Yh3anWv6mOPg5Rs9iBWZzNWVDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6hsx5AE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6hsx5AE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE971F000E9;
	Tue, 16 Jun 2026 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622212;
	bh=DgRbclZJmqbhpaApX8pK1Gm25i63lzMi4U2As45SQI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6hsx5AEcVANuYnxDiXnqxQJUQRN16CdDOtH/ZT+qCe8Bpwpvuv+JzdK4j+pZ9/N5
	 sO4B4ycwsYMqeXNSr6Daa5Y0b9XrIr74dB3WRYgRrkcEm2tB1sYNGI6GW/hKbn6I4x
	 oXKKdosWcFKpDzhT3oiZgtGTSEXjQI3vAtJF0j68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.0 002/378] KVM: arm64: Take the SRCU lock for page table walks in fault injection and AT emulation
Date: Tue, 16 Jun 2026 20:23:53 +0530
Message-ID: <20260616145109.883038193@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

commit f2ca45b50d4216c9cc7ffabf50d9ad1932209251 upstream.

walk_s1() and kvm_walk_nested_s2() expect to be called while holding
kvm->srcu to guard against memslot changes. While this is generally
the case, __kvm_at_s12() and __kvm_find_s1_desc_level() call into the
respective walkers without taking kvm->srcu.

Fix by acquiring kvm->srcu prior to the table walk in both instances.

Cc: stable@vger.kernel.org
Fixes: 50f77dc87f13 ("KVM: arm64: Populate level on S1PTW SEA injection")
Fixes: be04cebf3e78 ("KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}")
Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/aiAZfdeyanIvP8SD@v4bel
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/at.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1568,7 +1568,8 @@ int __kvm_at_s12(struct kvm_vcpu *vcpu,
 	/* Do the stage-2 translation */
 	ipa = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
 	out.esr = 0;
-	ret = kvm_walk_nested_s2(vcpu, ipa, &out);
+	scoped_guard(srcu, &vcpu->kvm->srcu)
+		ret = kvm_walk_nested_s2(vcpu, ipa, &out);
 	if (ret < 0)
 		return ret;
 
@@ -1664,7 +1665,8 @@ int __kvm_find_s1_desc_level(struct kvm_
 	}
 
 	/* Walk the guest's PT, looking for a match along the way */
-	ret = walk_s1(vcpu, &wi, &wr, va);
+	scoped_guard(srcu, &vcpu->kvm->srcu)
+		ret = walk_s1(vcpu, &wi, &wr, va);
 	switch (ret) {
 	case -EINTR:
 		/* We interrupted the walk on a match, return the level */


