Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1ACD46D2CB;
	Tue, 21 Jul 2026 18:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658398; cv=none; b=TJaHF3VgZzTyJrqipKgd+9OzMRq6eCKbo54Ea0r3SlEv/D9aEZBd0RcJJfiHfiXOU8dbdmknlEdRhUB/ZW+P9FZvXCBQXzzIL/fyVjRRybOPh80QRlfsxfeisVagSNH3sv/NhKfyBL6xPrOZj27k9uz+/FL+pfxlyDZq3/9i104=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658398; c=relaxed/simple;
	bh=8po1Lp2PNQ791/E4sJ9N9pbRbB8X1i+ZxYsRNJOjC04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9VnXHZWLDKT+rtqRvuawhSaXfG4lQ1L50t0AcNwtppuCuTsZ/nBNH8Ug20nvdRHyKOFnaI4Vweg9FZbuws0EgIWjYexOw8Jq26tqQjHZOEwNp5Ys2HX7l7EqRdAoM6f/zrwdZSKLvqIlooRHN03ohvUQ7M1ZplVIRcswGuPOs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnY8AEAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnY8AEAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4089F1F000E9;
	Tue, 21 Jul 2026 18:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658396;
	bh=Jo8oMaxx3cJkEHQhXdhGb0LS2Y3IGv9MSK5a8rx0Flc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JnY8AEAe8yBoYxzhJcGa+mdA33SrJ9uQGpasAp3rHPJf81Blac7OxcOR0ZVLWZ0vy
	 4OZ5JzRuQDHHrIvV56vTLLZ7x8N/26nD6QPIP6SLzHqBjPCEw2iBc6dgbis+04fSIh
	 jbmHSGBr0cEDTFkjb4GLddrRK6SFJJeyAR0Q3NCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.18 1129/1611] KVM: s390: pci: Fix GISC refcount leak on AIF enable failure
Date: Tue, 21 Jul 2026 17:20:45 +0200
Message-ID: <20260721152540.817488901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 7b69729046a4c58f4cb457184e5ac4aaa179bff4 upstream.

kvm_s390_gisc_register() registers the guest ISC before pinning
the guest interrupt forwarding pages and allocating the AISB bit.
If any of the later setup steps fails, the function unwinds the
pinned pages and other local state, but does not unregister the
GISC reference. Add the missing kvm_s390_gisc_unregister() to the
error unwind path.

Fixes: 3c5a1b6f0a18 ("KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260624061910.2794734-1-haoxiang_li2024@163.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -329,6 +329,7 @@ unpin2:
 unpin1:
 	unpin_user_page(aibv_page);
 out:
+	kvm_s390_gisc_unregister(kvm, fib->fmt0.isc);
 	return rc;
 }
 


