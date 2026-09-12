Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48122AD37;
	Sat, 12 Sep 2026 10:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208955; cv=none; b=S5JP0DovLCWzx3vO1QvJczke9VkNKC6A0e+jxft0mYkq1aH7tM2tkzBK+09eT6VRHHj+DjpPSLOVRKtWKnfdXBwftq3H7GxcvHs0I+bO82X1MWmhRfSymhO0QYRTFYQqj9GYkh5I3ABHzaDhJofrWyuN7zqfw+RxEtUt2eJFHa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208955; c=relaxed/simple;
	bh=A/YPk3qgC13enNbK5kQjNk3UJWhYvsjtKNsh/JINQwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgoxarrLUo/nu7XgSGGKnDs8+JP9rFB99OtJjNULVETQmBcUQ1nareuRoldP2ajhYQSKxGZcux7q/EIB+S2kUkm0R1YqwsHXdFDaxI9/41Z2KlUhw2lG86oJ/N0ITjekxC0YIrrh0D8iuyEqC0d9rZk93bjy4Ofpb3kNu3lOnVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YwoFUvh7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YwoFUvh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D969F1F000FF;
	Sat, 12 Sep 2026 10:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208954;
	bh=+bu9Zwnes1thqaLoOHaQheFp99dIk30Y7ZmHiWgZn/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YwoFUvh7wIPcTyUDWkzRudSZ26YXVJt+Q7xWyDvbqi+RCUt8p7wimNNbYLIt/0RJq
	 9X8c35PUWEtciG+C4j0MERWKaWpEfECx4ktFmfgrtd9lz76h6m/cvNtxRDn0plhqks
	 +FmVtOpxU4aDJFLMKkwC72i7HQQ7N2USUK3mus5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0722/1518] misc: vmc_vmci: Fix potential memory leak in vmci_event_subscribe()
Date: Sat, 12 Sep 2026 08:48:11 +0200
Message-ID: <20260912065639.768320751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 9a41ab65378de..89ab9f05b88c5 100644
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



