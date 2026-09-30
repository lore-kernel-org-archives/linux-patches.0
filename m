Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62B94DEC1B;
	Wed, 30 Sep 2026 16:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785748; cv=none; b=hyoMFWNxnpuHXWLz8uAZHI6BZJlWX0Avdpf8aKHKUNMc8myJLhCc2QnnS86d3+/Aio91K6OoQd20g/wfvWlbBVJBhBwVYdXikzbUKvJuxZbuF6sLDL0u4il7p3knfc96KuIe3ga9gPSiMAIT0bXbLFpgchbVVY/ob9Nr+XmjBGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785748; c=relaxed/simple;
	bh=ZeBaTkd0fgXcmMchCGCVHLKbeYUfmqbX9qZy5ubdHnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dicVjrdHvoDl04JW8tS6UHqGYVqQEc9jbCFLSBabSZKTzeJppG6ZkGe8QiMgdn4i8EVd3dugV48MqHVcbCzMHqeY8qd9+7jhFsjuqnFNlOgOitbv8wouXrCkRlAp/RUtDWj8L4qdtiMHdhn47G98ElwYZkGZW66fIv7rLCgcqrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeCP1rNa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeCP1rNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACCC1F00893;
	Wed, 30 Sep 2026 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785747;
	bh=4oOUuXMgf20TFFNICSXJcHRzvEaXRtL3GzKHv0NFAVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GeCP1rNa1bKcFEOa1Uq2TQ6guxG0/Dc9eFcOltP7kJxXSBh/fZHjEocGCE/SRLpOC
	 34Li48CGzmDxpYzkC3gC3nyZLU56aso96Xh9EDp2W9LJGCGlXVNfbNRli+db8LiEKY
	 YpTYcPqJ1oxFWBTsdq0kr1mI1BkKhCtTaiB7cUto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	David Lin <david.lin@intel.com>,
	Shuming Fan <shumingf@realtek.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 618/982] soundwire: cadence_master: wait and cancel cdns->work before clock stop
Date: Wed, 30 Sep 2026 17:22:34 +0200
Message-ID: <20260930152430.050406316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit aba7b41faeecb7692458095ce6fafc341fe0b80e ]

A peripheral event could happen during the clock stop process. We need
to wait for the event be handled before stopping the bus clock.
Otherwise, we will get the IO transfer timed out issue.

Fixes: af4cc917826f ("soundwire: cadence: mask Slave interrupt before stopping clock")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: David Lin <david.lin@intel.com>
Reviewed-by: Shuming Fan <shumingf@realtek.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260901031019.233254-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index 5bd874e58dd6e..149b62df7eef8 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -1585,6 +1585,13 @@ int sdw_cdns_clock_stop(struct sdw_cdns *cdns, bool block_wake)
 		return 0;
 	}
 
+	/*
+	 * wait for any in-flight peripheral event handling to complete before stopping the clock.
+	 * No need to disable peripheral interrupts before canceling the work, as the peripheral
+	 * interrupts are already masked before the work is scheduled.
+	 */
+	cancel_work_sync(&cdns->work);
+
 	/*
 	 * Before entering clock stop we mask the Slave
 	 * interrupts. This helps avoid having to deal with e.g. a
-- 
2.53.0



