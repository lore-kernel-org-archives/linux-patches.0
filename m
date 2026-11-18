Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048163;
	b=dD2Ob4g4GWwlVa+JUZct9cFqy35PXSyI4B2GxNIOfhuyCbAV0nvrCftG8qSl1P8Se2Pf
	 fVXtW3e3UbwmRCF4N6fmclLS6drKmsj4zkt5I8iHR4jcMD/mMRbWGeFmKPwFXsxQA+RhH
	 0P2GCc+PwVZRN+jvmHW05rtxVkhWHZn+73fvWlOxZ19Fsk8R8M3vjq8ilPUtfIZGZdlM/
	 X+kSMMILE+F24/6hQ9UIOioHVLcvpo+dEndMkdQYpG/e6PZKKAb7exvE5a9gWJIpcpmqi
	 njihdUTS65Xd8KJt16ubu+3V4NYU/PTE0eaDfc1sAaidt6MfqowHc6HnGe6D13P0uSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ypc1cJk8k8kJCHJZdEdmTpKKPLmERIikrsP7QUh6pPw=;
	b=rsSMEftLVwclFYjEOYyTwsf3XESNAGE5UW6dOnw8PG9QN4jIDCJ8HGfyHhXyCI4EtKci
	 8kKscCAU1w2WkWNsihvkJo+EFM5PBZxZY3nUeamuL9rNjxyRmEUVyfj++Fi1KR3qEY11Q
	 t56e/Zl2SurTkIB4lqOY7n29dXQKIzzMIY2T70CyzUxkTRQxLvlSNJkJQydu8SyFwilvR
	 kxDoZb+PvsBTzPGg/RpIyVcLAX29dWudX+6wsY5dBbFWoP5fDFz41hhIx6CFjHJHjAmaa
	 lZRMc531v9PqrpN3wxJxZiqZA7IbHzLmwOXi814+gvZOlwS4oQeyijvQzzfLoPgZ78g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Au4V6Eos;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06D3606A31C;
	Thu, 19 Nov 2026 00:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Au4V6Eos
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECEE1F000C4;
	Thu, 19 Nov 2026 00:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048162;
	bh=ypc1cJk8k8kJCHJZdEdmTpKKPLmERIikrsP7QUh6pPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Au4V6Eosgn6RsF0lY3mp/Ymq5KSDxjvnH+/NP0PcsEUA11ojnXxdWWVjdVB+CyWoh
	 L2ICe1OMkG7nkwcOadHPloVi6qj+2SuuZqtUPFtw1fKnsdYoCk24l92f0vpXOHk4Sp
	 +Ef/TOMVKomaFX53581pTdLdXH/qpU8Swox3sCLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1860/2857] scsi: mpi3mr: Fix out-of-bounds read of event data
Date: Wed, 18 Nov 2026 15:48:14 +0100
Message-ID: <20261118150308.209511066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c1fd101fa7e59..b1173c63993e5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2870,7 +2870,7 @@ void mpi3mr_add_event_wait_for_device_refresh(struct mpi3mr_ioc *mrioc)
 void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	struct mpi3_event_notification_reply *event_reply)
 {
-	u16 evt_type, sz;
+	u16 evt_type, sz, avail_reply_room;
 	struct mpi3mr_fwevt *fwevt = NULL;
 	bool ack_req = 0, process_evt_bh = 0;
 
@@ -2925,7 +2925,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
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
@@ -2959,7 +2964,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
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



