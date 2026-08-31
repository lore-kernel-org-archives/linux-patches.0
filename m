Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C3848AE35;
	Mon, 31 Aug 2026 14:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185126; cv=none; b=eVmE6Lt8Zl1FZIeAAqgTUWU0K+mMIZlmv1vAV5r2UxauWvazm+dbyezA+R5TWClIkgxqR45JOnrrQtYQ+2K0BfxsCR0AfQgY2kpsUByYwT2W3/tDMRwvh9UORgjASn0T+c/KrARETUApD38+ioBMP7pYQKmVS/WMieD7Krb7bVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185126; c=relaxed/simple;
	bh=LZ2u0h75qTDA1Ix1WB6R6LJi8nF3d+lnDMo+lP5fIuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S21pzzZ0J0IzJx+pdtHqwNCFNQCNNbY4Pm9cFhmtBejhehGgyxcSg3Vqxc1X/1/+sCcA/bV3OQUS4sM1pcpmJAvo0DyTZGG9MAXR+RqekFG/bYRLeSjXWEIMAOjlzRhp+1CUFOwf+1WjOOxmhpdzwWqigVo3kkNO28D1C1TAgGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A4KDLtlF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A4KDLtlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CD91F000E9;
	Mon, 31 Aug 2026 14:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185124;
	bh=qYGZTe37cqiAHdKKRK+HYezfKzx6pFyCyP+AKBYDjcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4KDLtlF4nUIIsHvg9/wonO+lotIsV/xcCXS33/jn/BdH8jEhIYtnh1MVeJmckMHr
	 CD7QXhZJ/KsvJi7dJqX7oUYlKfsbA8xAEprw4uQZPhwKG5tIg3lizkM2tizOwlFm9j
	 ytHIhC6Ms9EBV6MCduD1+DOZOvb2JhmIDR5XsNhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 5.15 61/69] KVM: s390: vsie: zero stale crypto bits
Date: Mon, 31 Aug 2026 15:35:34 +0200
Message-ID: <20260831133401.790070344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -145,6 +145,7 @@ static int setup_apcb10(struct kvm_vcpu
 	if (read_guest_real(vcpu, apcb_o, &tmp, sizeof(struct kvm_s390_apcb0)))
 		return -EFAULT;
 
+	memset(apcb_s, 0, sizeof(*apcb_s));
 	apcb_s->apm[0] = apcb_h->apm[0] & tmp.apm[0];
 	apcb_s->aqm[0] = apcb_h->aqm[0] & tmp.aqm[0] & 0xffff000000000000UL;
 	apcb_s->adm[0] = apcb_h->adm[0] & tmp.adm[0] & 0xffff000000000000UL;


