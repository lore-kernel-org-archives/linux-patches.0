Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EA722CBF1;
	Mon, 10 Mar 2025 17:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627772; cv=none; b=CoByChe4/02BXsTwsMy62pfRqozhtdgkxqdF+cgo/gOWnQ8UaqJ4wt4UbAcPpx1lo34md2HKYtn68QYkZgwWq6QEZmmCF2Vq5zHyIl3KiGuBYXb/xEoTIIzJzmrtkamynWrwr/JaTup5/80YoHonC+ObYwpd75ubWlyJ0TiEwBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627772; c=relaxed/simple;
	bh=xkmjvycN8455oS2TxFK7cZ7gl5QFt+XyQgwtZNoYTjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbXnEbjO2yC8MrEdFBjti7HsDLqA+0N65/jOfAzclWlyCIJzor/YUSLzFZN+nMlH7u6xpY4gcGRJkPpSlC1MJ/Txoa7WxtnNd0sniC0SZVtCh424p8iu3ieZQx/Bveg02vsGSIHVuyi/uk7WfQAumJxhMWUKhkxaXCLCZbENe9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CzSO1wW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CzSO1wW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20362C4CEE5;
	Mon, 10 Mar 2025 17:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627772;
	bh=xkmjvycN8455oS2TxFK7cZ7gl5QFt+XyQgwtZNoYTjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CzSO1wW9dPtTRS90T3BuPBCAhAFC0Gqr5qjsOkVKDY9HJ23w7QKHg9Q4EluW/+iu5
	 apzWN+whxgzYl+2SCkl5B+FWQkv82gqT1MocL/I9I1A1FaUtVQ+OJrRGoZK66akWVS
	 iZEMgZW26+y6S5m6q4JdBy8KCMzlpdfkveKg+C8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.12 243/269] char: misc: deallocate static minor in error path
Date: Mon, 10 Mar 2025 18:06:36 +0100
Message-ID: <20250310170507.482853230@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

commit 6d991f569c5ef6eaeadf1238df2c36e3975233ad upstream.

When creating sysfs files fail, the allocated minor must be freed such that
it can be later reused. That is specially harmful for static minor numbers,
since those would always fail to register later on.

Fixes: 6d04d2b554b1 ("misc: misc_minor_alloc to use ida for all dynamic/misc dynamic minors")
Cc: stable <stable@kernel.org>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://lore.kernel.org/r/20250123123249.4081674-5-cascardo@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -264,8 +264,8 @@ int misc_register(struct miscdevice *mis
 		device_create_with_groups(&misc_class, misc->parent, dev,
 					  misc, misc->groups, "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
+		misc_minor_free(misc->minor);
 		if (is_dynamic) {
-			misc_minor_free(misc->minor);
 			misc->minor = MISC_DYNAMIC_MINOR;
 		}
 		err = PTR_ERR(misc->this_device);


