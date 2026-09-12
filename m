Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C362F37F316;
	Sat, 12 Sep 2026 19:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241395; cv=none; b=QoDuhMy91DltU/4NP17p0e57+Tj2vMYvnNkWxvNePC6F4c7IJqipiMJbYiq9yNa+TUfY1U3T9usyyJhKrWqBylMUHO8oEPuKHaVPmO9gYY0ZFblslZzOwCHSXJIaG3gAb3tNzqOdlI7/Q6u3vAUPs8bDjFGhColSwvldHwgzvKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241395; c=relaxed/simple;
	bh=GBuDG9eAURj4VpNl/+Gh5QgPFI6g43gZx0OHwVhaouA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTY7UklAubN6wvRFbBn9kggtYJyWMFk63OwPZ8iscslpthEzk8TPZ0+bUVVvy7v+2Kf99vAcDi0rA/QH+caO1rtY5J2wAaALGH6p+lof0B4pKijG9Q8hY44wpFKt8Uwri+XijTVwXT1v5pF29nsCVyd2EJGxW8gCTSZPPn8hGjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RU0J+tD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RU0J+tD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2A71F000FF;
	Sat, 12 Sep 2026 19:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241394;
	bh=/LDr4Yh5a/62DrBq0/qijjfIcDD1WgBcwImDICMX8fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2RU0J+tD0QNPBRPSmnLPNgy50JUtVP67PAS9DcipDjKXDPfKb+8YK7An3M/9bPZJ8
	 gfbhBzQE80HVRCIz/wWo5zCHYApoUtHJv8WinWPshhoyulBR0Z2PX4S/1KQLFo/sO4
	 NaizbDDlMwjenq0G5qmuvIS/Czy2G7nRH9CXAPR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.10 127/798] nvme: nvme-fc: Fix nvme_fc_create_hw_io_queues() queue deletion in error path
Date: Sat, 12 Sep 2026 08:55:55 +0200
Message-ID: <20260912065519.886458114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ewan D. Milne <emilne@redhat.com>

commit 22eb631bf86ee3246f47885e4fa94154a46863e4 upstream.

nvme_fc_create_hw_io_queues() will call __nvme_fc_delete_hw_queue() for the
last queue on which __nvme_fc_create_hw_queue() reported an error when deleting
all the io queues if they cannot all be created.  This is incorrect since the
last queue did not actually get created.

The most recent change to this code was commit 17a1ec08ce70 ("nvme/fc: simplify
error handling of nvme_fc_create_hw_io_queues") which moved the cleanup to the
delete_queues: label and changed the loop bounds, however the code was not
correct prior to this change in a different way.  The original commit
e399441de911 ("nvme-fabrics: Add host support for FC transport") had a
different error which called __nvme_fc_delete_hw_queue() on queue index 0 which
is used for the admin queue.

Fix this by correcting the initial loop index when deleting the io queues.

Fixes: 17a1ec08ce70 ("nvme/fc: simplify error handling of nvme_fc_create_hw_io_queues")
Fixes: e399441de911 ("nvme-fabrics: Add host support for FC transport")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2325,7 +2325,7 @@ nvme_fc_create_hw_io_queues(struct nvme_
 	return 0;
 
 delete_queues:
-	for (; i > 0; i--)
+	for (--i; i > 0; i--)
 		__nvme_fc_delete_hw_queue(ctrl, &ctrl->queues[i], i);
 	return ret;
 }


