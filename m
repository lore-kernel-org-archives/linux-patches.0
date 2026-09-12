Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134AB403B1E;
	Sat, 12 Sep 2026 11:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213674; cv=none; b=YeuTaep8+u5Rbp+nuyEgdQG3ViD5XlM3WOnbFZJz7YYYAB/fIwGhV69a2NLTtWdIUaUQLCLKjntkc0kt9DyoKt1G97SAFYl6YFgDXl/11LsmBnVK7dXs2E7UjYfjkUWOblppDCzeB2aulqfogBgCDYrYhJrHKd5TtsxyYS3Qw+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213674; c=relaxed/simple;
	bh=PMy0+hcxbI96XaaM8VTIIGFI5vAvKSWHTmJpJ/G6efM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5upjjf4dTJDX2XpEZgj7B+uRYx0dMRReEaUxmxlJf7F5VqUfHIqt7QLoRPiN+5MLH2zK2VHqMw0FW9r9g9O1TppYLzAHJIL97jM+di5pC6m0hn0X3ye+k1uMtHD8xWNvDIvl/1v4uAt3CDwRU64FLNEGMrI/esjfuxjpDlXXe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbZk+5FV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbZk+5FV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C270D1F000FF;
	Sat, 12 Sep 2026 11:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213672;
	bh=PPs6WSe/fdsDLOw39YPlg4DnOiI7uPJYWuhNy83yKxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbZk+5FVccSH/9GtXydJo0QVo7zRORXw6yvTheerlV9t08umdgNB2e1fO+aPCaoU2
	 cfzbM4pmflJaSaMo2uzrXDAvhIAGy21WYNy11aqxc8B0WULkIzVNlkFclqw83UhPg5
	 W7UZf3IGYm0tDG5pc1PN+Yxo+TQuiTrR4aYbw5tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.12 0169/1376] KVM: s390: Zero initialize irq in reinject_machine_check
Date: Sat, 12 Sep 2026 08:43:15 +0200
Message-ID: <20260912065611.317702299@linuxfoundation.org>
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
@@ -2863,7 +2863,7 @@ void kvm_s390_reinject_machine_check(str
 				     struct mcck_volatile_info *mcck_info)
 {
 	struct kvm_s390_interrupt_info inti;
-	struct kvm_s390_irq irq;
+	struct kvm_s390_irq irq = {};
 	struct kvm_s390_mchk_info *mchk;
 	union mci mci;
 	__u64 cr14 = 0;         /* upper bits are not used */


