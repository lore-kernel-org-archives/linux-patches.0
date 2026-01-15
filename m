Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344D73D2FF3;
	Thu, 15 Jan 2026 17:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499715; cv=none; b=D6rlRl2w6Drzeo+utLROyokPcVyCWfhnW7Q5EcRzIbzwcvPlo6vr7yaC8po1AfUfM7pbw7jz+IdQOm9o01k+t/D/9ARN9N5/7eecSpoNN+k0IXAcDBlIHrgfAt4+4CCF/603CYbcqReQ4BWQ/WuJaIIQDAMGGBwBwRkt5VQ60IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499715; c=relaxed/simple;
	bh=0a0TLag+NhhUH+BkH/7xkiRQMMMu5X1KNfoyDwSfPc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJ340Sz5S4WD1Ovk0t0YCoDcIPy4R7smK37iVSQ3/LS0cXMawT9Db6mw1H1VqgcVOtcUb9azRKRsEzhKE9pDjJDFhUz4Otxc3rdhhrC0eI6urOn0FaRpLCTa9Bv6F/jwqw6Yf9oj80UxVKz1RPe1rg1hWahNoavgPgWh58zCMyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRd5tgPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRd5tgPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FCCC116D0;
	Thu, 15 Jan 2026 17:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499715;
	bh=0a0TLag+NhhUH+BkH/7xkiRQMMMu5X1KNfoyDwSfPc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRd5tgPAlHeqXvHAHN5UZLqroJMhotDBeZe0JrS929MggPcJ911zRTMPzbtWb2KWO
	 LT8+aEd1qiwNAiqSiKB/mULQPbvr3Y18JEcGcSFNmdDb3wjkDDEcKrTdIV5QP4MS1l
	 +ME/oZiRerwIkqvbHDcPjQuZcvbrHDzq0VTiDXBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 324/451] media: TDA1997x: Remove redundant cancel_delayed_work in probe
Date: Thu, 15 Jan 2026 17:48:45 +0100
Message-ID: <20260115164242.620539205@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

commit 29de195ca39fc2ac0af6fd45522994df9f431f80 upstream.

The delayed_work delayed_work_enable_hpd is initialized with
INIT_DELAYED_WORK(), but it is never scheduled in tda1997x_probe().

Calling cancel_delayed_work() on a work that has never been
scheduled is redundant and unnecessary, as there is no pending
work to cancel.

Remove the redundant cancel_delayed_work() from error handling
path in tda1997x_probe() to avoid potential confusion.

Fixes: 9ac0038db9a7 ("media: i2c: Add TDA1997x HDMI receiver driver")
Cc: stable@vger.kernel.org
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/tda1997x.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -2779,7 +2779,6 @@ err_free_media:
 err_free_handler:
 	v4l2_ctrl_handler_free(&state->hdl);
 err_free_mutex:
-	cancel_delayed_work(&state->delayed_work_enable_hpd);
 	mutex_destroy(&state->page_lock);
 	mutex_destroy(&state->lock);
 err_free_state:


