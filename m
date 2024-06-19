Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C460A13DDC0;
	Wed, 19 Jun 2024 13:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804095; cv=none; b=AyF1ZyQCG5rZ1pPOpSO3S3ugASVzh8XgKx1IusrFXyLwW5DJ8TUcDSU0V2RYVDNhydvZbO2UwEXYWny7xNHDvqDz18AHJ5CNbagMudJEjIZ4fArroCR8Ox8x0nJ9BEAPgQnS7xiwXnbDsQilfspgS7dEpOGdAcBExFUs3pnRM7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804095; c=relaxed/simple;
	bh=RCgMBelj5qNMBcy7+PoozlNX7PcOlAeeJ5fjgig+UOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tELpg6mKefI8ArFbiijuUXRTenudmWLpHws7WXIWfdmQW/AEXjvl/Z5GuR5j3KupwU+7TO/fxRj306GZwzywvTDeKKdHZ18xPkAF4EE5/Uj08y/KCBZPD7bW+ZgFP0A9MX2Sg4FgzWakx3mD/y8zKjac89xl0EhfZZ+0aWl+4GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cL36vKQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cL36vKQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466FCC2BBFC;
	Wed, 19 Jun 2024 13:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804095;
	bh=RCgMBelj5qNMBcy7+PoozlNX7PcOlAeeJ5fjgig+UOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cL36vKQCpChSwu+JF14V29pFSs28tyUVdv5aMpC8Nna/dPE4Hlj62J/HiNVrm0ASh
	 1FVmrFc3L9jfZEXnh6OzHD1w0ziB0Aw7DnPeST7TcShn5lZqmrXw6/A6bR2SkATeNe
	 CyWYV63WzzJ1cnhNMVwaswMjUqFRakffS0XoYTN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hagar Gamal Halim Hemdan <hagarhem@amazon.com>
Subject: [PATCH 6.1 176/217] vmci: prevent speculation leaks by sanitizing event in event_deliver()
Date: Wed, 19 Jun 2024 14:56:59 +0200
Message-ID: <20240619125603.478680273@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9,6 +9,7 @@
 #include <linux/vmw_vmci_api.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/nospec.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/rculist.h>
@@ -86,9 +87,12 @@ static void event_deliver(struct vmci_ev
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


