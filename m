Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84213BC4D8;
	Thu, 15 Jan 2026 17:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498337; cv=none; b=jFplv1yCFyN0bbpnxDbzPdo65cxAXl4sxzWV6ZckBlBlQaHzwyBYT38Sna+sMllmF3fmOSOYH/RB5zhJF7F2umgHpDPpOpDW3apcm50oZ/AI+Tso1o19aix/WkVO9WFlEfj7DAqG2XWCxeLR0FAD5MLUIAHViNSVfQ9qOkWn4EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498337; c=relaxed/simple;
	bh=fS2M4Q9RDbXwjF6GiB4DoNTlTQ5DREpoOhsYnmeaiHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j81SyiFO5shCML6fYERCIX/gOcftzSo1IXtCXhnIfSjInuFKQlzXvCjf1AsuJeL3y1uwzulbwPyu4IqXQi8g8oQyLOjMuMamRUpk1y/53m7q3ach6yAkBG3wmpj8/Xv563jZI+pzqJQeK67nImDqWDt7DoBQi/dPIrHgK8vvYAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydxwauPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydxwauPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAC6C116D0;
	Thu, 15 Jan 2026 17:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498337;
	bh=fS2M4Q9RDbXwjF6GiB4DoNTlTQ5DREpoOhsYnmeaiHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ydxwauPI5VixCzCsm3yHOTfblxabCfIfu/GnII5hG94w+5fBZwpUoiYD1SMrWKgJ3
	 PNi+VGGfi0a4P5v3W5xJbdbIntvM6xS5iqplJswAxUpSHDt0dyCSY8NJ645uxR5u/C
	 8qo+vUXrAM20DxJA8e0IVdGb0/YF5aKLY5MTMsKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 397/554] media: TDA1997x: Remove redundant cancel_delayed_work in probe
Date: Thu, 15 Jan 2026 17:47:43 +0100
Message-ID: <20260115164300.604473405@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
@@ -2780,7 +2780,6 @@ err_free_media:
 err_free_handler:
 	v4l2_ctrl_handler_free(&state->hdl);
 err_free_mutex:
-	cancel_delayed_work(&state->delayed_work_enable_hpd);
 	mutex_destroy(&state->page_lock);
 	mutex_destroy(&state->lock);
 err_free_state:


