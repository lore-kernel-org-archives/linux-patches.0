Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2094246C4D1;
	Tue, 21 Jul 2026 17:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655157; cv=none; b=VhEUDNNE2Owo67bz2t5cNmcG0q9BxVMvkjfiVtK22ZiyzjDf0ApNUgRFlnMFGNgZm2UXs99VRhH7kT5CUziWm0bvQgrP8bRbqQIA9Oj8Z5QClLNC9O3hZzstmbT9x5flsETR6NWDZ1rjyfNxOj9CpQRu01jFdQ/Kt0V75OB4rbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655157; c=relaxed/simple;
	bh=KSuO/hf5SCLRJMJvQPBr1Vj01WvdF3Cax1i3KrLICRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XK5OA0KNioF6BkvhD/HQ7nbkz84qsH9p31gaomfrhPqssYuFbWyyyawfx7LoIqjujKMP1wmW80dzZitQnHtqKO8AZ6ofTKplmdADhCzNRjp1bKnl0vLaELVSizUARjEezGA5WcxwPBVA1d8uDF/Lx58cj7X0W3gpR6XB6eFoPMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1Aly2rs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1Aly2rs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866B61F000E9;
	Tue, 21 Jul 2026 17:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655156;
	bh=lIt4dTlxUB2TezJerCdYyWcQA+e7D0ekYoyT+gfHS7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z1Aly2rsBNPq4hUTehAbNW7s6NWCIwwGcoz5KDrD2Jp2Dr96WJ6SebFwLUbOIpbbN
	 xk85zBSMkCS5IM4+bC0h923k3+OYuVc0kQHssD0//B2/QZupUuXz1m1/tDbNTi5L+k
	 RCzP2T+gY0V3UFvfn07uHqiZ3kipo+PW5+7S2Zao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 7.1 1940/2077] ipmi: Fix user refcount underflow in event delivery
Date: Tue, 21 Jul 2026 17:26:53 +0200
Message-ID: <20260721152638.465308600@linuxfoundation.org>
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

From: Matt Fleming <mfleming@cloudflare.com>

commit 6aa9e61c46465d231e9beddf56af7effd71be682 upstream.

ipmi_alloc_recv_msg(user) takes the temporary user reference owned by the
receive message, and ipmi_free_recv_msg() drops it again. If event delivery
fails after allocating receive messages for earlier users,
handle_read_event_rsp() rolls those messages back with
ipmi_free_recv_msg().

That rollback path still drops user->refcount explicitly after freeing each
message. The extra put can free a user that remains linked on intf->users,
so later event delivery may dereference a freed user or trip refcount_t's
addition-on-zero warning when ipmi_alloc_recv_msg() tries to acquire
another reference.

Remove the stale explicit put and the now-dead user assignment. Keep the
list_del() and ipmi_free_recv_msg() calls; they are the required rollback
operations.

Fixes: b52da4054ee0 ("ipmi: Rework user message limit handling")
Cc: stable@vger.kernel.org # v6.18+
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Message-ID: <20260521130628.3641050-1-matt@readmodwrite.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -4477,10 +4477,8 @@ static int handle_read_event_rsp(struct
 			mutex_unlock(&intf->users_mutex);
 			list_for_each_entry_safe(recv_msg, recv_msg2, &msgs,
 						 link) {
-				user = recv_msg->user;
 				list_del(&recv_msg->link);
 				ipmi_free_recv_msg(recv_msg);
-				kref_put(&user->refcount, free_ipmi_user);
 			}
 			/*
 			 * We couldn't allocate memory for the


