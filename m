Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D255E471264;
	Tue, 21 Jul 2026 18:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659461; cv=none; b=dpXh8cv5E10gZgVTljfpm3UktTO8UxMkfXrXXN6bNevZrgM+ssQIqf1NMMCLfltoHHJtdPRpTOlMge5pyZJlw+2do1AThGn1qOtkdfqOat5yXKrbRCF7WFjqfhC1oKyf0yHR7zV2i7OAot5wkj9rJwPKeCFse9tTq+Ikmb8lcTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659461; c=relaxed/simple;
	bh=8VMwcXn2QYinqigv/yx5vq6iUOUSx83QbIucCswPsAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MR9+KAGgBo3qkDkGHMRjcfQUB9RkiPPr2a7TPM5921bhCXH92hpRzAEVXXGv8Q8CsdEcs0XF412AQjl0HEF+OToBtQYbZ9vh9XGIyyAWNUJTeAXEctcNBu1kswxQcIgl1MlTRT61vYBCelDDcdwld4gRP0mahi2CGmtLGqbN0Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7q3a8Lg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7q3a8Lg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4380D1F00A3F;
	Tue, 21 Jul 2026 18:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659459;
	bh=rjnP+p2BA7WCLzK9oNoTYtA61TeqhJN0n1h6xJ7xApE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7q3a8LgVa85mpC0IWk/2PyL5F4YdA7LAI8W1+NwVq+kVmIVHz7GqaG2gx3B9hk58
	 oZJ2SYMJXlwyByshfxEfKP5zQj4l/6J7aPNOzyk0tAYvCIM9gOuaGyzZqIP8fAFF8A
	 zAEWFrvJ/UQRMarj/wGO1H0qwIjpYhs/mQSMT9oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1527/1611] binder: Use LIST_HEAD() to initialize on stack list head
Date: Tue, 21 Jul 2026 17:27:23 +0200
Message-ID: <20260721152549.793189173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 91f818b184b44b105b1c92859ea8d2d6f47912a9 ]

Use LIST_HEAD to initialize on stack list head. No intentional
functional impact.

Change generated with below coccinelle script:

@@
identifier name;
@@
- struct list_head name;
+ LIST_HEAD(name);
... when != name
- INIT_LIST_HEAD(&name);

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://patch.msgid.link/20260519055623.13142-1-jszhang@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b34826e55aad ("binder: cache secctx size before release zeroes it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3097,12 +3097,10 @@ static void binder_transaction(struct bi
 	int t_debug_id = atomic_inc_return(&binder_last_id);
 	ktime_t t_start_time = ktime_get();
 	struct lsm_context lsmctx = { };
-	struct list_head sgc_head;
-	struct list_head pf_head;
+	LIST_HEAD(sgc_head);
+	LIST_HEAD(pf_head);
 	const void __user *user_buffer = (const void __user *)
 				(uintptr_t)tr->data.ptr.buffer;
-	INIT_LIST_HEAD(&sgc_head);
-	INIT_LIST_HEAD(&pf_head);
 
 	e = binder_transaction_log_add(&binder_transaction_log);
 	e->debug_id = t_debug_id;


