Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5D232B125;
	Sat, 12 Sep 2026 16:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230431; cv=none; b=haBXeeS2zFaaLws7pBJcsBJX8kQSaWFUOazIAVL6mLSQ9WChESZboGHg1MUdm/MSJKT+hbh+pMaJWlVWXj3j7UJdNLEzuQ9YVMjF8Yl1wGRULx0H0AL8vLOYoKxxlN8v93vl8fMHWOj7X1e7Cz4fwyqtqeqDxPpo0gYeEe2fb1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230431; c=relaxed/simple;
	bh=Mq/rcQW/Fc+7yD+0O0UUowX30D2RL0RzdoDm1Ky8QV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJUKdvKqzCHn3SdoS1ICsaxeA0cTKmiNc9e1b+j+/GfsTshJTd1BDNAjXsuZHaUaepq7UGv/A4i/YED4lSFafcoUdkglW3tqY/Em3ZkMXl+r9ixKjAtoQ2xg1jxMOUEiUhLfHbFAbH7i+MkKmUZVHathA+s4T3M/zzHxzjAGMrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLRrdHku; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLRrdHku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB591F000FF;
	Sat, 12 Sep 2026 16:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230429;
	bh=S85L4MVRrKrkDzp9+RmA0V9jWJxGZSBNIAvWD3Kg810=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLRrdHkuKjItehG0Fj9CraANrwxeUxf2lC3dHtDE2XY+Lew2i7vOgpACef5U0jIFS
	 Y9Q3VMKkCswqhCqbfZEZfabhvVusFL3hps2uou1l+GJoJowfLvhgxujI+bCwt5CodF
	 kmI5uSASP/xgPXbcgYbWNAs6xeVFbHhLP+2a7r5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0793/1191] misc: vmc_vmci: Fix potential memory leak in vmci_event_subscribe()
Date: Sat, 12 Sep 2026 08:58:41 +0200
Message-ID: <20260912065606.085140725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a1205bce0b7ee..5c35874671783 100644
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



