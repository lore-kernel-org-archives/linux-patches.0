Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB36B34DB74;
	Sat, 12 Sep 2026 14:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224306; cv=none; b=hk2oH2ZFzConsOdFz5tcKcfGKMs+YE11pO/7OFQ509Q85/Kup/rt2gytRYJ9DbikJWSoa2NGjEFlcUxCMfjguA1Ol7SQNIVLII006FW+ALT/RhcRIRd8vI9Gh0qW7fOZjD9qNpz3h6N//Xb82vxdktTp6w6p63Ku3e8cCPcZ2Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224306; c=relaxed/simple;
	bh=lMf9Oz9MsjHUUSjGdC7Y/LthaH7p09VncIVzxLps/xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSo207YbqSWYLXT/PfrOuoC8d8iNz0aOj0J5viBtY+o10RWpLtpEbp426tu+Sf6gBbp0vS7L9eDRco1sptQxfsQm9nK73v5al5l8If54tuZMDtkkinpNhKp/r6z+fDP6f/nUk4hJJWFNJvTONpFjNq72yUaIDBqzBkGjZ65jMEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dR2iC7wt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dR2iC7wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB731F000FF;
	Sat, 12 Sep 2026 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224305;
	bh=C2RC0NlGhWpGuFqdCC3ouCzeSdandWePT1Y+ZtugpXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dR2iC7wt/4AczjkeAB3Kx5wkikveqVZcv+cnfBJ5ors/MaUyEBwD5eq1hlYJVMo34
	 qCnVNpOXAusVQDnzTx9kO2qtS4mpwsYZT0KE7mJHxpcFka07xX5NWBddwlK3jFHfEA
	 ka14faNOzQose/VP2bvSJ0clnqe8CjOnNZXOdZ+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0967/1424] misc: vmc_vmci: Fix potential memory leak in vmci_event_subscribe()
Date: Sat, 12 Sep 2026 08:56:39 +0200
Message-ID: <20260912065628.968821737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



