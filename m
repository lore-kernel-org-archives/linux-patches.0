Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081981B395C;
	Mon, 23 Dec 2024 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970311; cv=none; b=VscZbLOPU8Kk9v5kypwrLFvSMujV8SQpmOzkKLiVGV0WRF/3KfYxcFoMVPIWh1Gw6FwZ9ow+YbOQHhm8AxKSD12nFuFpaGgTjA5xBe3C5GXky15k8THh2O6FonPUiExA3nRizUcPmnG1ety6fcnJU9kLbRMjcu/l5Iqi/eFv3bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970311; c=relaxed/simple;
	bh=ioZhWNy86KMV87E3tFyj08L3AGjcohRuzob45fJRlic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sU0HmNZtM+Nmu4lABmoOY+7RZc3NaBU1Kij4YB3ji9yXIAoO4Qkh55BvTp0ncSkHGqKce4yoyjBR3/B7HCW2RZQe4ELpv5d0kUgRD4LiVW4Oxqx97hqzeOJ3H85EQAVTrcP+c204wVnEKfQhEGD2JJFHLTuDxnM+I7cftnjMTtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8IoKhZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8IoKhZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0D5C4CED3;
	Mon, 23 Dec 2024 16:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970310;
	bh=ioZhWNy86KMV87E3tFyj08L3AGjcohRuzob45fJRlic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8IoKhZ6Q/maveT3JBUB8h3PVOuFdRR3MH9SX+fjZZv1A+PSjAe9bOwZvfe6Y9vrv
	 ro2u7ab3uaRnw0boOV0zGd/OqGu9b6OZQyjL6SuD+Z+gg+tTALvf0X8U/g3gCUCZ6j
	 WttjP3w4Cxwq5hsewC9ksR8sO1gWuLz1cHJ4dUL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ea40e4294e58b0292f74@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/116] netdevsim: prevent bad user input in nsim_dev_health_break_write()
Date: Mon, 23 Dec 2024 16:58:36 +0100
Message-ID: <20241223155401.348669640@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ee76746387f6233bdfa93d7406990f923641568f ]

If either a zero count or a large one is provided, kernel can crash.

Fixes: 82c93a87bf8b ("netdevsim: implement couple of testing devlink health reporters")
Reported-by: syzbot+ea40e4294e58b0292f74@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/675c6862.050a0220.37aaf.00b1.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20241213172518.2415666-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/health.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
index eb04ed715d2d..c63427b71898 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -203,6 +203,8 @@ static ssize_t nsim_dev_health_break_write(struct file *file,
 	char *break_msg;
 	int err;
 
+	if (count == 0 || count > PAGE_SIZE)
+		return -EINVAL;
 	break_msg = memdup_user_nul(data, count);
 	if (IS_ERR(break_msg))
 		return PTR_ERR(break_msg);
-- 
2.39.5



