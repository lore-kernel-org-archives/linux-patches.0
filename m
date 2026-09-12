Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E263A16BA;
	Sat, 12 Sep 2026 18:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238356; cv=none; b=ROGvlD3f/d7coHsLKoyZAAaFbAmj1y2I4vP99G+L4XsL3fD4x6od959CV4bQkMxRscurL4uTXoJLNZ6sjRa18hHM80Qp4PBViYLq8d9oChR3LdqaEnm96EwCsBfKxsw/dEkfUH9pQ+ENOtGmAjq/mC7koOgBvjsUUs+ulfTl84U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238356; c=relaxed/simple;
	bh=O3L+lAHT4/gAByBhuqXr4ad1VDoZ8ty//AwLXq/wdv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZZgOAW5MCp40PBg+dGbK2BZH8DOMXwyEVSQ2KG0Icqms1RfMdjXaFSj55ouqN/EH/6+Ck5k+jJJVlTAFFbo87lao4qaQtHNxBSP8CmaRL8DcrQakUUUyq+zhnnYXhJsQxSzw7nBYrDxFqGCInNzYuDd3+OqHX5iZwBU70U+l9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbgKruKo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbgKruKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C411F000FF;
	Sat, 12 Sep 2026 18:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238354;
	bh=VTfhQLdjPqC/hNscOQBiN2a9pCemvYAQnmKg+RuHxkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbgKruKoZAF9uCogB1zyJvPMyXVgE+0YCmUHzstSuP/fCXmBPaiNkoWp7GZaYw6Fj
	 rqVlibt0zkuurowJtjwu4EgFm21epo6oOTKFO3BRQHU8WzZ/skRKi4ie+W0w8Qy2av
	 lgm3gGnBye8B669XCJ/YIXOaM4Dk5nGE8kiczaLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 402/935] media: cec-pin: Fix event FIFO ordering
Date: Sat, 12 Sep 2026 08:57:12 +0200
Message-ID: <20260912065536.044751570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 99e69c49e0c9e..8e33e2b42dd46 100644
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
@@ -1070,7 +1070,7 @@ static int cec_pin_thread_func(void *_adap)
 						     pin->work_tx_ts);
 		}
 
-		while (atomic_read(&pin->work_pin_num_events)) {
+		while (atomic_read_acquire(&pin->work_pin_num_events)) {
 			unsigned int idx = pin->work_pin_events_rd;
 			u8 v = pin->work_pin_events[idx];
 
@@ -1079,7 +1079,7 @@ static int cec_pin_thread_func(void *_adap)
 						v & CEC_PIN_EVENT_FL_DROPPED,
 						pin->work_pin_ts[idx]);
 			pin->work_pin_events_rd = (idx + 1) % CEC_NUM_PIN_EVENTS;
-			atomic_dec(&pin->work_pin_num_events);
+			atomic_dec_return_release(&pin->work_pin_num_events);
 		}
 
 		switch (atomic_xchg(&pin->work_irq_change,
-- 
2.53.0



