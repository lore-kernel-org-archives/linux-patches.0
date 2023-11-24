Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323BD39FF8;
	Fri, 24 Nov 2023 18:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHdifpCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3427C433C8;
	Fri, 24 Nov 2023 18:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849479;
	bh=QlBXBM1aye9cLlXQ9D/X/UGJtigVVNCfdoByxP612sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHdifpCizyA6rrVRzNB0xGIKr/AcogjnGe+MGOdev2BHUvI6lDd45kumHsiadrtaD
	 0KgR4tXQkYNAJlNTT6OhkIbXvkF/grVs0adt9qP2UFvcdXROSylggxqZ/az1TMBiz+
	 icurgBct+GtL46AL8CUqJjHkV70nUXrpa5bisLk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 198/530] xen/events: fix delayed eoi list handling
Date: Fri, 24 Nov 2023 17:46:04 +0000
Message-ID: <20231124172034.094042925@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 47d970204054f859f35a2237baa75c2d84fcf436 ]

When delaying eoi handling of events, the related elements are queued
into the percpu lateeoi list. In case the list isn't empty, the
elements should be sorted by the time when eoi handling is to happen.

Unfortunately a new element will never be queued at the start of the
list, even if it has a handling time lower than all other list
elements.

Fix that by handling that case the same way as for an empty list.

Fixes: e99502f76271 ("xen/events: defer eoi in case of excessive number of events")
Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/events/events_base.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 2cf0c2b693861..c50419638ac0a 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -604,7 +604,9 @@ static void lateeoi_list_add(struct irq_info *info)
 
 	spin_lock_irqsave(&eoi->eoi_list_lock, flags);
 
-	if (list_empty(&eoi->eoi_list)) {
+	elem = list_first_entry_or_null(&eoi->eoi_list, struct irq_info,
+					eoi_list);
+	if (!elem || info->eoi_time < elem->eoi_time) {
 		list_add(&info->eoi_list, &eoi->eoi_list);
 		mod_delayed_work_on(info->eoi_cpu, system_wq,
 				    &eoi->delayed, delay);
-- 
2.42.0



