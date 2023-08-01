Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F3E1F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDFDC433C7;
	Tue,  1 Aug 2023 09:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883038;
	bh=ayWGq/45E8IlQD7a+uCQlhVOhAK3GKm4ap5vuUBnl1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OoDq1VXwc09Sz/5cdLw1YM7BQy5RmLayYvdkV/rIGvhcGdu7dlzhmey3xhfK8+dnh
	 qxlyUYZTYsmBaqK0ht7VEDYvEKI0B1LYcJwpjEaB9oNtYGxJMRI0EqihZBM9E72+5+
	 Kk0Ls7EznjRNiPE7+yo+y3PNYYubgQUS0TvWBucc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 064/239] iavf: fix potential deadlock on allocation failure
Date: Tue,  1 Aug 2023 11:18:48 +0200
Message-ID: <20230801091927.975379940@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
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
index ba96312feb505..6c25d240e70bc 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3300,7 +3300,7 @@ static void iavf_adminq_task(struct work_struct *work)
 	event.buf_len = IAVF_MAX_AQ_BUF_SIZE;
 	event.msg_buf = kzalloc(event.buf_len, GFP_KERNEL);
 	if (!event.msg_buf)
-		goto out;
+		goto unlock;
 
 	do {
 		ret = iavf_clean_arq_element(hw, &event, &pending);
@@ -3315,7 +3315,6 @@ static void iavf_adminq_task(struct work_struct *work)
 		if (pending != 0)
 			memset(event.msg_buf, 0, IAVF_MAX_AQ_BUF_SIZE);
 	} while (pending);
-	mutex_unlock(&adapter->crit_lock);
 
 	if (iavf_is_reset_in_progress(adapter))
 		goto freedom;
@@ -3359,6 +3358,8 @@ static void iavf_adminq_task(struct work_struct *work)
 
 freedom:
 	kfree(event.msg_buf);
+unlock:
+	mutex_unlock(&adapter->crit_lock);
 out:
 	/* re-enable Admin queue interrupt cause */
 	iavf_misc_irq_enable(adapter);
-- 
2.39.2



