Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95E742885F;
	Sat, 12 Sep 2026 15:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228310; cv=none; b=dbQtMnDvdURUCnZdR9686tHEpv37tHB9eQLsAINewK/o0/iDAf81HbX0jvEscK7ogG1U/pXTgr+fNZLi1v6dbtrfnjzD25lMKi7Q2t8kxL4qGsPG60EWxKeyjkPICUylx9Ia1e20iPLtaao+UFx5EION1v79CqxmWMQ6FhYCJqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228310; c=relaxed/simple;
	bh=SMAYnZyeAjPBPmiu4hl2CJJx2EaIGMCbQgOnbwAsil4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJOC3z2q1IZJwuo0p9y7Ot0OEdOwOr/GdZIpTc7uQANmpFDEk8P3eVhLoypZD1+6Ihl5lL+m1yKh2gxVR7t3mK3dkka0o4hITZyXCZoanxbWET5+RNThHqa75G2vA2IglEkZYGURL3RJPzcea/IWo7fMqwNPlxm+PgLkqP6PhlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cL7ng4Vp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cL7ng4Vp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC5B1F000FF;
	Sat, 12 Sep 2026 15:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228308;
	bh=U0HFnNe8y0R+u4Xbq3HHOGSqc82HnUIn5qANJaBTeXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cL7ng4VpJwt8xE5q4sMeBGxrNY1vEozcEAWzSPKjHWVc7IKfTNbGMZMEf7PrqiU7U
	 THsWvXnwAvhp5YZUVQNaU9ShP4yHqDMoKDGRl2k5PA4MpkUjqNpzrYOh55JWCj893X
	 WirD7m7TWKdItD9Q86Z0TXHEoN8stcfG6PUm6bO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.1 0358/1191] KVM: s390: Zero initialize irq in reinject_machine_check
Date: Sat, 12 Sep 2026 08:51:26 +0200
Message-ID: <20260912065556.269682158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit b239410c7653ff6781d4cf1d63cfc52a1bb71788 upstream.

kvm_s390_reinject_machine_check() fills cr14, mcic, ext_damage_code and
failing_storage_address of the on-stack struct kvm_s390_irq, but struct
kvm_s390_mchk_info also has a pad word and a 16 byte fixed_logout array.
struct mcck_volatile_info carries no logout data, so there is nothing to
copy there and both stay whatever was on the stack.

__inject_mchk() then memcpy()s fixed_logout into the vcpu local
interrupt state unconditionally. This will reach the guest during
deliver and userspace during migration.

Reflecting zeroes is the correct behaviour here, as KVM has no logout
data for a reinjected machine check.

This needs a host machine check while the cpu is in SIE so not trivial
to trigger.

Fixes: 4d62fcc0b692 ("KVM: s390: Inject machine check into the guest")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260805110455.7200-4-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/interrupt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2859,7 +2859,7 @@ void kvm_s390_reinject_machine_check(str
 				     struct mcck_volatile_info *mcck_info)
 {
 	struct kvm_s390_interrupt_info inti;
-	struct kvm_s390_irq irq;
+	struct kvm_s390_irq irq = {};
 	struct kvm_s390_mchk_info *mchk;
 	union mci mci;
 	__u64 cr14 = 0;         /* upper bits are not used */


