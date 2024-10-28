Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E048F18DF68;
	Mon, 28 Oct 2024 06:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097600; cv=none; b=dTdYVCX9iqelz5I7LxQOyuq0hBr+2g8OaTqZYT2mRA5/QBIPs3ENfiLUZgn78PHiKvGGyP8ZMvwBbE3eOx8O24FG5IbZJ9wYnOwX8gEJNKpf7u7mjtB6lveoKu/bImgBUke3vt8OjRhtMQPcFRP3PDRhMZg+ACqjHpUW8dDWZCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097600; c=relaxed/simple;
	bh=js6IpsfXmfW55lfxrc8XU0K27GGjIDJCTwGZHxvt84k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CW8lktq47jyDp8hIdldMXIcJH5jPVzERjlHQ7Rw8oWR5qnWvHmSvr9KiFN5ZUS5te5aszrmg+xpQ7wTQuiD+D2mgLqJCeY0HKqUVgXl2RRs5mNzx8N6bocESymAGwqPq92/fYziPzp8bR5/Bqnj+cRBvGfP4wnhfta64+Q35O6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6uSz0LY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6uSz0LY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822BAC4CEC3;
	Mon, 28 Oct 2024 06:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097599;
	bh=js6IpsfXmfW55lfxrc8XU0K27GGjIDJCTwGZHxvt84k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6uSz0LYgrfddgAQh2ueiVT6i4SjzAQs3Wypmo7IBpJgMzpIyPYXChyPlNCyV8CCE
	 r6GrhMp0MpGmBzjdORLtF6SchrPv784LjgVO5BzrNOi7K/WhxIlGcViPOuQO5WMIQ4
	 cq9gCKIdAgYpdBUq9UoznQodN2xEMeXrfnEDoJH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/208] firmware: arm_scmi: Fix the double free in scmi_debugfs_common_setup()
Date: Mon, 28 Oct 2024 07:23:28 +0100
Message-ID: <20241028062307.349276373@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 39b13dce1a91cdfc3bec9238f9e89094551bd428 ]

Clang static checker(scan-build) throws below warning：
  |  drivers/firmware/arm_scmi/driver.c:line 2915, column 2
  |        Attempt to free released memory.

When devm_add_action_or_reset() fails, scmi_debugfs_common_cleanup()
will run twice which causes double free of 'dbg->name'.

Remove the redundant scmi_debugfs_common_cleanup() to fix this problem.

Fixes: c3d4aed763ce ("firmware: arm_scmi: Populate a common SCMI debugfs root")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Message-Id: <20241011104001.1546476-1-suhui@nfschina.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 87383c05424bd..3962683e2af9d 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2603,10 +2603,8 @@ static struct scmi_debug_info *scmi_debugfs_common_setup(struct scmi_info *info)
 	dbg->top_dentry = top_dentry;
 
 	if (devm_add_action_or_reset(info->dev,
-				     scmi_debugfs_common_cleanup, dbg)) {
-		scmi_debugfs_common_cleanup(dbg);
+				     scmi_debugfs_common_cleanup, dbg))
 		return NULL;
-	}
 
 	return dbg;
 }
-- 
2.43.0



