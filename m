Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D880F3A6F0B;
	Sat, 12 Sep 2026 18:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239333; cv=none; b=sMQUI7K34Oh0t1Y2kkc5DK/GbYPkspGXcbpdvHWdWPCOoSCO5ndLPngYX177LgJ3/LcQoCYfL3/0bFF+GHHacZ4XlWBvvKTuFkELJIUIarcAZDluBuh/SDuLv4gaz1jF/owx71rnS+V83WQE/4dkJXFyRVCvqu4EH7za6Ox+0AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239333; c=relaxed/simple;
	bh=5yCRRnZRby6FQ+y9xe9i3hr/arAIaALEc5MIZl7Af8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyqeLJDsOgskJPETWMffa/d3ouCysf6LwefSLFFPRgaQ2Er52j9tDVnJJAfjzqTD3rW+6fv5X9A0yBmZi3XgvJbwujNWQL+6t2+1rW4SCpxTlNbvytMMNBW1HVCMFUoDS6ZrSvZtHRlTSWmpfZt4FVMeHthVhHTF+mp38IAoM0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTUxGhyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTUxGhyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B7F1F000FF;
	Sat, 12 Sep 2026 18:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239331;
	bh=qNsLG6X8q8wZ9dF9p751p6LWlndn80OjWJSq8Mpkvto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTUxGhylStFFTtBBdo/hR90evrK1cWOfBgvTfKj6rDh7Wf35WZ9xXeI5TH7qWQnW+
	 7u66VgKnOU2tIXbjsZPV+MgltE/CDvT2gjUOlw8FKXHINEk08a/NEtIDdwVguUJS5a
	 pyn5gce++4K80C8FmxJfutb2bkOHbKngDOe77X40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 644/935] misc: vmc_vmci: Fix potential memory leak in vmci_event_subscribe()
Date: Sat, 12 Sep 2026 09:01:14 +0200
Message-ID: <20260912065541.613554449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 210854a96ef18b09b45a2a59ff14ca06dfe5ad4d ]

The memory allocated for struct vmci_subscription (sub) is not freed
in the error path when have_new_id is false. Fix that by adding a
kfree() call, and moving the read of sub->id to a point before freeing.

Fixes: 1d990201f9bb ("VMCI: event handling implementation.")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Acked-by: Vishnu Dasa <vishnu.dasa@broadcom.com>
Link: https://patch.msgid.link/20260722101215.76680-1-nihaal@cse.iitm.ac.in
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/vmw_vmci/vmci_event.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_event.c b/drivers/misc/vmw_vmci/vmci_event.c
index 5b7ef47f4c118..a9456c552c2f8 100644
--- a/drivers/misc/vmw_vmci/vmci_event.c
+++ b/drivers/misc/vmw_vmci/vmci_event.c
@@ -179,16 +179,16 @@ int vmci_event_subscribe(u32 event,
 		}
 	}
 
+	*new_subscription_id = sub->id;
 	if (have_new_id) {
 		list_add_rcu(&sub->node, &subscriber_array[event]);
 		retval = VMCI_SUCCESS;
 	} else {
+		kfree(sub);
 		retval = VMCI_ERROR_NO_RESOURCES;
 	}
 
 	mutex_unlock(&subscriber_mutex);
-
-	*new_subscription_id = sub->id;
 	return retval;
 }
 EXPORT_SYMBOL_GPL(vmci_event_subscribe);
-- 
2.53.0



