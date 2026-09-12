Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FF32931F5;
	Sat, 12 Sep 2026 14:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222388; cv=none; b=gTG2nfUlXTlJRo20cof4BZFCK8tdHi62nx4GC+taLSDuA/z/CT39vH5Wc36bSEkLKEjFYb8NAJHSqd8caiZ1jHYC9nInKMx9hKMWuTCb8PUGVhpO3J7yi2JIAJHoYNgdKRMgFIy7LNLUyxg9iasnr7xUKDHiygRAHZpgBBiYfUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222388; c=relaxed/simple;
	bh=G3OMZ4eYXb3gU169yKrtz8nWIAUoBSpPoqANpdAxG3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXNIcgcWiJuIAqEwcRJLiv+v00Vwd7tuafW+1e10ePiW2WphJ8qAUAuafB7/RWLUSeqh/gEINqZGjV2yQJdZyeZAYu8jkX3546NSAUsQShDGk1J/xOjaXzL8kOaol7RzM0ubMD5hOrbAUysIKQfPGY0VmXK7OiIZ8VZ1xQazVgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuSAsxLa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuSAsxLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BCD1F000FF;
	Sat, 12 Sep 2026 14:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222386;
	bh=uOhyl1M2yp9IY/cUnCD7WoydcrSBr1TM7HVbJ136oeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MuSAsxLaCNkJYhr0RCzeUhzkDlCMp54QOMDQ0ruxXrMDakc0T/8PkBjPO4/utBr9l
	 u3TGFj9cKcrL+nFkk9DlB9ImPR+XlpFtPbjwS182JG3SMRDuPZoGirsOrt+jALlqYD
	 Kg6RfXqe+UVlSHgISpM7IJXM8pMlWAztGPabu3ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0575/1424] media: cec-pin: Fix event FIFO ordering
Date: Sat, 12 Sep 2026 08:50:07 +0200
Message-ID: <20260912065620.175816708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit a1d83d1b810665bd53ce8a7b7867e054d68676c7 ]

cec_pin_update() fills work_pin_events[] and work_pin_ts[], then
increments work_pin_num_events. cec_pin_thread_func() uses that counter
to decide when to read the FIFO entries.

Do not let the counter update be observed without the event update. Also
do not let a freed slot be reused before the thread has finished reading
it. Use release operations when publishing an entry and releasing a slot,
and acquire operations when consuming those counter updates.

Leave the other work_pin_num_events users as they do not participate in
this FIFO publication path.

Fixes: ea5c8ef29668 ("media: cec-pin: add low-level pin hardware support")
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-pin.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/cec/core/cec-pin.c b/drivers/media/cec/core/cec-pin.c
index 330d5d5d86aba..4c91f96351cad 100644
--- a/drivers/media/cec/core/cec-pin.c
+++ b/drivers/media/cec/core/cec-pin.c
@@ -114,7 +114,7 @@ static void cec_pin_update(struct cec_pin *pin, bool v, bool force)
 		return;
 
 	pin->adap->cec_pin_is_high = v;
-	if (atomic_read(&pin->work_pin_num_events) < CEC_NUM_PIN_EVENTS) {
+	if (atomic_read_acquire(&pin->work_pin_num_events) < CEC_NUM_PIN_EVENTS) {
 		u8 ev = v;
 
 		if (pin->work_pin_events_dropped) {
@@ -125,7 +125,7 @@ static void cec_pin_update(struct cec_pin *pin, bool v, bool force)
 		pin->work_pin_ts[pin->work_pin_events_wr] = ktime_get();
 		pin->work_pin_events_wr =
 			(pin->work_pin_events_wr + 1) % CEC_NUM_PIN_EVENTS;
-		atomic_inc(&pin->work_pin_num_events);
+		atomic_inc_return_release(&pin->work_pin_num_events);
 	} else {
 		pin->work_pin_events_dropped = true;
 		pin->work_pin_events_dropped_cnt++;
@@ -1074,7 +1074,7 @@ static int cec_pin_thread_func(void *_adap)
 						     pin->work_tx_ts);
 		}
 
-		while (atomic_read(&pin->work_pin_num_events)) {
+		while (atomic_read_acquire(&pin->work_pin_num_events)) {
 			unsigned int idx = pin->work_pin_events_rd;
 			u8 v = pin->work_pin_events[idx];
 
@@ -1083,7 +1083,7 @@ static int cec_pin_thread_func(void *_adap)
 						v & CEC_PIN_EVENT_FL_DROPPED,
 						pin->work_pin_ts[idx]);
 			pin->work_pin_events_rd = (idx + 1) % CEC_NUM_PIN_EVENTS;
-			atomic_dec(&pin->work_pin_num_events);
+			atomic_dec_return_release(&pin->work_pin_num_events);
 		}
 
 		switch (atomic_xchg(&pin->work_irq_change,
-- 
2.53.0



