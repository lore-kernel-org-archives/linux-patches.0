Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7371F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1CFC433C7;
	Tue,  1 Aug 2023 09:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881945;
	bh=rHV3MVF4p6VUHmx14rKFTV8YgX3IjC8b74A1KC5MZDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcNukxQCZ8WDx2bkwpd7MGGw8CIAsMscthzd8AgFaCCIfShrc5wBVJjeawyezoNnG
	 iCE4DJMn25XIidC8keOW5bcPQIGuJMvyEus0V3ypKhOD3gkHQ2kr6pXr6bPtrI0ooc
	 ql1iXxrLE+ZdI2uKkNtGih3LCN8g/YDd2UgtCF8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/155] iavf: fix potential deadlock on allocation failure
Date: Tue,  1 Aug 2023 11:19:28 +0200
Message-ID: <20230801091912.194484448@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit a2f054c10bef0b54600ec9cb776508443e941343 ]

In iavf_adminq_task(), if kzalloc() fails to allocate the event.msg_buf,
the function will exit without releasing the adapter->crit_lock.

This is unlikely, but if it happens, the next access to that mutex will
deadlock.

Fix this by moving the unlock to the end of the function, and adding a new
label to allow jumping to the unlock portion of the function exit flow.

Fixes: fc2e6b3b132a ("iavf: Rework mutexes for better synchronisation")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index bcceb2ddfea63..1e349a90d21aa 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2546,7 +2546,7 @@ static void iavf_adminq_task(struct work_struct *work)
 	event.buf_len = IAVF_MAX_AQ_BUF_SIZE;
 	event.msg_buf = kzalloc(event.buf_len, GFP_KERNEL);
 	if (!event.msg_buf)
-		goto out;
+		goto unlock;
 
 	do {
 		ret = iavf_clean_arq_element(hw, &event, &pending);
@@ -2561,7 +2561,6 @@ static void iavf_adminq_task(struct work_struct *work)
 		if (pending != 0)
 			memset(event.msg_buf, 0, IAVF_MAX_AQ_BUF_SIZE);
 	} while (pending);
-	mutex_unlock(&adapter->crit_lock);
 
 	if ((adapter->flags & IAVF_FLAG_SETUP_NETDEV_FEATURES)) {
 		if (adapter->netdev_registered ||
@@ -2619,6 +2618,8 @@ static void iavf_adminq_task(struct work_struct *work)
 
 freedom:
 	kfree(event.msg_buf);
+unlock:
+	mutex_unlock(&adapter->crit_lock);
 out:
 	/* re-enable Admin queue interrupt cause */
 	iavf_misc_irq_enable(adapter);
-- 
2.39.2



