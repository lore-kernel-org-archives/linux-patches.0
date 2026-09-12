Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC40F34D915;
	Sat, 12 Sep 2026 11:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213648; cv=none; b=nzUmLyv6TmP9divPTpNQCfYlLsRrTwue3h3Kn0A5XyaXr6y1luT/Tl7jDxBsDRlHZrt7wNAQKeHR59iM0oVJP0D2Tgshre/Q4ALvoCqmhNWtfkEQ0QcLiwdq3fP2nUzeUqJSFchxnEs0P6AbFM3HMvh4GiLxsoxEoQjEmtGccrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213648; c=relaxed/simple;
	bh=5sRlMF+wcShPJNI7W16kKUSXsAl3r/mv6wjiAsvqQDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eayjSULX09IVVpTmgvv2bSXzQgyy+7BnWQp0NPhTHKVEkN97D3bzlAiXvN1x22bKwZnrvRhi4qnW/SpD1Kpn6pngZQ10ZznFPq0YmUurNfjnLl6eE61bt/AjXU1fsdLvdei8WHnnj6lCGvnv8AtbDG793Z86upcvOexKFYAmBnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIO7XQOf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIO7XQOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE881F00893;
	Sat, 12 Sep 2026 11:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213644;
	bh=z43+FS46dyNfzB0HZccrW9kjmR2lbzSntGjJv4U+NnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NIO7XQOfSW9D42Xw/b7UMV3pa8nS0slJ9Bz0JzFpQmZ6bM59wVs5R4bmzbvklPhm4
	 XBAO6DhrRvLSUPTKDnBYmFBpEO+LnpS0BhUOG+8hLhPMdPk+hFZQkKUDm6ftnaq/YJ
	 TzmUw4G6WkYjYKp1+BNKNwJJHal5SGpvvXXxd/3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.12 0164/1376] KVM: s390: Fix length check __import_wp_info()
Date: Sat, 12 Sep 2026 08:43:10 +0200
Message-ID: <20260912065611.206995148@linuxfoundation.org>
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


