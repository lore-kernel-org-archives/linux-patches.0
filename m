Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BC335AC23;
	Tue, 10 Mar 2026 11:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141158; cv=none; b=fzCf1OUJO7I1/cXyMwBExXH8zAIFgFB8/+/vZMoESmftmx5YO0Bv15mbcI5iMEFpWQbgKYTNdZ3Mpmw6KpnQ/FT1jbafqv6hDPPeaZwPbFXUCdHywOEEMjUHl+Cfqu02Ia2qnZd9cGBW23BgChQYovTbnoQXNxXRL9PPIySdex8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141158; c=relaxed/simple;
	bh=OWvTx4/PvWc5ogPJNi8o7sspVkozdK9vb5Mq0QlwdgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlNge2V7tgZTKpiVlFFt5y3Fk5Kp2+W0K31YlXpWoND2ctfuYao3ZxVYpdIWhIR0b9YX8LPrsqHpyROzeMPQs9at2ucfLrcyQjCAIZS/7kuYfWYoNrwc9l25TAmUBZsNb9uBXyEkMbZUfFSQqdavC3KFOkpGOnzHxFF9Qvbykk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jBdDoBjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jBdDoBjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F355C19423;
	Tue, 10 Mar 2026 11:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141158;
	bh=OWvTx4/PvWc5ogPJNi8o7sspVkozdK9vb5Mq0QlwdgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBdDoBjgL/meLkA4Gd2sC7VBf2xaabaWT6GzCWWaq1GT4ImJKEiIuGKjNt+11bDCf
	 3iF7UVbky4lD7SdLZ7oDsDcVEKo25/zI1AYs5iQZVHNsp7GsSULQ5yFopu+vDpn1in
	 5l5oT9bvTncdRKC/mTrYz1WQPM4wckpsnWlkDrzxf2yqm66xjlfnjn/7sDlAGGu/lR
	 dw7xEm668zaEEVBxHUXk0r4RE3AzVOhJoPFEFiuFNZgkbXU0rtVxLvKKlA70CYCXPD
	 Oz4cXO/B4jzl3lDsRzmSGAjXp7wn55PWzPX3oK/K35ijg4NCh3Sqnoc/HJyFeLYbUi
	 +WzkHN8FFrRdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Junxiao Bi <junxiao.bi@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 160/311] scsi: core: Fix refcount leak for tagset_refcnt
Date: Tue, 10 Mar 2026 07:03:27 -0400
Message-ID: <b0d2686e0ee2db403abdcbccbadf6b0804ee12b9.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 7acbfcfc2172e..c64ef71633d82 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -361,6 +361,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	 * since we use this queue depth most of times.
 	 */
 	if (scsi_realloc_sdev_budget_map(sdev, depth)) {
+		kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
 		put_device(&starget->dev);
 		kfree(sdev);
 		goto out;
-- 
2.51.0

