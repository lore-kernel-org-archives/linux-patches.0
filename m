Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029333;
	b=uUHkMvUweHIFf6kdFSscf8knfwHicV4q7xBvykOWN+Weg5u549WiPlvkzIg5SPxFgyno
	 zoEFEPg4B38M4oARv8gASJgVUnt6ue14XsS8c6THMFFMxIv+h3fmpSerbbzvZfuhJPy+/
	 Bkt43WN+S9P+JuGS6vJb/eXIXnYogW3yPJLcaJAKmn0Mtw5FZRsHLE7v6LEG28t9IZ8Vz
	 Eb5Kf+AFvxYsm13jEbnCdalLoGfah5jBKToAeYvXRoHmm+6IMg7hhlcF8AYqKm1+lVgC5
	 IdXgJfg4pyzkLTlFxZu6WXCNHQAUS5QO4QsKyLj/p/i0yF2AVITJsVdLtFeTPMOb8gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hXBaFJB4gInUWIMtYHbezP8khnfXXrR39Q70wT6xpSg=;
	b=06UzFc+IbemXiO27fR8EIyEJ3SYGYNXiw4ooLRsGz0LVQGm3SPXxU+H4eJZ8BeeWdU1Z
	 XrXAl7PiFd2NITLxNoaFQNiD68P+DvqE91cacNm+tvlibmVVNHPoqeD3ZS85lEjUetJFq
	 8jq/j+l6iNwC3XJ7a5b1JV8LGFSU8e0Amos97tMogUtwEA7yLbD5f0Jw44dofxoHft3pE
	 fsHqTMWx9h38O808nFgPlUHglLtHbJQddxIIsFFeNv5LZAymhd1vXj9ffU92oHjVcS4aN
	 pn5sZf6zC8J/03pdKfDNCtRofAZSTV1wnOFLx7CdQ/MXMRvsvTw5goy8bXUfJlYJZlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OM1jK9uE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BFE606A31C;
	Wed, 18 Nov 2026 19:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OM1jK9uE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0D41F000C6;
	Wed, 18 Nov 2026 19:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029333;
	bh=hXBaFJB4gInUWIMtYHbezP8khnfXXrR39Q70wT6xpSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OM1jK9uEAOHaa7onAAzuTbZTKSaybL+Dr2w+qWukcTVAXDOD22KcxRmSc47GlbnFa
	 R+IrROcUqqAYd+bnCYlRTQ+wAMxanUbJaMwCUNLDFYLKlnzC2vzjmfyNft24fBTsiP
	 NaSC4xNLjTa2JAGXjtlWu3hbwPTHkGtCMkpAXtOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0311/1756] scsi: mpi3mr: Fix out-of-bounds read of event data
Date: Wed, 18 Nov 2026 15:40:38 +0100
Message-ID: <20261118150020.710633514@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 77554f01187d91c20f04d2a8e28270943ed64cca ]

The event data length from the reply is used as is, both when caching log
data and when sizing the buffer handed to the bottom half. A length larger
than the frame makes both of them read past the end of it.

Clamp the length to what the frame can hold.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Fixes: d0d19250ed81 ("scsi: mpi3mr: Rename log data save helper to reflect threaded/BH context")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-12-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 18d3ebdb62e3c..0ce10b4bf0ffe 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3024,7 +3024,7 @@ void mpi3mr_add_event_wait_for_device_refresh(struct mpi3mr_ioc *mrioc)
 void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	struct mpi3_event_notification_reply *event_reply)
 {
-	u16 evt_type, sz;
+	u16 evt_type, sz, avail_reply_room;
 	struct mpi3mr_fwevt *fwevt = NULL;
 	bool ack_req = 0, process_evt_bh = 0;
 
@@ -3085,7 +3085,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
 	case MPI3_EVENT_LOG_DATA:
 
-		sz = event_reply->event_data_length * 4;
+		if (mrioc->reply_sz > offsetof(struct mpi3_event_notification_reply, event_data))
+			avail_reply_room = mrioc->reply_sz -
+			    offsetof(struct mpi3_event_notification_reply, event_data);
+		else
+			avail_reply_room = 0;
+		sz = min_t(u16, event_reply->event_data_length * 4, avail_reply_room);
 		mpi3mr_app_save_logdata_th(mrioc,
 			(char *)event_reply->event_data, sz);
 		break;
@@ -3119,7 +3124,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		dprint_event_th(mrioc,
 		    "scheduling bottom half handler for event(0x%02x) - (0x%08x), ack_required=%d\n",
 		    evt_type, le32_to_cpu(event_reply->event_context), ack_req);
-		sz = event_reply->event_data_length * 4;
+		if (mrioc->reply_sz > offsetof(struct mpi3_event_notification_reply, event_data))
+			avail_reply_room = mrioc->reply_sz -
+			    offsetof(struct mpi3_event_notification_reply, event_data);
+		else
+			avail_reply_room = 0;
+		sz = min_t(u16, event_reply->event_data_length * 4, avail_reply_room);
 		fwevt = mpi3mr_alloc_fwevt(sz);
 		if (!fwevt) {
 			dprint_event_th(mrioc,
-- 
2.53.0



