Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A865633689F;
	Tue, 21 Jul 2026 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654058; cv=none; b=LrpLiFIpPAF9+mqvfUHDFt7+G/Ym0emJ4dW5PUPTm5FjjlvQdsKicH444+7JrGlo+mWNiFKb5HXE6ZO94O4aQ1GpIvLciN5BQugoqJnXNLA7TrSxmphL0kulWpIjjp3MYH63P6FnZtwg8vuL7ryofrNpzYjGIdFqsLXtNZGisVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654058; c=relaxed/simple;
	bh=lnL6sceg4O4n1+0H1S3Kmpcylvu2P2A+2wkNb6YoWAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6hgNoJKTl39WVIXjOaQg8g1gZWOchp0cOCPhzhie989x0ed3D3jiUkiqBImjTvuaTuqHbhwevZNohHxzkOyLNdKD5Cq4/V8wwjrN5f0Q6LWoxl1fyW3qqmZpWK8Gt0rmoxHWG6A/+9AlPfH7AgmxhLTdPyWFQr/UkGNgLijylw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItwD1Y/X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItwD1Y/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199641F000E9;
	Tue, 21 Jul 2026 17:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654057;
	bh=/V10ePofCVjB8lzUY2Q6RKZdPDtIE6T1MM0haS2VKdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ItwD1Y/XcsIECs10UzVxpH5FDX/0Ng8z6C5gN/s6eSETX2iaF3BuCCB2XZpHBZEBw
	 5GqRdiubIBMJvTDEsRYYTjnly78q3wsUOrY7YK1Cie7SVa51HpX+RLvuv78cInoqLf
	 i/vB/JCA0XOEfWGhw6ps4CpB+NNwkfKvnFgpbRmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 7.1 1559/2077] KVM: s390: pci: Fix GISC refcount leak on AIF enable failure
Date: Tue, 21 Jul 2026 17:20:32 +0200
Message-ID: <20260721152629.552863489@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -328,6 +328,7 @@ unpin2:
 unpin1:
 	unpin_user_page(aibv_page);
 out:
+	kvm_s390_gisc_unregister(kvm, fib->fmt0.isc);
 	return rc;
 }
 


