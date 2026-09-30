Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED5F50C2A4;
	Wed, 30 Sep 2026 17:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788225; cv=none; b=Ak3wxvhZuFBxY8vtDe8gbzcRMLXSLh2I/pofE2J/D+NqI0jyGFcJaPrLnUChRAUSe3bCg7ZNnJbK3kHsI1xj04zVthUjLPWPJnD7BJ33z40WnLGBRWS6pkuxsoKXRPguGbOIHkwkVwmtJL8TvFu7DQkovjGLQQda5S7sqpE67qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788225; c=relaxed/simple;
	bh=S8fpWCZI14FrR0y+XchnNhNfm3wesz/s9H3uwE6Mwpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixbyWemhtCQAnnMK2VU8BKxXsBhAhbbZNA3pjEinyK9yIH9F/ZulBIiXg7tKzM/XuuEwTr8+FXIPQTKCCf3VtWX8RFysBUHM33Q/HaHAzGzRmcIcDR3ej+tpWWy4VEVU2UG5aQ0H3df4fK5El4Ls8D0/CkxwO5M9TcOYDHe79Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8ZMW95J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8ZMW95J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087B71F000FF;
	Wed, 30 Sep 2026 17:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788223;
	bh=HWjAkt3SysL5iMv8bJ/ivUGZxpxl5Fas0H77lEONkVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8ZMW95J917YBtX9cv75EPdrCzvT23QvNTT9bpwTRZC6nAPJk75yKk+yRZJPqIqWq
	 RKZ7IL2udRPGNSSf/ClJ9VrzdPD/Nxx3zXeq7iP2/2wk+X5rgxJA1Wa9bc/+GScd4/
	 bSyULWL5GHd3TkwViBOZ5qpbDvbp4slta4va+Qxs=
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
Subject: [PATCH 6.12 048/877] soundwire: cadence_master: wait and cancel cdns->work before clock stop
Date: Wed, 30 Sep 2026 17:15:59 +0200
Message-ID: <20260930152415.785392661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a503ef606a62c..1557d6b044491 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -1670,6 +1670,13 @@ int sdw_cdns_clock_stop(struct sdw_cdns *cdns, bool block_wake)
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



