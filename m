Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E94B17592;
	Tue, 30 Apr 2024 11:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476153; cv=none; b=EY+vUZnqB2zxlIylMdEQoTGuiLOsytjXQFMSbh971dHqy0sBpa5rOdPR+R2rsNx6D3crU/9kXHTclXXGHSX38Y4bwffbIZLvRa8NfFyqoFna3sJWlbirXOnE5P7dV+ltn87kZJ3CaRxiVHGVhTPfM+QDFFSpmSIT3LQvr6uAFMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476153; c=relaxed/simple;
	bh=fgWBIAkIllrPTXsOceRCpjOqxUzNoApWefsIeVkz/iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4Vfrayc9jgi8ck9w56kx2dTlAq7LSWHvJPaKmUfApPCXGkrxsK1nfmdH9OSHxiK+1BPdymZB4pWqaUuyU/Vzaj0pDi/kF4Yj4eZATyQAOIcaF7BwMwqXrExoIXhY8kzetKTI7cDFEgk7VCU+jtNMHFSVTHBual+J3N7uxUZ8WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prXaIeER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prXaIeER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB538C2BBFC;
	Tue, 30 Apr 2024 11:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476153;
	bh=fgWBIAkIllrPTXsOceRCpjOqxUzNoApWefsIeVkz/iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prXaIeERp8cHmvp651TEN22dHss8SMJFYQbrzNh4nOZphORwQdikRZLIGtuUpXZRX
	 2BdI+L7PVaq8It738gXSReCD2t1TKQA45/LaUpiAFNs4RQs+NP6CQ03mADa7+XsF3V
	 VIpxJae6a/yx2L8l3sZNwq7SMX/4D6g4gXfctnNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 051/107] KVM: async_pf: Cleanup kvm_setup_async_pf()
Date: Tue, 30 Apr 2024 12:40:11 +0200
Message-ID: <20240430103046.164175677@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 7863e346e1089b40cac1c7d9098314c405e2e1e3 upstream.

schedule_work() returns 'false' only when the work is already on the queue
and this can't happen as kvm_setup_async_pf() always allocates a new one.
Also, to avoid potential race, it makes sense to to schedule_work() at the
very end after we've added it to the queue.

While on it, do some minor cleanup. gfn_to_pfn_async() mentioned in a
comment does not currently exist and, moreover, we can check
kvm_is_error_hva() at the very beginning, before we try to allocate work so
'retry_sync' label can go away completely.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20200610175532.779793-1-vkuznets@redhat.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/async_pf.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -195,7 +195,9 @@ int kvm_setup_async_pf(struct kvm_vcpu *
 	if (vcpu->async_pf.queued >= ASYNC_PF_PER_VCPU)
 		return 0;
 
-	/* setup delayed work */
+	/* Arch specific code should not do async PF in this case */
+	if (unlikely(kvm_is_error_hva(hva)))
+		return 0;
 
 	/*
 	 * do alloc nowait since if we are going to sleep anyway we
@@ -213,24 +215,15 @@ int kvm_setup_async_pf(struct kvm_vcpu *
 	work->mm = current->mm;
 	mmget(work->mm);
 
-	/* this can't really happen otherwise gfn_to_pfn_async
-	   would succeed */
-	if (unlikely(kvm_is_error_hva(work->addr)))
-		goto retry_sync;
-
 	INIT_WORK(&work->work, async_pf_execute);
-	if (!schedule_work(&work->work))
-		goto retry_sync;
 
 	list_add_tail(&work->queue, &vcpu->async_pf.queue);
 	vcpu->async_pf.queued++;
 	kvm_arch_async_page_not_present(vcpu, work);
+
+	schedule_work(&work->work);
+
 	return 1;
-retry_sync:
-	kvm_put_kvm(work->vcpu->kvm);
-	mmput(work->mm);
-	kmem_cache_free(async_pf_cache, work);
-	return 0;
 }
 
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)


