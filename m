Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0463A9017;
	Sat, 12 Sep 2026 07:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199966; cv=none; b=KKMkdO1zvSY0hu5vA4jDJ8JRXPTE0UgeFe5h42TxATbgwmgUCnSJKIn3tAx3VCg/QWuoF8q0cCqz01C8k8mYap/GQmCb8k2vdLtbHWLnvUr1nBgQWQnIj7T0NDZ+wClctZmn4ggbsgdQGI03woSqeIFFUpfjUG6Ag0Q4IE7besY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199966; c=relaxed/simple;
	bh=lHIAb/H+KKMadkWT0rTaKDvQKHdiGlvnYT31NA2/znY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WB5ibqNWIVieh72010aa8kJVaI+Lu+oTR/cNMpYuiac8gp9/jpV7bEtWvybnYvthlDD3Ev2x9dXrEhBdmqqgzYUHXQrK1Du28tGk5asVZFxE2SCPj66W8611uvi+WdHmp/bw0aAm2EBgw/B4anbb/py9Yu70GhTWmAmgCCzq5D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YA/O7vET; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YA/O7vET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3231F000FF;
	Sat, 12 Sep 2026 07:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199965;
	bh=EpAps48o/RgnME4Wo7WoMx1GtT7cLyuHM8Y/eCK0ehQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YA/O7vETuPHAO7H+ELvuiYdMCd7oXRNhJs4Cx1ryJeKP2DoQP217ZCMU0m+OUfrqz
	 pIJ+eiXoKXijT04XFbwx/vggsySuvlo5AnQTBFDgn9Qr19LcGmM8hkrb0BtvCQzq91
	 NhWUprqcbjkrBM+9lgowziU96J+JZijwaIWrpWwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0694/1815] remoteproc: Allow shutdown of crashed processors
Date: Sat, 12 Sep 2026 08:40:44 +0200
Message-ID: <20260912065705.182237446@linuxfoundation.org>
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
index f003be006b1bf..aaef4f310a2d5 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1979,6 +1979,7 @@ EXPORT_SYMBOL(rproc_boot);
 int rproc_shutdown(struct rproc *rproc)
 {
 	struct device *dev = &rproc->dev;
+	bool crashed;
 	int ret;
 
 	ret = mutex_lock_interruptible(&rproc->lock);
@@ -1988,16 +1989,18 @@ int rproc_shutdown(struct rproc *rproc)
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



