Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DA3227BA4;
	Tue,  6 Jan 2026 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721006; cv=none; b=OS+oOlsLZjlNDyhtMt5xaYr0j9p0HP6jPU5QlVW6ZrTbYA3JF50CEVIh+RWFvf6dq9xCDlS2InRPFr4RvlCA4MIpKberEE4b/oP8bKuM99Pv3hokFD67kROmBZ1Sf5vxeNQWjvEMPLtgWyYeWRr8WaVsLyUIDUU98H8RQjeiorc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721006; c=relaxed/simple;
	bh=UU0tGsOcP6MQrHwD/Mal1Sa2snVM1Ef5kUt1q1hAlIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAQPjAugw/DZeNmXe1meBv9unrM8f8Kng0iI0tTXEMIZmbWw57+NF+v50EdCe4AsO46i4geIC9aGgrNSRs4HA6X3SzMHuXHX+aRkcLMA4ZwM5cxfJNl8MogWJ5EMzJjB9/0/V2zx/HZHwMXH/s2tENh0attqRXLNUQ1RvjRF+qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qy3nV9nB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qy3nV9nB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871A4C16AAE;
	Tue,  6 Jan 2026 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721006;
	bh=UU0tGsOcP6MQrHwD/Mal1Sa2snVM1Ef5kUt1q1hAlIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qy3nV9nBPGpKqas0/YUYN3HGyCN9Bf9vDGjjqV0cdRu7p1WwFWQPqZUw04yh0CnXI
	 SrT6Fz78wb2ybLdJ9n8xWK4bSGdEBX1v3R2tdiL4fv5JpvZdpBHdzouNPg9mn6QeEY
	 3eNWfXrJDi07zgmZttlR5Anmgr0ANdgs10N2Q5r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 407/567] media: TDA1997x: Remove redundant cancel_delayed_work in probe
Date: Tue,  6 Jan 2026 18:03:09 +0100
Message-ID: <20260106170506.398214420@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2798,7 +2798,6 @@ err_free_media:
 err_free_handler:
 	v4l2_ctrl_handler_free(&state->hdl);
 err_free_mutex:
-	cancel_delayed_work(&state->delayed_work_enable_hpd);
 	mutex_destroy(&state->page_lock);
 	mutex_destroy(&state->lock);
 	tda1997x_set_power(state, 0);


