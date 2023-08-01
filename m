Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B2A1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3CEC433C8;
	Tue,  1 Aug 2023 09:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883041;
	bh=Irz36TBrvqhmPQCU/glQw/kKYdz7mRCL0tJmOEteYLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1fbNH0RTk4O0zrXl1l8ZswBjAdRddfZQewaDBOkt6aXagzozT4Ps/XouhBDjdcMV
	 9VC64/4Ub3f7eWpEFy+e7TVjcjPw0LrkWL60Ez875+VbgCAuBJIQRJyV4Th+is2TpX
	 H+YhQA30pYvL7QDVFHTU8KHg2z7fej4eu+/gG8nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 065/239] iavf: check for removal state before IAVF_FLAG_PF_COMMS_FAILED
Date: Tue,  1 Aug 2023 11:18:49 +0200
Message-ID: <20230801091928.006965674@linuxfoundation.org>
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

[ Upstream commit 91896c8acce23d33ed078cffd46a9534b1f82be5 ]

In iavf_adminq_task(), if the function can't acquire the
adapter->crit_lock, it checks if the driver is removing. If so, it simply
exits without re-enabling the interrupt. This is done to ensure that the
task stops processing as soon as possible once the driver is being removed.

However, if the IAVF_FLAG_PF_COMMS_FAILED is set, the function checks this
before attempting to acquire the lock. In this case, the function exits
early and re-enables the interrupt. This will happen even if the driver is
already removing.

Avoid this, by moving the check to after the adapter->crit_lock is
acquired. This way, if the driver is removing, we will not re-enable the
interrupt.

Fixes: fc2e6b3b132a ("iavf: Rework mutexes for better synchronisation")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 6c25d240e70bc..e48810e0627d2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3286,9 +3286,6 @@ static void iavf_adminq_task(struct work_struct *work)
 	u32 val, oldval;
 	u16 pending;
 
-	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
-		goto out;
-
 	if (!mutex_trylock(&adapter->crit_lock)) {
 		if (adapter->state == __IAVF_REMOVE)
 			return;
@@ -3297,6 +3294,9 @@ static void iavf_adminq_task(struct work_struct *work)
 		goto out;
 	}
 
+	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
+		goto unlock;
+
 	event.buf_len = IAVF_MAX_AQ_BUF_SIZE;
 	event.msg_buf = kzalloc(event.buf_len, GFP_KERNEL);
 	if (!event.msg_buf)
-- 
2.39.2



