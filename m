Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047EF1C689C;
	Tue, 27 Aug 2024 14:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770433; cv=none; b=Vd2acXbHdsOWZGc5bFWZssEBVyMMmEXR4LWAzjzlesYDShmB1JgIwvOG/t5soxeMjG7olKK/QhGK+vlrqBF2BoxOhrLYpZ4cvc11HIg1V5O6WrViW0ybcgQnB6GaXfS4pfVkudiAzyEl4j1a4yRhsT5E/b1dUl1TZnJDh2RjDe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770433; c=relaxed/simple;
	bh=AT8mImdo2bcwmBp8PnsJpQWmfXMFUmNj0Va0wmWvm/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8Xkn/2RahTZks3USiOXTn3YIv+r/ru1129JCTUqQbbvjr+qG3GqaTovZNWbjKPnQRtLiizPIA3XMyzPmQTX42yZWTOGdlRRME4ggq5cx1TPNLJnSyxJ4t4QEN3vgfoPn4I535fErtwSXGob6WTJ4OwY/SwrPSYEQBqWFPiftf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/rIFWdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/rIFWdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD48C6106F;
	Tue, 27 Aug 2024 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770432;
	bh=AT8mImdo2bcwmBp8PnsJpQWmfXMFUmNj0Va0wmWvm/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/rIFWdUt8QLzkRc4n423/8dab87trzQkcIQyfnyhJpJrfV4+AMU35rF+3qqkdfWG
	 q7eyaNHnv1BuO1MlF+btzmEheba4/BxuvYDkjXpsrAXYPsuWpUUCo2dCvKAL22n/hS
	 M/IrdZJ6B+3Ur/tWFmAi9Q9OTkLT9IzZWurugopo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 220/341] nvme: fix namespace removal list
Date: Tue, 27 Aug 2024 16:37:31 +0200
Message-ID: <20240827143851.783259751@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit ff0ffe5b7c3c12c6e0cca16652905963ae817b44 ]

This function wants to move a subset of a list from one element to the
tail into another list. It also needs to use the srcu synchronize
instead of the regular rcu version. Do this one element at a time
because that's the only to do it.

Fixes: be647e2c76b27f4 ("nvme: use srcu for iterating namespace list")
Reported-by: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2a1b555406dff..82509f3679373 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3810,12 +3810,13 @@ static void nvme_remove_invalid_namespaces(struct nvme_ctrl *ctrl,
 
 	mutex_lock(&ctrl->namespaces_lock);
 	list_for_each_entry_safe(ns, next, &ctrl->namespaces, list) {
-		if (ns->head->ns_id > nsid)
-			list_splice_init_rcu(&ns->list, &rm_list,
-					     synchronize_rcu);
+		if (ns->head->ns_id > nsid) {
+			list_del_rcu(&ns->list);
+			synchronize_srcu(&ctrl->srcu);
+			list_add_tail_rcu(&ns->list, &rm_list);
+		}
 	}
 	mutex_unlock(&ctrl->namespaces_lock);
-	synchronize_srcu(&ctrl->srcu);
 
 	list_for_each_entry_safe(ns, next, &rm_list, list)
 		nvme_ns_remove(ns);
-- 
2.43.0



