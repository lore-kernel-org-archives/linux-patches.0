Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68672374E60;
	Sat, 17 Oct 2026 17:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258267; cv=none; b=rOJvtTlfuxK+7Yrube7YxT3TrJ/d+WCNPGQs1Fg6qanP/7+7lbDfOCrjo2RrCIKEeEmVz7N0Z9Spgt23ArobFpKIFU+8BbKuTMGCE8oajR59vTfKu+S1NG9lwt0M4aICRbfJpaClbDO7BhXHJHmkYGCBhWls7hUhYm3COHRjUeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258267; c=relaxed/simple;
	bh=jDsoeizQPdOu2407Zw+MHXTjf4oVn4MGDWkpMnJtww0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeHDQldrncujZNb8M5dZ6nQl3jDM2hQ5lIhTxDIz29adU0SjMvVnU4HFu3r7Eex3T9/L0URvkXu/wRFSfWOj5wvr6miZotFcDENj9NUT//LJ5qAZ101BSpLAoSM3a5GPH8OWjWpHXzx1rFf0N14YtfDI2s6Ti3ygb3Zdc7EVE1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHZVLMIz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHZVLMIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24171F000C4;
	Sat, 17 Oct 2026 17:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258265;
	bh=BFLyWswKz5jWThxxBvMrIpn1gUZsWiqtDBUeQwaOl3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHZVLMIzl1l2DaJKMqVWgibSkt9hN98LdNxD2rH5umzZYKKuJRVdhRlKKDExS8kkD
	 hYdXRyoQAU7Im+Rfa7k8GySFq///tqeVd/jeBRglI/SfQsf9Ziv/gNYLB4ES9XJK5C
	 D5Z3H/bN/qT6Ig45a1bsOJLr5QDZOQhkl/v0e65s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0826/1674] scsi: imm: Fix use-after-free bug caused by unfinished delayed work
Date: Sat, 17 Oct 2026 17:51:38 +0200
Message-ID: <20261017160452.331694702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit ab58153ec64fa3fc9aea09ca09dc9322e0b54a7c ]

The delayed work item 'imm_tq' is initialized in imm_attach() and
scheduled via imm_queuecommand() for processing SCSI commands.  When the
IMM parallel port SCSI host adapter is detached through imm_detach(),
the imm_struct device instance is deallocated.

However, the delayed work might still be pending or executing
when imm_detach() is called, leading to use-after-free bugs
when the work function imm_interrupt() accesses the already
freed imm_struct memory.

The race condition can occur as follows:

CPU 0(detach thread)   | CPU 1
                       | imm_queuecommand()
                       |   imm_queuecommand_lck()
imm_detach()           |     schedule_delayed_work()
  kfree(dev) //FREE    | imm_interrupt()
                       |   dev = container_of(...) //USE
                           dev-> //USE

Add disable_delayed_work_sync() in imm_detach() to guarantee proper
cancellation of the delayed work item before imm_struct is deallocated.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://patch.msgid.link/20251028100149.40721-1-duoming@zju.edu.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/imm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 07db98161a036..dbe0598ce4bf4 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1269,6 +1269,7 @@ static void imm_detach(struct parport *pb)
 		if (dev->dev->port == pb) {
 			list_del_init(&dev->list);
 			scsi_remove_host(dev->host);
+			cancel_delayed_work_sync(&dev->imm_tq);
 			scsi_host_put(dev->host);
 			parport_unregister_device(dev->dev);
 			kfree(dev);
-- 
2.53.0



