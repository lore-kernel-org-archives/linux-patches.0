Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20EF1B583A;
	Tue,  2 Jul 2024 17:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940648; cv=none; b=eREd4xz7kUszIcu1ETmmx3IrzldX/Fcil6FwPsZHKXdaHAyJ6dQSK1MGuqXGEJQoW92+udiRef9fTGBpaMjTZNXwiOTlmspFhkrhl9hdOInJEDAM7Siqpx4H0GE3Th/2YI3AJdME0dpgX/D8Fce2a+FyuDydzApxwDErVAIC8+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940648; c=relaxed/simple;
	bh=lDQvPfUvgOT5TFL6Jd/m9Zu0E7JPqSJ6oPdlKC+SgiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWzj00r6zrbRG6MDmt2zyXxFW+7uLyNgj2/EYG8/WwUm/xzzi1+cwAgWj1PgXJ33slbpoUksHCZCLkUzWNebheeMSftEa1nMqriJdRCQMK362k3lpgmUm66R2hXWeM7p9oXUHdNaG0if3XRIrF5rTfG8EGJgEQli2IJauBtjPA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fgl5eLPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fgl5eLPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F6EC116B1;
	Tue,  2 Jul 2024 17:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940648;
	bh=lDQvPfUvgOT5TFL6Jd/m9Zu0E7JPqSJ6oPdlKC+SgiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fgl5eLPSP9H5Fky4UhkDgl7fIglcr1F+/Dp8sbirbgskwuvgX40Mt8rHGllfFjswZ
	 xBrn+wtkXcNxT+jPIUES61hIaDHjIy5Bwkuca9NAvTz/mw5rMoaRcku3wNHt8aBe7e
	 BqZKklglNLi6+oXwgvgOq+2lLIvcCO0XptPAeAQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.9 187/222] io_uring: signal SQPOLL task_work with TWA_SIGNAL_NO_IPI
Date: Tue,  2 Jul 2024 19:03:45 +0200
Message-ID: <20240702170251.133768024@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit dbcabac138fdfc730ba458ed2199ff1f29a271fc upstream.

Before SQPOLL was transitioned to managing its own task_work, the core
used TWA_SIGNAL_NO_IPI to ensure that task_work was processed. If not,
we can't be sure that all task_work is processed at SQPOLL thread exit
time.

Fixes: af5d68f8892f ("io_uring/sqpoll: manage task_work privately")
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1374,8 +1374,8 @@ static void io_req_normal_work_add(struc
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		struct io_sq_data *sqd = ctx->sq_data;
 
-		if (wq_has_sleeper(&sqd->wait))
-			wake_up(&sqd->wait);
+		if (sqd->thread)
+			__set_notify_signal(sqd->thread);
 		return;
 	}
 


