Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F6D2F3C05;
	Fri, 10 Oct 2025 13:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102570; cv=none; b=orlifgR9ZIGtLS6XIJ5gVGDKZYV1COavcpsO4PA4pM03+r01hnjugHTdvrDXGRbCSZAlsE45qJ5NQx1gTZg9dH4c45/vDwuEmYUS3aIHGsVoHjAI95ZbTmIydlBm23YJw4XhDNnzSz5TgQtxrvRl7tIPVGd0Fot5CO7YuyGHZZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102570; c=relaxed/simple;
	bh=7/t0b9u8EL0hmOPSyTmz7qg2ZfsTzM/XsmVnDT4+hK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psJNnkMSAf5zn5m7cqMsuhzl9jsM6QWeJ5IlvC+VPFKhZNO+f0qXqMYEZrDzezbzQtRtlYX+fIIKLfnzP923KSR81ROVESB5xtZG3mx7IBYWsCwg6RBxroFgbMqGm2Se+oyv8gCTsidM9u7fBY4GjMC4h/0LM5Q/XWhAIs83gQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HstUWiAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HstUWiAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA5FC4CEF1;
	Fri, 10 Oct 2025 13:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102570;
	bh=7/t0b9u8EL0hmOPSyTmz7qg2ZfsTzM/XsmVnDT4+hK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HstUWiAUnJ0U+pxSRdtpjiavnnXV7fnwKZqG5ZYBEWmtFNuAFzTdvZ8tF5vLmFBZe
	 6Q8rl7VjXw0lM2SfF3HJ2Pxi8TDdOxn/+Gb1XrvqlknbRbbJYrN1lmBHfabZUvBKWm
	 lDiGrGSwwe9ob1zAzn0EmsW/S7mml0jD3h1su/wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 03/28] media: tuner: xc5000: Fix use-after-free in xc5000_release
Date: Fri, 10 Oct 2025 15:16:21 +0200
Message-ID: <20251010131330.486049284@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
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

[ Upstream commit 40b7a19f321e65789612ebaca966472055dab48c ]

The original code uses cancel_delayed_work() in xc5000_release(), which
does not guarantee that the delayed work item timer_sleep has fully
completed if it was already running. This leads to use-after-free scenarios
where xc5000_release() may free the xc5000_priv while timer_sleep is still
active and attempts to dereference the xc5000_priv.

A typical race condition is illustrated below:

CPU 0 (release thread)                 | CPU 1 (delayed work callback)
xc5000_release()                       | xc5000_do_timer_sleep()
  cancel_delayed_work()                |
  hybrid_tuner_release_state(priv)     |
    kfree(priv)                        |
                                       |   priv = container_of() // UAF

Replace cancel_delayed_work() with cancel_delayed_work_sync() to ensure
that the timer_sleep is properly canceled before the xc5000_priv memory
is deallocated.

A deadlock concern was considered: xc5000_release() is called in a process
context and is not holding any locks that the timer_sleep work item might
also need. Therefore, the use of the _sync() variant is safe here.

This bug was initially identified through static analysis.

Fixes: f7a27ff1fb77 ("[media] xc5000: delay tuner sleep to 5 seconds")
Cc: stable@vger.kernel.org
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[hverkuil: fix typo in Subject: tunner -> tuner]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/tuners/xc5000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -1304,7 +1304,7 @@ static void xc5000_release(struct dvb_fr
 	mutex_lock(&xc5000_list_mutex);
 
 	if (priv) {
-		cancel_delayed_work(&priv->timer_sleep);
+		cancel_delayed_work_sync(&priv->timer_sleep);
 		hybrid_tuner_release_state(priv);
 	}
 


