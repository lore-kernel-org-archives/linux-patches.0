Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5E743E06B;
	Tue, 21 Jul 2026 21:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669891; cv=none; b=OipiAn92cK/x/Uh1YSftOFpAz9croZSC+wnv7+JBjrHtyuOzv8MYxznpEMT7Z3jdEYC623hw4duphkNGa6o6CD+PkSDe2aAeGIObd+w1/4yHwZeLYtw6E8WEjRxBC0vuc/rtX4auCz1xo4LFtMXNHwHR6w/5qUb2YCdfE6sj7JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669891; c=relaxed/simple;
	bh=180h+D9v0b1n/hUI5TpWPJtDQs6BNFjcQYOOim+S66U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZClAbf43yOy1cCUOMWW+uoHiWozT4F8wh4UthaHuXrTPzbUoy/Y5LDI6siOd2kv8C+5OCmfgjGW+t1N9Xa1QBb++cL1ItCjdhCt1omoDWBR1l8nXvfu6XCYhUngY3LbhxdJtdcpLMg384Fnx2jU8BH01XcQfxoTG+QA+mGkZDvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRmB1cGZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRmB1cGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D845A1F00A3D;
	Tue, 21 Jul 2026 21:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669886;
	bh=wW1wf9xoL47gTwRKfQGPMcw6YQ/lX5U5YAPKPPqOFis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRmB1cGZYHjnq1Ipk9+qEfV9y3py7LVW1Niu9OFE6M5Y7nODyQ3Jaj+RYiOZo9Hgz
	 zHlGZhjTQ0cb64oeijOIjIchY/K9bczIAMqaoE9QCuEF2spO0AWCCpt548q7MVBIUN
	 H9BjZMAyx97sTTOv75CutB5LNuoDtzCN0GG/TmMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.1 0724/1067] KVM: s390: pci: Fix GISC refcount leak on AIF enable failure
Date: Tue, 21 Jul 2026 17:22:05 +0200
Message-ID: <20260721152440.784124046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
 


