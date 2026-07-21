Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914AB46D09E;
	Tue, 21 Jul 2026 17:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655365; cv=none; b=jMw3Va5rXy4CLsT0z2BJIIumm/XEzb8KWiRbKhoUlOHwvODYlM0GKteLdFVQkDKVqByr44vjXIKUdnw+9I+nUIr8ww4Lhk92Tyd1gadqbtW3aHhfv8zKYSpsC6sjtj+J9YupsCYdg/oG2usCfdJMfLgPGlYwTI61hljlmVvZ5w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655365; c=relaxed/simple;
	bh=TSDcSR++U6mUU3P90tvKYX2mlYa8f4ZCSDlyiv/F0L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STmKZ3BUN0YGrR35rgOcwRrQfJmD8LmGfV/cL9IJYzyzysAUoVnVMBCVbF9akZD7BLMH+o5pa7SOpVUkimhHRbl18OrHDg9dZUF2vIro2MOj6xOn3GslJnAtnEuaDRlakXjHxihy6YX1nYtXm/i/sw8SKYowNZlfa4Ray1diZZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWekKzeu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWekKzeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0411B1F000E9;
	Tue, 21 Jul 2026 17:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655364;
	bh=LyfTD21C7v4Uf4SiguKcryPY0S/XfCBkWjvpcyAoVI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWekKzeu2NfsRyIqVB66InzuEtf7JSE9F4Mr7Sgwqtcp72KxfaUrtZanoQZeS8T8H
	 ZLu3gAt9IyoJ5PELzUHnC0VGWz2msQhDB+XgtJaTF3Mt929UVteh0bpkFnWqPhjikL
	 2BrDNeUgRPrNogdO5P1HH7CXs6Rm2try9p6XU92Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 2056/2077] binder: Use LIST_HEAD() to initialize on stack list head
Date: Tue, 21 Jul 2026 17:28:49 +0200
Message-ID: <20260721152641.194816261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


