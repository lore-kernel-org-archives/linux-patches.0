Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D132931DF;
	Wed,  9 Sep 2026 14:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962603; cv=none; b=DGkx7yvjeyRn1GU9O8xaCdQZ7Fkb4GA0V2JO7Oye0oBZHzS+3jq5YXG/T0jjcqMwb+B0xIP/yqKd5xgziPTGyabYZ3jgWrSeVtkIzbKlFdVo1GT1XMaEG3SSN1DU5X2lrgMbkQV0sTTZ1b14rnBmbyFjAhkK+QHJpNerkh4HyLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962603; c=relaxed/simple;
	bh=biDcJKGb7+MKppUBjJfdWGTckHy06M1rqgZRk1wYNWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noYbahtdbiTy96YLtYV1R9G3mbVsdR/pkj5DCZ5ZFB0dgWMdgqoUD4MA25TUgFWrl+ZUvESS9ZBmxkSZMv4FU9WmkBo6m6z7Km3cmxx48EcG9ILJEffPcmw+D8eG7SIGmsOhHgFZ15kSDhNQYPero1IHkM5Tgm4FBAkTw/lW6Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2fSwUbA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2fSwUbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDAC1F00A3A;
	Wed,  9 Sep 2026 14:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962602;
	bh=BTiuNSCciHXaVmIurO23r3LA0tGT1ccPJ7cjuBSPtD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R2fSwUbAH+bOfDZyCg0M5ATsuCP2OgsKY1B29ZEfeYnpGaNziYUkcoMlcWtd5rYA/
	 RNX2DDH4Ly+uR9tQiZxRI5jqxvURDvqiBQTxBYwXY6lpmd77A9t3jXSrPBVbon0tET
	 V9ONKQspPwOsSA1XKHEPKFjdAUrISZX5PBls/0zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 7.2 303/556] KVM: s390: Fix length check __import_wp_info()
Date: Wed,  9 Sep 2026 15:39:43 +0200
Message-ID: <20260909134241.337097256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


