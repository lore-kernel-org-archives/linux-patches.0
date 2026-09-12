Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B62C309F08;
	Sat, 12 Sep 2026 15:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228290; cv=none; b=ZcfCOaeAFJoots72H+kt9AFy+/1Sz1/VpXGpAExGslFHCiwQRAVvYZ1+C0RFA3f3n1+5meFcD2lyrFTEae7CY+gVfZdrCztQoNYgPUiB+zXYszIpLSbxj4lbBvgi4tL4xn4i4/Zu+Ru+hVr0qzWo0u7cVtJXQcV9/9sxJXRogOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228290; c=relaxed/simple;
	bh=Zt6mXj/Uq+gJsd56FcBqCNntZkJIYTN8VNGE20qsNtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhlY7KvrVICWPRPvkYuORcHzSzXsqQLfsiVTORDA1T0ERCndexMnFlaIV+rAyEPjNtlWLhSN4tEjXKcsbNsxDHO7KFUjz8ihv+G2rH1LQWISC9v+LyQ7Uj3ytNKWCR7ozVBf8YhhWTv3CIt4VUqLxVSAXjhhEkDlGmlC4cTstbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNylxBfe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNylxBfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC3E1F000FF;
	Sat, 12 Sep 2026 15:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228289;
	bh=wm6MVd8jiM5LrIspZ/2gBdcGQSdjV2wEtPA3LoyaK9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNylxBfeGlv9csdPRB9Y9vKnR82a8n2sr0s6qVS/tlL+tg2ACw+ASC4qpMkQmePNI
	 6Df9zNgFyYvwKUxmvP+qBoJAlmCRsD5gLzKkmZ6fu2e5YBf2YQlHZuN1FoyDRyN9ou
	 4uklSQld+D4JT4ndq4rxsnQoTmzJL7dngJp1hLoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.1 0355/1191] KVM: s390: Fix old_data leak in guest debug error path
Date: Sat, 12 Sep 2026 08:51:23 +0200
Message-ID: <20260912065556.203162622@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit aa9c8e8baf1e765fa65b93212522c636f25d846f upstream.

__import_wp_info() allocates a per-watchpoint old_data buffer to back up
the original guest memory contents. If a later watchpoint of the same
KVM_SET_GUEST_DEBUG request fails to import, kvm_s390_import_bp_data()
jumps to the error label, which frees the wp_info array but not the
old_data buffers of the entries that were imported successfully. Up to
MAX_BP_COUNT - 1 buffers of up to MAX_WP_SIZE bytes are leaked per failed
request, and the request can be repeated.

Create error handling for cleaning up all created old_data memory
areas.

Fixes: 27291e2165b6 ("KVM: s390: hardware support for guest debugging")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260805110455.7200-6-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/guestdbg.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/s390/kvm/guestdbg.c
+++ b/arch/s390/kvm/guestdbg.c
@@ -256,7 +256,7 @@ int kvm_s390_import_bp_data(struct kvm_v
 			ret = __import_wp_info(vcpu, &bp_data[i],
 					       &wp_info[nr_wp]);
 			if (ret)
-				goto error;
+				goto error_wp;
 			nr_wp++;
 			break;
 		case KVM_HW_BP:
@@ -273,6 +273,10 @@ int kvm_s390_import_bp_data(struct kvm_v
 	vcpu->arch.guestdbg.hw_wp_info = wp_info;
 	kfree(bp_data);
 	return 0;
+
+error_wp:
+	while (nr_wp--)
+		kfree(wp_info[nr_wp].old_data);
 error:
 	kfree(bp_data);
 	kfree(wp_info);


