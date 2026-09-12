Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0382927FB37;
	Sat, 12 Sep 2026 16:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230136; cv=none; b=tA8pS400yvKtPoC387tqt2tEoZOw7eIWTyQ35rxNDY/Rpreq+Yr55m7RZjGfpbY8GjBvZxSNmcq0Rf2rbLNyoaE49o+bvIzyoJwjO3TbDDU+iTXP3LvHv2WPD3FYfP6lM6TcVDAti5eZbSKO9vqnzdEr0CygfXuVZGSVOxysWcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230136; c=relaxed/simple;
	bh=kbAqXI+H15wr7M1vMz20HYuAmUDFze4PUwDUQ5QjiN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=En/D57A4ZNPBP3vOzk9Z1Vii2MYHhItS9fYg2su/XpI5dCus+v9ox3OJKLi2g5K/WiiP3veL4oyx58524foygwKmu/Rahdk8L9yJmXKaqlVY8cWcCgUPrGPb1oB8+qqhZZY9JqilDHxMmyehZIe0A591glXU/LuK8d2UOsWfAFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3HRD0SO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3HRD0SO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F001F000FF;
	Sat, 12 Sep 2026 16:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230134;
	bh=cXziOI4mFluRl+7GsTmXnCOcDYJ8wlPoAEEogGbc0+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3HRD0SOPu+AS5C7cBA3MZi5B3ziyPM6QMb8Aqj+FBQggKXuOgzl9qi/zskUhKyCz
	 CGEmxyJGHEKTzyvrnRj9DRrHDbMNsHH4e1KHPYIyy9/qrD/dm6MSTNHIew61fSSPCm
	 wM2TGOP1SUejM78hXPSvoQZJCQIX5RAPpdtNz8fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0730/1191] remoteproc: Allow shutdown of crashed processors
Date: Sat, 12 Sep 2026 08:57:38 +0200
Message-ID: <20260912065604.677225485@linuxfoundation.org>
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

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit 2482ca875ef5993df8daee563033d70e2523a25f ]

rproc_shutdown() rejects a remoteproc in RPROC_CRASHED state, and
rproc_del() ignores that error. The result of these two decisions is
that a user cannot stop a remoteproc that with recovery disabled that
has entered a crash state, and removal of an associated remoteproc
driver will release resources without first stopping the remoteproc.

Allow rproc_shutdown() to stop crashed processors. Propagate the crash
state to subdevice teardown, to allow subdevices to dismantle things
appropriately.

Assisted-by: OpenCode:GPT-5.5
Fixes: 5e6a0e05270e ("remoteproc: core: Move state checking to remoteproc_core")
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260723-rproc-rmmod-not-crashing-v1-1-546dfd5de0e6@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 277637a57c766..b5c481274011d 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1987,6 +1987,7 @@ EXPORT_SYMBOL(rproc_boot);
 int rproc_shutdown(struct rproc *rproc)
 {
 	struct device *dev = &rproc->dev;
+	bool crashed;
 	int ret;
 
 	ret = mutex_lock_interruptible(&rproc->lock);
@@ -1996,16 +1997,18 @@ int rproc_shutdown(struct rproc *rproc)
 	}
 
 	if (rproc->state != RPROC_RUNNING &&
-	    rproc->state != RPROC_ATTACHED) {
+	    rproc->state != RPROC_ATTACHED &&
+	    rproc->state != RPROC_CRASHED) {
 		ret = -EINVAL;
 		goto out;
 	}
+	crashed = rproc->state == RPROC_CRASHED;
 
 	/* if the remote proc is still needed, bail out */
 	if (!atomic_dec_and_test(&rproc->power))
 		goto out;
 
-	ret = rproc_stop(rproc, false);
+	ret = rproc_stop(rproc, crashed);
 	if (ret) {
 		atomic_inc(&rproc->power);
 		goto out;
-- 
2.53.0



