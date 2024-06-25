Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CED1465A8;
	Tue, 25 Jun 2024 09:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308813; cv=none; b=Q6rd5MlNA6fJW8UiKI80Mq8JZpNHQjpSDF9xRLWJhd3Zsczg1Wx9g2+ee42COKej6XcrjVwI9JNNqmWS6GXyKXixThidPW4m9mLH7bAV4x4Wpj3OhHH/ZeFmodqOhjhE0YTvkxUWxUjKoIUkft7oeet8xw2Eht6Fxzjk5Qv0Q9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308813; c=relaxed/simple;
	bh=SkbuotTJ1GFoollVBR1PcqDm2Vhtg3lNtmDrKUteoDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPTD0AY40XqdaYrlHckbc0na6eaadj0EoNaBPDFG77I6qz2xTYzGIZzKZm+JdvP5A/oBbzmaRO7jeXoZUqUfYArqxYC34tDdlzSesIglnJ850abOwfD5ibMjLbfSaJKJ9osTBkN9TKcgZfgV0y0EFYGJWD4eKz85O2ZHS8V032o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2Zq0l3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2Zq0l3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0CEC32781;
	Tue, 25 Jun 2024 09:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308812;
	bh=SkbuotTJ1GFoollVBR1PcqDm2Vhtg3lNtmDrKUteoDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2Zq0l3MDNi9tabSEwVCEQBrU2jUYSKUuB1by3BbsQi8DPNtJFjQgrp6O8iWlkA+l
	 5ZlnHbN3L5ulATk7b24YUxjaiwEs1WPIV/busARqgoZqwy3TB/xhQkNCoM5jQPNX4T
	 VSEgWKdi6kp9NUgw1rgOB6T/G8+Q3/AB56kwCMPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Merwick <liam.merwick@oracle.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.9 231/250] virt: guest_memfd: fix reference leak on hwpoisoned page
Date: Tue, 25 Jun 2024 11:33:09 +0200
Message-ID: <20240625085556.921220488@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit c31745d2c508796a0996c88bf2e55f552d513f65 upstream.

If kvm_gmem_get_pfn() detects an hwpoisoned page, it returns -EHWPOISON
but it does not put back the reference that kvm_gmem_get_folio() had
grabbed.  Add the forgotten folio_put().

Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Cc: stable@vger.kernel.org
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/guest_memfd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0f4e0cf4f158..747fe251e445 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -510,8 +510,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	}
 
 	if (folio_test_hwpoison(folio)) {
+		folio_unlock(folio);
+		folio_put(folio);
 		r = -EHWPOISON;
-		goto out_unlock;
+		goto out_fput;
 	}
 
 	page = folio_file_page(folio, index);
@@ -522,7 +524,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	r = 0;
 
-out_unlock:
 	folio_unlock(folio);
 out_fput:
 	fput(file);
-- 
2.45.2



