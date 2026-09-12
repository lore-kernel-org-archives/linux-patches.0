Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766183491C9;
	Sat, 12 Sep 2026 18:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237664; cv=none; b=GVUoyrwnxua6EtX5fjfQEAk4pesHBTnOjNGgljUBzmu3Pi97RQ/8L4enEqBWYx5UfqPm+xyGWpGjG9GlkHMAg1gKcA9bV/eBGGXVymUTxq8w6b5+8bd6INhy1rOPzWcSBdNJa0NEm4topd7+Zl0Ox6ooUfvuZ8sW0dI+HnYBwgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237664; c=relaxed/simple;
	bh=M9HLh9nBQ9VFRk5KQ0O31vh4cMCqR/KPGtLq2OgtjZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8UGCZAXc7rU6Ef8OUE+zdu1jbEDezGDZmlfyrBwZ22xWDCC4Hc5GBOoc0MwA6J14w3ifpsddqRihTHXGeGwPDUnJYjUYlbSaJr1znp9j8+gavYdxTrOy0sp7bzDnpW6SzLghYPLGN6TQfB5FtVmyGFqcULQlXrV5i1xRDt6fQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wn/pjbCv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wn/pjbCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178A71F000FF;
	Sat, 12 Sep 2026 18:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237663;
	bh=mgp2nVIEFnOyRDG3+jqSx/p/bpWwM4bs5oLEJMJ5/Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wn/pjbCvQ5tXwbNljzXk8yHUxMsVzELb7cOAFZSe5mqw47lCJVZUdYpp4rV+Yaff5
	 4yw+0pj2Hp/D32vQ6gWF+j9W/GI3vBYnD+BTOxFmhg/8EsPAyjWKqCEah8pKuOXSGU
	 3WKGiVIo4VAr/xIX/vr7OZ8MJ2Rv+2KFmMmwFhX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 5.15 302/935] KVM: s390: Fix length check __import_wp_info()
Date: Sat, 12 Sep 2026 08:55:32 +0200
Message-ID: <20260912065533.736900947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit 4c07680a467e2f7697245bcd11691bffb2a6f0ed upstream.

struct kvm_hw_breakpoint::len is a __u64 that is fully controlled by user
space. This is then assigned to wp_info->len, which is an int. The bounds
check is done on the truncated value while the allocation uses the
untruncated one:

	wp_info->len = bp_data->len;
	[...]
	if (wp_info->len < 0 || wp_info->len > MAX_WP_SIZE)
		return -EINVAL;

	wp_info->old_data = kmalloc(bp_data->len, GFP_KERNEL_ACCOUNT);

Use the validated value for the allocation as intended. Without this
fix userspace can trigger >4GB allocations which will fail and result
in a WARN due to MAX_PAGE_ORDER.

Fixes: 27291e2165b6 ("KVM: s390: hardware support for guest debugging")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260805110455.7200-9-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/guestdbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kvm/guestdbg.c
+++ b/arch/s390/kvm/guestdbg.c
@@ -184,7 +184,7 @@ static int __import_wp_info(struct kvm_v
 	if (wp_info->len < 0 || wp_info->len > MAX_WP_SIZE)
 		return -EINVAL;
 
-	wp_info->old_data = kmalloc(bp_data->len, GFP_KERNEL_ACCOUNT);
+	wp_info->old_data = kmalloc(wp_info->len, GFP_KERNEL_ACCOUNT);
 	if (!wp_info->old_data)
 		return -ENOMEM;
 	/* try to backup the original value */


