Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1FD390CBE;
	Sat, 12 Sep 2026 11:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213679; cv=none; b=j7P+OM29+LoJuOulCIaMKC8Bni7coBWueBorM4yDJFxPZE4DdeNFsx6Y2PKX6iM1jFEWEiGCFlMYm7WmH6MxnYb2BCm6bFvM8HqB7wY37RHzE0bmfFALKXnni+mom+TEYlfH4TjlMANQ7T92/Ldu2AAjYHqq47Nl1M6Q8B++cW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213679; c=relaxed/simple;
	bh=hpBDYRF3JGJSEczoliIJU5OZ8eESfk9xksueEDB44C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDwioJ0vT19IRm/68kwo/GJMyHXzc2EeCg5Kj8MRCIMoobBY1GcGwy6qkY+2HBNK6hG/bE+pB8gNkowN/jXAAPeJqvGadh2fhRfS7G1Ti6SEj+BPjslt/UBGwvhMGmu3DPU340EodsYee5rs/23ZI7BV+x6wnHyHR+EAil0nDpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVX23lQG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVX23lQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C773B1F000FF;
	Sat, 12 Sep 2026 11:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213678;
	bh=sb8HCXfIz2ZrhGIGORF0OpDAp2L9RjLRvdv1dtn41xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVX23lQGGBweHm6tvhiCPK5JlUF9zbg9SOkjpPSiHC8i7FKVR2URjBdyLe2FOufkK
	 Z/YIyowU7X4OSkdsFVC9omeb8vBXUc8FCE5erTUq/oxTknJpDJRFTrtDR7qzWgqEtt
	 mrAVS6yJmncxtz3Q2MdvWx02WxBYn8Udcu8jrfFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.12 0170/1376] KVM: s390: pv: Fix rc/rrc offset for PVM_DUMP
Date: Sat, 12 Sep 2026 08:43:16 +0200
Message-ID: <20260912065611.340143333@linuxfoundation.org>
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

commit 1e3c8e7b3465fb8a49d3623d2d0f449c0b5b48f3 upstream.

The rc/rrc value is copied to the cmd location of the cmd in the kvm_pv_cmd
structure. Fix the offset.

Fixes: 8aba09588d2a ("KVM: s390: Add CPU dump functionality")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260811153738.206885-4-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/kvm-s390.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5718,7 +5718,7 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 		r = kvm_s390_handle_pv_vcpu_dump(vcpu, &cmd);
 
 		/* Always copy over UV rc / rrc data */
-		if (copy_to_user((__u8 __user *)argp, &cmd.rc,
+		if (copy_to_user(argp + offsetof(struct kvm_pv_cmd, rc), &cmd.rc,
 				 sizeof(cmd.rc) + sizeof(cmd.rrc)))
 			r = -EFAULT;
 		break;


