Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15501E522;
	Thu, 30 Jan 2025 14:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247285; cv=none; b=aQ38Xllrjnu5pc/rcLWmYnwRW2D/dZeXYm+mKSRONUhQSYUB2aMgMQTBijderbvEj9sQzwsiPAwvxQpF2bj851pn7sRr5vSS75gqf+0/9b9ulo41/Xy0SiGrRuDhnMQeFJ4l/7og09zf3g4Zhzvg6FqTLvfJAy2n6ia3drBd4IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247285; c=relaxed/simple;
	bh=YMPYa57Z2AmyCkg2EShutEsay/m9r45rUsL9PIeUuxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGwAS6AywQIN8jlvcoQ5KJ8vdJJguoxvsAem22ndiNByuj65ZPk2fB8qEBUGUzBJxJlxQYUYxiSD5CauVLAATn2cn7Evp8GJH9Ns+IdfO6pgjJGqaZMDl8hwBBCbn32tq7kAUnA6E20WhIgOHd/QQSkK4spbVl/6FYPuJZu7Xds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNGGA7hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNGGA7hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2D8C4CED2;
	Thu, 30 Jan 2025 14:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247285;
	bh=YMPYa57Z2AmyCkg2EShutEsay/m9r45rUsL9PIeUuxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNGGA7hvMKdnMd818VAiy4VLw7K4KUpIJAPpgnDeGtFTUwJYSAi3YlPPDD+kS2aK5
	 bCj3l+cvEZWjjKPsJSNnF+SIoBRE3rsvKzWGCHvF8e/FT0XskPhJd0iPZ4bnhnAbra
	 qv1ErFyJwy7oYUwHb3tt/BhfQGrIZloRvw1wGKBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Zhang <hawkxiang.cpp@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/24] scsi: iscsi: Fix redundant response for ISCSI_UEVENT_GET_HOST_STATS request
Date: Thu, 30 Jan 2025 15:01:56 +0100
Message-ID: <20250130140127.472051523@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
References: <20250130140127.295114276@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Zhang <hawkxiang.cpp@gmail.com>

[ Upstream commit 63ca02221cc5aa0731fe2b0cc28158aaa4b84982 ]

The ISCSI_UEVENT_GET_HOST_STATS request is already handled in
iscsi_get_host_stats(). This fix ensures that redundant responses are
skipped in iscsi_if_rx().

 - On success: send reply and stats from iscsi_get_host_stats()
   within if_recv_msg().

 - On error: fall through.

Signed-off-by: Xiang Zhang <hawkxiang.cpp@gmail.com>
Link: https://lore.kernel.org/r/20250107022432.65390-1-hawkxiang.cpp@gmail.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index e044b65ee0d08..f839e8e497be3 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4124,7 +4124,7 @@ iscsi_if_rx(struct sk_buff *skb)
 		}
 		do {
 			/*
-			 * special case for GET_STATS:
+			 * special case for GET_STATS, GET_CHAP and GET_HOST_STATS:
 			 * on success - sending reply and stats from
 			 * inside of if_recv_msg(),
 			 * on error - fall through.
@@ -4133,6 +4133,8 @@ iscsi_if_rx(struct sk_buff *skb)
 				break;
 			if (ev->type == ISCSI_UEVENT_GET_CHAP && !err)
 				break;
+			if (ev->type == ISCSI_UEVENT_GET_HOST_STATS && !err)
+				break;
 			err = iscsi_if_send_reply(portid, nlh->nlmsg_type,
 						  ev, sizeof(*ev));
 			if (err == -EAGAIN && --retries < 0) {
-- 
2.39.5



