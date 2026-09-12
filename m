Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A04369990;
	Sat, 12 Sep 2026 08:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200758; cv=none; b=HuG3Syt8MOHJ9QlJNp1ITHFrMJ1w1UFwJbygQnY4cysc1QYfMBp1SJdcB3w5sM+4X/W1jxMAsK0+8NG/9N7SBsUU20mfV+jyjYb59RU8WXEQrzrDGwJPWzmguohKGQFh1cs1BcYlytPQ7MklKYw9Kcg9PmLp+Z1jArJQNh8fnWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200758; c=relaxed/simple;
	bh=yRlg9jaRNCifc7Opr/NEOH8HaKL1fES7xnmR3hiIo5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qO9lzyODF3v8HdKe3B2jlEAtXntFyMTxIjA75YSZR+hQfW/59bUX58+aytUEfDs38SnAr+hTpIKdJBos8HrOLOQCXp7X+gPe2EwCrvSmd7b3nwKmYNoDSlg2dUM+h2ECS69BlbFqgPN6t/DH46FAZGHwx2mUmz69/p2qeOma85M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3TMKLlN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3TMKLlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DC11F000FF;
	Sat, 12 Sep 2026 08:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200756;
	bh=ZD2AITlCbxcin+Zw/b7wB79t2yjs/mfDcdFfGk+AAoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X3TMKLlNSfBQDlxjhd3SbK7YPTkOWWeJRYQmc4u5MXbttVq5EwLHMWTeYm572T+RW
	 1swMezuTSQvJSpJuaBlGquSwQYsUyrQZBSPy9lgrxTx/fD0g6tVBaiFu2d4RE7SCWJ
	 As5wa8gias01Wzqb9NRonwzq+oOWHyvBesgwIJzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0855/1815] misc: vmc_vmci: Fix potential memory leak in vmci_event_subscribe()
Date: Sat, 12 Sep 2026 08:43:25 +0200
Message-ID: <20260912065708.994003993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index fffe068a26eb4..c3ef3b98c432e 100644
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



