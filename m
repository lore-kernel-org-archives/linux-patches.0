Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B0F4EBAED;
	Mon, 31 Aug 2026 13:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183629; cv=none; b=RSdg2ii0wUhKte+04wnwhFPqGPrQjGTGUhd8uV59BMa/nRyh+JFw44cHJDk2JH1zdJFN44pzcXVu3iV9CgOJXPtOCCwN5EnOJ/+4NqOJfAv8p9OfyDyf8We3Uyi1uE4jehq/9EUbhpRXtG2YBnDRRJnBlzFy9YWcgb6bHNRgKlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183629; c=relaxed/simple;
	bh=umtts5ZHURtExN6CSesHA7LHVq3lNhxLgZ1fzYjaG58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6lMDIpraDZTiN9sO9Kvjd7rDVilnZAdDN8VG29HekO+p6TB541LoIF8Y1lxRyFWr3GOFAXKAZ+K8pZEodrY71qp3pEMFHSo7dXFoYf3NkoVl3wDlR5Sj+36soGyi/RpH0fWIXvAHVBDlACj3q+5nbXcdACq0Uj4qtKwzZBDiUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AJVp9kW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AJVp9kW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46D51F00ACF;
	Mon, 31 Aug 2026 13:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183627;
	bh=KkmhFLo/D8jJTKi6omBE2lnD9u86w0Rr0lgQvVqvFSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1AJVp9kWKnmUycfeYw+a8QcT72uIerReXID9iO92wB80LcLFjo7p1o0qspD4UkqPK
	 Tk9KBLuy5RJJJ8m2MpRKrl+fz/wOAV6e83+XpcVTb0idve5xHwKLanZiLxAHQfGWa9
	 nf7xdjtIHF0KXr0y35H0ShQcCQ+dc5rY/FYGKbgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 7.2 61/71] KVM: s390: vsie: zero stale crypto bits
Date: Mon, 31 Aug 2026 15:34:26 +0200
Message-ID: <20260831133402.405027404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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
@@ -173,6 +173,7 @@ static int setup_apcb10(struct kvm_vcpu
 			    sizeof(struct kvm_s390_apcb0)))
 		return -EFAULT;
 
+	memset(apcb_s, 0, sizeof(*apcb_s));
 	apcb_s->apm[0] = apcb_h->apm[0] & tmp.apm[0];
 	apcb_s->aqm[0] = apcb_h->aqm[0] & tmp.aqm[0] & 0xffff000000000000UL;
 	apcb_s->adm[0] = apcb_h->adm[0] & tmp.adm[0] & 0xffff000000000000UL;


