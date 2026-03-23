Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2B51DE4E0;
	Mon, 23 Mar 2026 14:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277835; cv=none; b=jYYkIBYqZLxstfJM7TYc3i3DfdwaEp4UMLVHKH5749E8/txsJVroVNoKAz7coFe5u0hSb1FNE55peeseLjD3hPO6UvzQxIggnH7Ke9wAp7OetXy80zfQy9gBGTejctrCn9GaJtS/1tLN2/ihhFAQ8d1kdqDwAwlRj+uTZh67ej4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277835; c=relaxed/simple;
	bh=PeYR77YnSG5JKiARQ5FrVOsfLSX4zrn5sF/calw2bMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mT48cIoxnmXgN5fa/W4WzthvIwV3PqjwNtEDsTmQGE7C85CUQunBFUhPg+1PSdLwzPKhop3CYgT1ByxDf5qtoiq8TVeDobq6VhsUIsA+f3vqjfKcbWqmL9GjISZyDw1EI32dAt2nwGWkviS+y6Th5npIYG1xAd/ZiOLUdDxQrC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sza6Dp7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sza6Dp7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3E9C2BCB1;
	Mon, 23 Mar 2026 14:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277835;
	bh=PeYR77YnSG5JKiARQ5FrVOsfLSX4zrn5sF/calw2bMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sza6Dp7cZSsQkYL12FGdLW8HHgHoKsKXbZCnwr8oSD8cfBalvV5/4MjF/WaYEomqI
	 iARqAk5N3D4OJo6W/IHa8VqKHZEUGKJWGt+NPVTArvX2Eg+rpFV5/hhMl0VpVEL58S
	 m3tTDnJI5f+1OrRjMqOLSF9YMSwRvdVITTlbEK8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 118/567] scsi: core: Fix refcount leak for tagset_refcnt
Date: Mon, 23 Mar 2026 14:40:38 +0100
Message-ID: <20260323134536.730284567@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
 drivers/scsi/scsi_scan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -354,6 +354,7 @@ static struct scsi_device *scsi_alloc_sd
 	 * since we use this queue depth most of times.
 	 */
 	if (scsi_realloc_sdev_budget_map(sdev, depth)) {
+		kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
 		put_device(&starget->dev);
 		kfree(sdev);
 		goto out;


