Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFF930DEA3;
	Sat, 12 Sep 2026 14:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221685; cv=none; b=NEnXMIHd6T9a5PGnY05Fw/R/VID8KwpSA6wInpnVxxLkZ89YEmJTU0A1R0TnC6f50hQRlwSYpg687m2qwGyyIh10Gm/Z8653a2LDyMuUu8Fugw+iqJmO89ImJHLkzeUZJj4MM2FOxAJXNQQZYktNmKAjxbjPv5IeDGIplDKIYdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221685; c=relaxed/simple;
	bh=/ZSjhAsTdN8SZolPNLtkTwmX3/py/g57+RrFj8xx+xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oU/1nloQozQ9sZBDbTHyt5O3o1n15XpsZa2VC65htW+R9fR4nBnNUEl8mHZ7b2UGHRzUIu/Jf6687H9pXsP5JEyDoVFR56EQ+KOLMKJOFHzDhgKXnkAMjwZL9vvG1NeFomE8b8WkenqAeYxAOaEM4rnrGWL9tjPBPdHwxAz51lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ov/n5hHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ov/n5hHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BC51F000FF;
	Sat, 12 Sep 2026 14:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221684;
	bh=H6JlQkoKDZ/MnRhkOYPm3RsAge1ZqHXoA7veZYp12cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ov/n5hHFXqPkmM6N6R299uytzCJqmgVPj+EcU2KWJmC+xw99XqY6i5VYgjchpe1yj
	 idoWwSwCUIJvPh5Hc29n/WBbCtDuUvFAknPPxCmOUiTYBSJMxvzCVL/Bh/To1m/A3b
	 9cE0wXlYMDR1VvFQBwt142cDOVSVhlB1p2dt3scI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.6 0431/1424] KVM: s390: Fix length check __import_wp_info()
Date: Sat, 12 Sep 2026 08:47:43 +0200
Message-ID: <20260912065616.935787599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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


