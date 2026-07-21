Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0752D2DF3EA;
	Tue, 21 Jul 2026 18:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659188; cv=none; b=c8OEGHxocQ6C7aJE6sXt4r+LRRxhWVzM0QHKC519B04vX+7rF3fkicWyCA5DoJMo6MqXMibR+rUWXBC6ck3gliYNg3fG3Yw4zYnJqXcdSuVhcHJ0ccOePTD4G+HcS5cU5ZGfaK7ldRLFQCDwafnV4+oCJeNq9cCYhUa6QS/wGvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659188; c=relaxed/simple;
	bh=eViTTtVxZMQhQIklUzQzP2EbFLtrHq8wvQezXF+Rc/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eky95mBUVRIEfGkJJMCDzx6IeuvhF2OJem7/XrboODhta5kGlkf3A2ZS54DlH1ZXAJsnLrPDvP4r52tLb4PGgofixgb8LyiyDYg8MnErZu38MS+nSm2+CW1l+tsaGIYuw5m+yMksbAGPG8DO0Dy/RGPik699HLZWv41on962KTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gu7N+KDT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gu7N+KDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C9A1F000E9;
	Tue, 21 Jul 2026 18:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659186;
	bh=FuC2AE0kYe2W7gi57l48TjxY84prTp+fqOenHhHPkr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gu7N+KDTvR1qoKymJJgm8DOcgd9ch2xTrttLADF66FnCvnYq88ujAJWZanT8Ba7We
	 Xoo7BvFKHiyvFhi/MDnVnr2xXIxgN/mWX+gQZfkENq00ZhNA/nuZXBuLj7m5bX49FH
	 PzRJ72X6+CYEd0xJIsmK2A/QJg+YTH2Qyqt6EHNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.18 1425/1611] ipmi: Fix user refcount underflow in event delivery
Date: Tue, 21 Jul 2026 17:25:41 +0200
Message-ID: <20260721152547.489051865@linuxfoundation.org>
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
@@ -4475,10 +4475,8 @@ static int handle_read_event_rsp(struct
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


