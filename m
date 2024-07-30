Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57AD1A6160;
	Tue, 30 Jul 2024 16:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356858; cv=none; b=EeFfAcRhYX9d1cdTSFoRNCx1/OxUyd3euEOOHviNnwKvCF5alwysq6ZM3ZEMP4geqv3N2DBdSH7La9uKkNZrg9CeUVkoOHfmfLZ1dSDxvVQ0AjR8FD4SNTyFeyW3gdDi0sFPg0OSQNLfbKgvnWQ2pRIPXikycXhcnrT3MUkp49c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356858; c=relaxed/simple;
	bh=qWzAWSkJzlKaow2r5RDnKa6F5l8UZibAgXTYFSJQPOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krZfJ2IJRabw9G4OWiJHeD6NWd6jaCiM7lkl0uJP9AQXa7yJ1tV6f6khBbRRB69RyruG26N5g6uOcCufFO7ZQiD275OcUhxi6zSovVuvydpQPluyfAKJJWkS4sZBcMbxaml+b/T5Kn6kV1hJnd1Wo8dZDwcxvHsks0HMb9Lj16Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wk5VvDaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wk5VvDaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387F3C32782;
	Tue, 30 Jul 2024 16:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356858;
	bh=qWzAWSkJzlKaow2r5RDnKa6F5l8UZibAgXTYFSJQPOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wk5VvDaPw/CndJ2tKZIn7K7471NwiRAHkPvGOXdqAtag6phyJk58+DgSjI1mJP8ij
	 T1yrcKtiNzXT/vQJg6Ho/jcnLWbx0txgxeMpcT6lkh2alDOHBRp0lq1j4M+R8mMI1F
	 Q3/8DPAOpcBZA0aMYeFamCBHuhg24uRarNqa/Vi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/568] media: imon: Fix race getting ictx->lock
Date: Tue, 30 Jul 2024 17:44:58 +0200
Message-ID: <20240730151647.344732166@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 24147897507cd3a7d63745d1518a638bf4132238 ]

Lets fix a race between mutex_is_lock() and mutex_lock().

<-mutex is not locked
if (!mutex_is_locked(&ictx->lock)) {
	unlock = true; <- mutex is locked externaly
	mutex_lock(&ictx->lock);
}

Let's use mutex_trylock() that does mutex_is_lock() and mutex_lock()
atomically.

Fix the following cocci warning:
drivers/media/rc/imon.c:1167:1-7: preceding lock on line 1153

Fixes: 23ef710e1a6c ("[media] imon: add conditional locking in change_protocol")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/imon.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 5719dda6e0f0e..e5590a708f1c5 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1148,10 +1148,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_proto)
 
 	memcpy(ictx->usb_tx_buf, &ir_proto_packet, sizeof(ir_proto_packet));
 
-	if (!mutex_is_locked(&ictx->lock)) {
-		unlock = true;
-		mutex_lock(&ictx->lock);
-	}
+	unlock = mutex_trylock(&ictx->lock);
 
 	retval = send_packet(ictx);
 	if (retval)
-- 
2.43.0



