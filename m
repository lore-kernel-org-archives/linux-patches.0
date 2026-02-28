Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9138D33F8A1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300946; cv=none; b=puF1UXMHwJBL2drbVoreZA2SxR+UPYboL3sX50VQn5vKZbtsPYieHlP9lLikRPgrZettOwk93FCRr5rbfBPmS19TkDzMK7vJM4GyTqExk9Ra0he0N1HoieMzyvgXLtQPdJCQ+miZS+j6fq2xthBUpbCnReUPllqT7W592LBxPnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300946; c=relaxed/simple;
	bh=yL/3J+Kc+ufBQbQo8CUEsiiz0KXUEBwUey7O3oZpMAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZ8uShv49+cOopLsG04w/4xnirDWqs2I7+NG7HMwDNyrmWeCmInTmPoLupGleI+5cRpUzrkEaadhOeTRdL58Di7rIhEXDPUGy4tRRMly5aaWOeTSMDeSPq8V9bjku6QgPs0z6XEPerOhGAicA0Y5NBZP3nCQVx/+yvpQmNylGQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rrw1725I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rrw1725I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00351C116D0;
	Sat, 28 Feb 2026 17:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300946;
	bh=yL/3J+Kc+ufBQbQo8CUEsiiz0KXUEBwUey7O3oZpMAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rrw1725IuNzn1eUJGsCdTSqWkKztlKsmMavY4213VHEr6oTxzxedU51ZOAJ7VQCdO
	 XYhhpoKT5J056OT5vOYsy0BlHYfmXXOGOeB/QduqTnxnFIcyABVDUGgsbP7twcjifb
	 YxikewcRAJudN5F+6RiTtWw7cTwBR35uxfonp1peAr5TCpcTnR/40NUX9ZJ60/hUb1
	 LEc8q21ogGTVBk9i70sEHgcaDbp2PIQ2IE66J5P5jLSmaauRt5cJGmKU4S1GBgI43S
	 rS/35ZveXVbnlBdhIl/VoxOiIb7I7t84C6VwhuiHYuHt2K3pTOXBCmPy73Zey4I+93
	 jyrK4/erWzAGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/752] xenbus: Use .freeze/.thaw to handle xenbus devices
Date: Sat, 28 Feb 2026 12:36:20 -0500
Message-ID: <20260228174750.1542406-69-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jason Andryuk <jason.andryuk@amd.com>

[ Upstream commit e08dd1ee49838750a514e83c0aa60cd12ba6ecbb ]

The goal is to fix s2idle and S3 for Xen PV devices.  A domain resuming
from s3 or s2idle disconnects its PV devices during resume.  The
backends are not expecting this and do not reconnect.

b3e96c0c7562 ("xen: use freeze/restore/thaw PM events for suspend/
resume/chkpt") changed xen_suspend()/do_suspend() from
PMSG_SUSPEND/PMSG_RESUME to PMSG_FREEZE/PMSG_THAW/PMSG_RESTORE, but the
suspend/resume callbacks remained.

.freeze/restore are used with hiberation where Linux restarts in a new
place in the future.  .suspend/resume are useful for runtime power
management for the duration of a boot.

The current behavior of the callbacks works for an xl save/restore or
live migration where the domain is restored/migrated to a new location
and connecting to a not-already-connected backend.

Change xenbus_pm_ops to use .freeze/thaw/restore and drop the
.suspend/resume hook.  This matches the use in drivers/xen/manage.c for
save/restore and live migration.  With .suspend/resume empty, PV devices
are left connected during s2idle and s3, so PV devices are not changed
and work after resume.

Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Acked-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20251119224731.61497-2-jason.andryuk@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_probe_frontend.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
index 6d1819269cbe5..199917b6f77ca 100644
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -148,11 +148,9 @@ static void xenbus_frontend_dev_shutdown(struct device *_dev)
 }
 
 static const struct dev_pm_ops xenbus_pm_ops = {
-	.suspend	= xenbus_dev_suspend,
-	.resume		= xenbus_frontend_dev_resume,
 	.freeze		= xenbus_dev_suspend,
 	.thaw		= xenbus_dev_cancel,
-	.restore	= xenbus_dev_resume,
+	.restore	= xenbus_frontend_dev_resume,
 };
 
 static struct xen_bus_type xenbus_frontend = {
-- 
2.51.0

