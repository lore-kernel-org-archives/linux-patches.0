Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99B056D2BD;
	Mon, 31 Aug 2026 13:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184109; cv=none; b=UOWcJ9fBVISmV2sO3tu8Bk0j85g9K01qUesZDp8bnIk6XYl1VIcOO0ftvsDs21L12Hw0ob0fccoUx6RI7bb9+nI9QZYRpdGNWfvHgTMxOdpmX7N50KgT7+qwkyIxmNMpuEsJRGADkbK6cqjiRTTQ7eFeMR20hwOT5xs9DZNmpgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184109; c=relaxed/simple;
	bh=Nm7IQUmay48BoT5xJ+ZYEmKa8bZ6PrImhiodZayVonM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUEEN8i3iBDAPnb6r0xXu0H2fqEXZ6dA6GGWnQX3m+aNdZnpEqceuInXSlOJCGVV7Fh1tDCbxxHrbtfQu7O+N6r62xIo6MmxNGG9fM+bE42T6q85BAGmmOr8WkuGRGj3HUW9RRGZ+3oY2KMi+Wpm25a5XsO33YPHDif2AYYbteU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNxN/7Vy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNxN/7Vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326091F00ACA;
	Mon, 31 Aug 2026 13:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184107;
	bh=4sqOakWCCOTEyaHLWiKtxI8CNowvRJC19JFc9IzSlMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNxN/7VyLV/tyi0NyCKHllEErNXcLh9dlkcLhH8vgDKaHrYKmO/et5CckPgpvK9ur
	 Xh4D5gS6BjraiMo4WX9yzcwzdsZVKhazI6aWWl25Rf6uRLRYOc5V2ZPbQ+8oO0oTBA
	 Q5hriLo9LSac3gMCtgrDG+9RN+ccyBv3E4bhLMzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.18 74/83] KVM: s390: vsie: zero stale crypto bits
Date: Mon, 31 Aug 2026 15:34:50 +0200
Message-ID: <20260831133403.211514063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit 34d5b5b646c91cfb9338d7a12c955a70ffb8c66b upstream.

When shadowing crypto access bits from a format0 apcb (crycb 0 or 1),
the bits 64..255 are unchanged from whatever is in the vsie page in the
crycb and thus in the apcb. This gives a nested guest potential access
to a device no longer available. Zero out the remaining bits.

Fixes: 6b79de4b056e ("KVM: s390: vsie: allow guest FORMAT-1 CRYCB on host FORMAT-2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260811153738.206885-3-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/vsie.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -184,6 +184,7 @@ static int setup_apcb10(struct kvm_vcpu
 			    sizeof(struct kvm_s390_apcb0)))
 		return -EFAULT;
 
+	memset(apcb_s, 0, sizeof(*apcb_s));
 	apcb_s->apm[0] = apcb_h->apm[0] & tmp.apm[0];
 	apcb_s->aqm[0] = apcb_h->aqm[0] & tmp.aqm[0] & 0xffff000000000000UL;
 	apcb_s->adm[0] = apcb_h->adm[0] & tmp.adm[0] & 0xffff000000000000UL;


