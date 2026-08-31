Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3561143991A;
	Mon, 31 Aug 2026 13:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184653; cv=none; b=fFIg9c2R3dKZjjoG8afZA0pFXKCcVBBUTu3aFPfVCk+LfXKN09hyuI46RXSLyjwpy0NjvHxIjtzxe53s1hMxlVVvBc8BAFXEhcnLa1E/9or6+KSanX/jh5hkLkyilGTdSOmvDD4XBhNswxLDEYvXeqXv7+zx8Qg9sMZBmRv071Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184653; c=relaxed/simple;
	bh=cXV8Agrm7De/+VeDwAm3HyX+SQzrU6Am35EyzvgDMl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAOxnE/Kp/TxVA+DS8h8a5DW0y62YDdIC4uKJRfwDym8vfyBJGl9V0whlW+HcoEXrHgg2FYc7nYrP2VWBL4BdoAWubob30TjXFIpiItL+2knXvX41YMi1dqIKI4f4a3PGwULSSQcvZ05/sKor3HG/beEVNyA61YKPRw4j5XjGLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWmIt0za; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWmIt0za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AED41F000E9;
	Mon, 31 Aug 2026 13:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184651;
	bh=H3setcUbP0AQMGNrEr2QQJYX8TYubZzJOiBhBI87ofo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWmIt0zaJhvP8JzzcjlG68ZzKYq1r+sxXlWyUcm3u3i3areULics0S2WBmyLoYuiW
	 kV3qcCY0JPkKpiyjavC3No+1nlHNTdk2ez9PP0ZMh2hCw3zNp0FSBdM2TkemDmkzoU
	 I74rQik/qNwDB4wCsE3I0ENnPU61yzhUN+dxQXV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.6 83/91] KVM: s390: vsie: zero stale crypto bits
Date: Mon, 31 Aug 2026 15:35:11 +0200
Message-ID: <20260831133403.853768380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -149,6 +149,7 @@ static int setup_apcb10(struct kvm_vcpu
 			    sizeof(struct kvm_s390_apcb0)))
 		return -EFAULT;
 
+	memset(apcb_s, 0, sizeof(*apcb_s));
 	apcb_s->apm[0] = apcb_h->apm[0] & tmp.apm[0];
 	apcb_s->aqm[0] = apcb_h->aqm[0] & tmp.aqm[0] & 0xffff000000000000UL;
 	apcb_s->adm[0] = apcb_h->adm[0] & tmp.adm[0] & 0xffff000000000000UL;


