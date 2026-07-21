Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427E7470444;
	Tue, 21 Jul 2026 19:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663532; cv=none; b=pe6h8IENYFNZxEKC2YY+QlFmsVVnCnoO78AjvB+L5QRpB3/uOwodI1iBWjjuN9foje1LwPv5DZJ3D22lBfAUyiy5FhRzMvCSM5XLVGJEmL8nebvAz2oEpsNTzia4VogY+DGqq0FwBRvNXNJaXC5GoqUrlRu5+smVe0ImIWz6IBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663532; c=relaxed/simple;
	bh=8Q25v+cajKo7jzZs22gZuzTF+nVJUZ2AH9RvHZbW4m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBhltTLCR7RVpQzwpTjZX/Asi5O4ZRle9BSNMaq16OJP9ZCfZaSQ4peSb7uaG0ZICmdpc+sr7iwl2Cjm1M1dwY3ZHAIPj08RBqG2CLGDfVIolWTpJt0PpjRty/ia/MUUtSIwXqFre7s3VBQwJbjs07qhMGO2riMhCBEnTm/1u+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5RETTKS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5RETTKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A76D1F000E9;
	Tue, 21 Jul 2026 19:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663531;
	bh=QUiTm3TYKjXtOF8BdYPkE7Qq++ZWiluFhN3S4ilh8eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5RETTKSsPSOZDmdF++bOD6Q2atvp4qRFJ8NgtccPFJu1/fxD8ukL/oZktQ0SOEeh
	 CZuT++jhwWEDl07wOHVhSu3BZ9Wotjojwif7MLLEcwQCsfn3+ufYjsatbXH1GEeEPb
	 TrMQDdLIXQHEjUfoH80Ma0cx568JqEsG/KRf2/Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.12 0831/1276] KVM: s390: pci: Fix GISC refcount leak on AIF enable failure
Date: Tue, 21 Jul 2026 17:21:14 +0200
Message-ID: <20260721152504.655790106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -330,6 +330,7 @@ unpin2:
 unpin1:
 	unpin_user_page(aibv_page);
 out:
+	kvm_s390_gisc_unregister(kvm, fib->fmt0.isc);
 	return rc;
 }
 


