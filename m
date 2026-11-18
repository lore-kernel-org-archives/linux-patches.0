Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039527;
	b=Cd9iccRqK64bWUcpiDb8MNUjLxTm/BBEB2DFIO2jXfet5GVo9mvCQ8GEUjbR0jUOTMNp
	 CXvHtq89/Zx/k/9P8D7IIEzQrk0rQikjfXvbtIxRkVWD3ZqWVqg1hKhbeXgH8Nw/zGhK9
	 q8CvTY18QIjVoJb/s8mP8cYoNJYB8hTZQrRo9QxYZi1d/OLw5gCb3edqhit40NH6So/zI
	 5X7gBt765j27WbiKvx2+ZKyo52NdT/sP/E1pwn7BnpovCMqdwQy3URyCQEDMvpjH8qqWn
	 z2WKAneMA6ojOmMxWOqinCrtQm3KrvK0f3JyklWhItWOZe8AtmnFMdqgYGKVqDjNqeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KHpYoCArYPHNPO+FogY4hIukkVoNCKgVKosOP46Ag14=;
	b=i/iXOvllrig/6SVCbydDXU/5uj+tdkrKKVUmLfrQ7Vf3pSjRSz5rX/da29T2rabzuklI
	 M4jMT74rZLVIRL6p+DwsdgroeKc6GmH7nio4BwmH2MaccYu/93teD4NLkBeMi9kwInBdu
	 lTq70Wqiz8UfLWHm9iJsbQe5hMIFuoT806EKXn3Re2jSmsqAbR+vxJsEE6pC4/CjlpO+/
	 hBVeWdL6/tM8MjJApZ9v2JvN2uCcvlTEY6StVIKsj9d1CamktN7pE7FYooGohz0swif65
	 gaYifj64C/czBjgaab156stwZgYzuBfRObZoTv2+CpipjfsWwzlv27TjVo1QC1R8EHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gLlibiLC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE70606A320;
	Wed, 18 Nov 2026 22:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gLlibiLC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985811F000C5;
	Wed, 18 Nov 2026 22:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039527;
	bh=KHpYoCArYPHNPO+FogY4hIukkVoNCKgVKosOP46Ag14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLlibiLC/YTImntp61/hQjamRmTKQOKPDJhB8pZvl3IWwD1W9ogosCzLS/pR1LycG
	 lFqxRhDQZ+IFQxsPE2v7hsBYWxB5Jei7kE5eg3+dKkqHEvKBoaNoTexZzMic+EDkz8
	 McTXTh7kYjuBumMzqgueRJS4yljBt9inABK4/WrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2131/3318] scsi: mpi3mr: Fix out-of-bounds read of event data
Date: Wed, 18 Nov 2026 15:45:53 +0100
Message-ID: <20261118150425.992627090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 20bcc3e5bb0ed..74bfddfd42c09 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2909,7 +2909,7 @@ void mpi3mr_add_event_wait_for_device_refresh(struct mpi3mr_ioc *mrioc)
 void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	struct mpi3_event_notification_reply *event_reply)
 {
-	u16 evt_type, sz;
+	u16 evt_type, sz, avail_reply_room;
 	struct mpi3mr_fwevt *fwevt = NULL;
 	bool ack_req = 0, process_evt_bh = 0;
 
@@ -2964,7 +2964,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
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
@@ -2998,7 +3003,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
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



