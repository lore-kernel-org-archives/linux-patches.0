Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8944387562;
	Tue, 10 Mar 2026 11:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142063; cv=none; b=DfjWPoH3iU6uYAbVA3GBjpkKJhhMtZoGiv6YJEfBAiUZR8j70L9j4ub0lF5JjSIwgakq2olNPKNdxYdHaPb5ddnHy5xAsdSXOrnMKHR+2JQ7E584WLMh8JSgDFOqEKLMFo7qhKOHeW89Q401uaOvb7rLD7L4lp6u4CdSZVNAZ80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142063; c=relaxed/simple;
	bh=e0SrHwk+T1GklansSl1rogFcuihbGNxOPYFB4ZkVbqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwEfe3NGRkN/uP8/qGyoRFW2VKi1/gTMJF3um95H6+YPhYtMkW+TEMA8BFWbT17vUJNbVP9JoNzv4V8cQVZz4VKi9KHvaYyhAWvH6XUrDdGK4yRy02jPTQiza+LtuZy90fLUvVVxXHMiSyuM2VmG7V66LuNUpasLBTo7nbqQ8gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QR+pUR6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QR+pUR6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1F2C2BC86;
	Tue, 10 Mar 2026 11:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142062;
	bh=e0SrHwk+T1GklansSl1rogFcuihbGNxOPYFB4ZkVbqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QR+pUR6N76/z6e74Or/FML0r1MopXbbW+I1DckxfAokJsZJdRTKooY1F/GlXAUxVO
	 /hCuO/ICy/8WyjYpDniS/CJDgLY4Tl0ZMTDNrTTCW3yLsyaagjOy3ZnUcdTVhBPfCM
	 L0YSZOYKBqDLwGgMWVKARtesOyAo+KBSmCpsS2bc/n4oDg3d6zN3JNSGnnAvRYxuy3
	 Wa4LcxOzXZ+CVQay8vP6vv0gNfV4eUIDWehqJaYg80fkeK01Q62rMIYebxciN83+3m
	 of2mLNcvqhUg5ZBKlj66pUQfBgV6eZgH/j7kpI3anMk0ZtgqdcgR2Ufzs0Wjwg47l9
	 bM/8bPL2SiYlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Junxiao Bi <junxiao.bi@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 188/314] scsi: core: Fix refcount leak for tagset_refcnt
Date: Tue, 10 Mar 2026 07:17:27 -0400
Message-ID: <3172968da9147b4d3e35c4e54d4e7552c55525a3.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Junxiao Bi <junxiao.bi@oracle.com>

commit 1ac22c8eae81366101597d48360718dff9b9d980 upstream.

This leak will cause a hang when tearing down the SCSI host. For example,
iscsid hangs with the following call trace:

[130120.652718] scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured

PID: 2528     TASK: ffff9d0408974e00  CPU: 3    COMMAND: "iscsid"
 #0 [ffffb5b9c134b9e0] __schedule at ffffffff860657d4
 #1 [ffffb5b9c134ba28] schedule at ffffffff86065c6f
 #2 [ffffb5b9c134ba40] schedule_timeout at ffffffff86069fb0
 #3 [ffffb5b9c134bab0] __wait_for_common at ffffffff8606674f
 #4 [ffffb5b9c134bb10] scsi_remove_host at ffffffff85bfe84b
 #5 [ffffb5b9c134bb30] iscsi_sw_tcp_session_destroy at ffffffffc03031c4 [iscsi_tcp]
 #6 [ffffb5b9c134bb48] iscsi_if_recv_msg at ffffffffc0292692 [scsi_transport_iscsi]
 #7 [ffffb5b9c134bb98] iscsi_if_rx at ffffffffc02929c2 [scsi_transport_iscsi]
 #8 [ffffb5b9c134bbf0] netlink_unicast at ffffffff85e551d6
 #9 [ffffb5b9c134bc38] netlink_sendmsg at ffffffff85e554ef

Fixes: 8fe4ce5836e9 ("scsi: core: Fix a use-after-free")
Cc: stable@vger.kernel.org
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260223232728.93350-1-junxiao.bi@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3c6e089e80c38..f405ef9c0e1e8 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -356,6 +356,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	 * since we use this queue depth most of times.
 	 */
 	if (scsi_realloc_sdev_budget_map(sdev, depth)) {
+		kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
 		put_device(&starget->dev);
 		kfree(sdev);
 		goto out;
-- 
2.51.0

