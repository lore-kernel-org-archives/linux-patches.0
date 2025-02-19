Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EB51C548C;
	Wed, 19 Feb 2025 08:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954669; cv=none; b=dkDWkXJC0DGMso9cUMLdW55TX74VF9AEA/y7EUFkScq+1Tv2mvKyxw5Sz5KvEpn2dQvVJqJzhk3jEoXzALbHOAnUGypRAFoVbZXM2Bh7I6PYIlXNNfopTr6OgIH7B1rSFpKWZZ0tZSB5eIQqKVAPkYgIC6fiL81v3pgavmvxS7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954669; c=relaxed/simple;
	bh=d1vQ0GtEf9Urr/StispSXZ0fbaO5e2W52Sniai5F10k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uw1F/UJhVrBpHBv9Afoe6A6rugowLz+T+p6H2ApzqO5YXXoTURJqgS7fnyg3XGavj6JgurmhbzaJTdx6mnHI9CWk2VJ+R5YoBKvbs5xvCHX1ZZudfRYvRTJ04LKgA8bFAXZKJvuZYVUDJpludxW79rc+u5Fon//kfD3BMDIZJg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1K21MBDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1K21MBDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0221AC4CED1;
	Wed, 19 Feb 2025 08:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954669;
	bh=d1vQ0GtEf9Urr/StispSXZ0fbaO5e2W52Sniai5F10k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1K21MBDHdy3IlOm1qiO6eEVUrJ8pGrHe97RSFeEMcxnN/R1RPSt672lF8IHhmcekX
	 82SXMvCCGP1NKzjDg7+FVRKbyY/MxZo2uM4HoKPLhgikNlXhh/Fe0GnRb4P09kePXG
	 TTYmhza5lkZd0VlFL3f6+VIST5hYcV6rJWS3Sl1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 244/274] iavf: Fix a locking bug in an error path
Date: Wed, 19 Feb 2025 09:28:18 +0100
Message-ID: <20250219082619.127595356@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e589adf5b70c07b1ab974d077046fdbf583b2f36 ]

If the netdev lock has been obtained, unlock it before returning.
This bug has been detected by the Clang thread-safety analyzer.

Fixes: afc664987ab3 ("eth: iavf: extend the netdev_lock usage")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20250206175114.1974171-28-bvanassche@acm.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 4639f55a17be1..37904e2de30bd 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2903,8 +2903,8 @@ static void iavf_watchdog_task(struct work_struct *work)
 	}
 
 	mutex_unlock(&adapter->crit_lock);
-	netdev_unlock(netdev);
 restart_watchdog:
+	netdev_unlock(netdev);
 	if (adapter->state >= __IAVF_DOWN)
 		queue_work(adapter->wq, &adapter->adminq_task);
 	if (adapter->aq_required)
-- 
2.39.5



