Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E7E173335;
	Wed,  3 Jul 2024 10:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003429; cv=none; b=njmdy1V+XNYbWd7IxMX/Kt4fXo719zd8yUAHDoUGjN/hedp3SFWJJVO5ge1lJfYxeO6kx56VnEt067TvQu6qQD2PkOz5TvFBXegQ/svIdHRnuXJPeJbQd9m/lkSxeO/ELDiDjLg9TVh8w1BkYQSaz4g29CxOJEX1PMX5/nL7PuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003429; c=relaxed/simple;
	bh=ru0iQNEqC5AiccLMUg5gun+LhY8CZxqnauZNqMw2bEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWJt4s4DFi8g6jk7wF9bdAUQBFArmmfOOo2d3XBbOq1JlnguXY6YArAc6Qkx/zkKO6je/POTIUrrCv+iypK0GiwSjPywxsZkxzqt/WClxL4ZwwVekdhOiZ26rgWyc/H8eoGWoqXcsPUzHQR+ilEPxONGy8D55dAmENG+khfSiIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jsm3LpxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jsm3LpxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080C4C2BD10;
	Wed,  3 Jul 2024 10:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003429;
	bh=ru0iQNEqC5AiccLMUg5gun+LhY8CZxqnauZNqMw2bEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jsm3LpxVpwfdriAVKup2Tzt3vrLRIstwRi/yx6lNGDtu97k4ekv25Ci16mvDeiFm7
	 8B5PH+iMRY9m6QNr4gst60U27V+jT+RnydSlDwELE/1+MISp1to9nwx+EI9cojDHkz
	 lN796lpq0eg6H3iEYmH/nd9x8fCkbKcRkgAT5Ydk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hagar Gamal Halim Hemdan <hagarhem@amazon.com>
Subject: [PATCH 4.19 046/139] vmci: prevent speculation leaks by sanitizing event in event_deliver()
Date: Wed,  3 Jul 2024 12:39:03 +0200
Message-ID: <20240703102832.176096465@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hagar Gamal Halim Hemdan <hagarhem@amazon.com>

commit 8003f00d895310d409b2bf9ef907c56b42a4e0f4 upstream.

Coverity spotted that event_msg is controlled by user-space,
event_msg->event_data.event is passed to event_deliver() and used
as an index without sanitization.

This change ensures that the event index is sanitized to mitigate any
possibility of speculative information leaks.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Only compile tested, no access to HW.

Fixes: 1d990201f9bb ("VMCI: event handling implementation.")
Cc: stable <stable@kernel.org>
Signed-off-by: Hagar Gamal Halim Hemdan <hagarhem@amazon.com>
Link: https://lore.kernel.org/stable/20231127193533.46174-1-hagarhem%40amazon.com
Link: https://lore.kernel.org/r/20240430085916.4753-1-hagarhem@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/vmw_vmci/vmci_event.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/misc/vmw_vmci/vmci_event.c
+++ b/drivers/misc/vmw_vmci/vmci_event.c
@@ -17,6 +17,7 @@
 #include <linux/vmw_vmci_api.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/nospec.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/rculist.h>
@@ -94,9 +95,12 @@ static void event_deliver(struct vmci_ev
 {
 	struct vmci_subscription *cur;
 	struct list_head *subscriber_list;
+	u32 sanitized_event, max_vmci_event;
 
 	rcu_read_lock();
-	subscriber_list = &subscriber_array[event_msg->event_data.event];
+	max_vmci_event = ARRAY_SIZE(subscriber_array);
+	sanitized_event = array_index_nospec(event_msg->event_data.event, max_vmci_event);
+	subscriber_list = &subscriber_array[sanitized_event];
 	list_for_each_entry_rcu(cur, subscriber_list, node) {
 		cur->callback(cur->id, &event_msg->event_data,
 			      cur->callback_data);


