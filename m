Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A2816F8FA;
	Wed,  3 Jul 2024 11:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005556; cv=none; b=YKt94wGH6A8gpW/nz9zh8R8twyTXyJ1FiUIzKpzAnjxDXnm+UNvycFzzzVwPSD1wgg5l+4tSUHGNxphO56Omu797TqcVv+ptFUf1asqjLg/tosw/spuUJAFpQ7jr4AzwcqHV8/JG/Zzz/jpYw6jnbOSwqGzoASGEtHS6bm1vmew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005556; c=relaxed/simple;
	bh=iTU6oMYQTJ4CZa+RrgNCaNFXCAm5/ij/HptE6Rssalw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYL8mWnaWn48QaS6U+R95ATvkVpb/nXr6JKk6IdKJ3rfB1at9H1mWXSEICULuhyLiD6vnPGvGaHH258UncOm60RY6CoE+s6DqRgMrqhlAZigF3NcCOh468Zk/LxxtlfM1elzy8iB5yOMY9iUe7/4+Wigyc8ZLHNXOsNEpcORoqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZS3e33Rq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZS3e33Rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C967C2BD10;
	Wed,  3 Jul 2024 11:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005556;
	bh=iTU6oMYQTJ4CZa+RrgNCaNFXCAm5/ij/HptE6Rssalw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZS3e33RqT/sc5+jznrjSBgNjyLk0Y0cMusKYr4+7CfdXGChr+dR99tW+xPTc6XnK+
	 lHSg1Fk3eIWJ/t9OS0wMNFiVQmJtClIMSAdqxLX/+lJr0qce1808WakWkEdbzMMrks
	 x9mm2WOAqKGv8PGHwLdkY1KmBOTsNFVYhTq1/Jho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hagar Gamal Halim Hemdan <hagarhem@amazon.com>
Subject: [PATCH 5.15 121/356] vmci: prevent speculation leaks by sanitizing event in event_deliver()
Date: Wed,  3 Jul 2024 12:37:37 +0200
Message-ID: <20240703102917.672385787@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


