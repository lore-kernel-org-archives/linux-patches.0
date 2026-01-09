Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A714D35A953;
	Fri,  9 Jan 2026 12:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960966; cv=none; b=CKeudLgz8sQ1AaUM1JkON+/04IQWu5KqBvLHyGhspYaVYZv8tH8O/WOmJONgd41niOZjgwVz4js2jX2izzrKycjBv08O3Tak/BtCEn4UvvESiqYs79Rl2r+WGPdEaZBcx2yNvvju8MkTP4kKgHHmNqwWrJ+aGFRYJbZsLlekzjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960966; c=relaxed/simple;
	bh=o6gIQDDCuo0PCC0qTF+08ohcYpjY4sncyDoAiUp2wk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bU19WM19BvYWRHnnQbM6AUdn+a1rcHByflk+l5Ao9Cnfh3RsXikrXAoykFNiUGbaFKjq6lnZzwKPKmE21qvQu9A/HNTe29z9XqWP6kJbkIkYGwlsuZcXBc4waYw6oRwT6yaCFInzt2uAqKhaJCfUeYmlk4SEqh95rbWuMjdW+Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1Qx6mZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1Qx6mZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9C4C4CEF1;
	Fri,  9 Jan 2026 12:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960965;
	bh=o6gIQDDCuo0PCC0qTF+08ohcYpjY4sncyDoAiUp2wk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1Qx6mZrEdXVGMAeIinIkAm9kAsoflzrW55o9+fannENkNy+Ao89MP/5TZ3s+E8br
	 GI2HV2OJz8I5VNuZAlaqa9g9dGUwHvqOMgKZhLFZDyszVCRYE/eq3CNYLlODCO5ioR
	 G68BeZ1cYUSbmk9ERNkDwW422FpifIEDHUO4/HPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 587/737] media: TDA1997x: Remove redundant cancel_delayed_work in probe
Date: Fri,  9 Jan 2026 12:42:06 +0100
Message-ID: <20260109112156.081828354@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -2794,7 +2794,6 @@ err_free_media:
 err_free_handler:
 	v4l2_ctrl_handler_free(&state->hdl);
 err_free_mutex:
-	cancel_delayed_work(&state->delayed_work_enable_hpd);
 	mutex_destroy(&state->page_lock);
 	mutex_destroy(&state->lock);
 	tda1997x_set_power(state, 0);


