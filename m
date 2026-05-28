Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0A232ABC0;
	Thu, 28 May 2026 20:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998622; cv=none; b=VFo3nBfAxT0bD1E1KjHvh5G+sOqOhsYW3SIsNTJBmIeYuOBmegzZ/kofY5Ae7rogyJoQATHfNeIUkc67cEBKq3p3f3V5/hqidyEqEvGfJclLlKvopeQMAKkbnvtp5vAugR9KosHZ00O03+7DhpvyH4j8khqXRrqMp6exg8Zk/NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998622; c=relaxed/simple;
	bh=ggF5aHqQo3+pNc3p98CbUNiUAEycqr8gi2QHwgzmbwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lS8a0EYfL7OCppsRPTi0zAJw7hw/RgN5xVBzfqn2sl6RfGV9j7OsFFofu4VABHvF6vzoIH/UlvctDxzWjM6LrOvL28MlG4kaP7vbwSaqKyidHfHqPoZlapYontvE9I79R4VFaD12ar7wLQody/mnapf7VWf6qCcvRF8mBQ0vccQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXl5PB8Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXl5PB8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4721F000E9;
	Thu, 28 May 2026 20:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998620;
	bh=QskPk+mT7TzqErStvwyEb/BoELZZD0RWSDmohHWywTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXl5PB8Q472sJ1PzTq3why3NGXYnNx1ZzT6o9uhvmJWG2gCGQfj3q/LRxhsFC25SD
	 2dO7hybaDa/II7mJefzJ3hC2fGOhUnTR2qGhA3NUTblUmOjYr8o2KetUBk3TUxsUFY
	 jORqBZY+k2qMMlZD+Ge4a3LQs2LIuFendjyl3Imo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 202/461] firmware: arm_ffa: Fix sched-recv callback partition lookup
Date: Thu, 28 May 2026 21:45:31 +0200
Message-ID: <20260528194652.936315250@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit a6848a50404eefb6f0b131c21881a2d8d21b31a9 ]

ffa_sched_recv_cb_update() used list_for_each_entry_safe() to search for
a matching partition and then tested the iterator against NULL. That is
not a valid end-of-list check for circular lists and can fall through
with an invalid pointer. Use a normal iterator and detect the not-found
case correctly before touching the partition state.

Fixes: be61da938576 ("firmware: arm_ffa: Allow multiple UUIDs per partition to register SRI callback")
Link: https://patch.msgid.link/20260428-ffa_fixes-v2-11-8595ae450034@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index aa6b9d52a673f..e0263c3fad70b 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1207,7 +1207,7 @@ static int
 ffa_sched_recv_cb_update(struct ffa_device *dev, ffa_sched_recv_cb callback,
 			 void *cb_data, bool is_registration)
 {
-	struct ffa_dev_part_info *partition = NULL, *tmp;
+	struct ffa_dev_part_info *partition = NULL;
 	struct list_head *phead;
 	bool cb_valid;
 
@@ -1220,11 +1220,11 @@ ffa_sched_recv_cb_update(struct ffa_device *dev, ffa_sched_recv_cb callback,
 		return -EINVAL;
 	}
 
-	list_for_each_entry_safe(partition, tmp, phead, node)
+	list_for_each_entry(partition, phead, node)
 		if (partition->dev == dev)
 			break;
 
-	if (!partition) {
+	if (&partition->node == phead) {
 		pr_err("%s: No such partition ID 0x%x\n", __func__, dev->vm_id);
 		return -EINVAL;
 	}
-- 
2.53.0



