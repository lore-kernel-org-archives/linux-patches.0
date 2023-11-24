Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4904222F1D;
	Fri, 24 Nov 2023 18:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5JHuY4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E39C433C8;
	Fri, 24 Nov 2023 18:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851961;
	bh=tneHs2QH22Kug9dvVIa/Og3hovJDE63x+jBLHXrHRyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5JHuY4eqJdbb58Dao1ezkQfsno3DMCKmPUrqSGuMSZIliw0VKu0bqdNY6N7T6KYY
	 43eP3rKiqlE2nR1hCl6PnooZH+pjymgqqCGswL7eWqgKEJokJGbPIDP0fV7qar5Mhy
	 CC06upXx48cy3jseQsJhLxTD1TcwVJbMQpKL2GyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/372] xen/events: fix delayed eoi list handling
Date: Fri, 24 Nov 2023 17:48:46 +0000
Message-ID: <20231124172015.119694501@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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
index 80b46de14f413..af9115d648092 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -600,7 +600,9 @@ static void lateeoi_list_add(struct irq_info *info)
 
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



