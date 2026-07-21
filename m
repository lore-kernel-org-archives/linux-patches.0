Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3FD3B1EFC;
	Tue, 21 Jul 2026 20:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667015; cv=none; b=uRWRRP+4G3uiAWWHpiztY9kIosNTNkBnyKJ3nWWiDVeoC8LQaiECkOqVVx/VIVqFM8KbHIie9BM571loKnL4Kq14pCKkiTGEqtRD0kEmfMHbXfoqSimHIIl0XMzmuUXXNuLRzBT1qzP2PFbZ1X3JUkGjDabUl71lOdiCINk7P0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667015; c=relaxed/simple;
	bh=CfKwkHp3JhQ1uHAmEHaJXgZS/xjNvKxeg+5PdrS4S9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDtdJ29RKVXUHXjWtvKt39/B7n9nzbuEa0zkmCWNEtOAH+Y4KS2u/eVR16EBbtLpKcZwzKC2brJIDOcYnI2iAEiTjj3MZjig7rPViDQN/kMSBXXA4Eceikd4GEOJfA8yj4N8abD4/0pRYUJxAugtYD6N8c0nhLI0H6NIhgC6Qz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2AGAHH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2AGAHH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6D01F000E9;
	Tue, 21 Jul 2026 20:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667014;
	bh=fpm+YG0uZOvENTucabBLVsXvbjK7FdGsoFSVhUutzXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2AGAHH05DyrzumIX8EFHPJI2MgisQ4WhFl93amPz2SCRWOKWZQhH8OvF/Prkgtye
	 pBfPUmPhIfVilhRNPXB/TsrJ5P5WlMR7YQ3sNLNUWZMEgoxMBhnOFmJ7bJF+gW7uT9
	 LQHIzuYJkWv59s0Rz5KiZ2CUGMRE+8ZyoVVcHXnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.6 0901/1266] KVM: s390: pci: Fix GISC refcount leak on AIF enable failure
Date: Tue, 21 Jul 2026 17:22:18 +0200
Message-ID: <20260721152502.008200870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
 


