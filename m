Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE5E36BCD0;
	Tue,  6 Jan 2026 17:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722150; cv=none; b=OFDj7bc/mJbh1wxBvhZO3U9wTyvreOJSdmzYhls6Z3BPT8YqnamSPpypCR8UFz/ldqLVc4SCl4Js8F4E0Rjgsr1IGojUatrpF5bpQnAgcdVEJuWLhM2quMWpIcYZU9rBoCtHxNC25ThkbCwpEbjw7gVpwhSanHN9wWgatO1WcI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722150; c=relaxed/simple;
	bh=H9Eu60YqXVO0yVMw4RWbcYuRJ6ZfuQX+xeQg4QwiLfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fp3/lgkpaNyTRahDY1kuZsMa1A0NZILWjxqrsmTZ8AZ+JNww74qKd2jsNZ16soVmxY80RywI+rxbRNFoa7kYcjwEugvB6wnDj1K4RIJYmThNjqvKuF+cPH7L6UF38X7w2fXWn1BBlxSKvGkiI3Mq6AZpWpe6MJspKxkwFR6DiwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMQ34bA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMQ34bA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F120FC116C6;
	Tue,  6 Jan 2026 17:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722150;
	bh=H9Eu60YqXVO0yVMw4RWbcYuRJ6ZfuQX+xeQg4QwiLfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMQ34bA0CP8I0ep4TItCmsBYAQQGYtBqzTMIhEsnFFjD7YPq740d+QEUKd7SqEnTq
	 rcYu42fUJ4Jsl7aNEFCd7bqgpGNLEzmTznu/H2h+lMKDEKevHnxMNx+hZxhVWXvVXn
	 PBAxAX1YHOr4jhNDyoc09DmHQKe2iXUVC6ehG5ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 180/312] media: TDA1997x: Remove redundant cancel_delayed_work in probe
Date: Tue,  6 Jan 2026 18:04:14 +0100
Message-ID: <20260106170554.342779051@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2797,7 +2797,6 @@ err_free_media:
 err_free_handler:
 	v4l2_ctrl_handler_free(&state->hdl);
 err_free_mutex:
-	cancel_delayed_work(&state->delayed_work_enable_hpd);
 	mutex_destroy(&state->page_lock);
 	mutex_destroy(&state->lock);
 	tda1997x_set_power(state, 0);


