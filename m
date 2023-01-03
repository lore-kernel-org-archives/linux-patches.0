Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81349186E
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75A7C433D2;
	Tue,  3 Jan 2023 08:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733815;
	bh=TfUx3o+V0JWyU4eD8g2z1BFwEl5Efx1jlgxzVP665Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hou+gUvSKFHkNDjHxf6NoKvx3wh7OrrMMxKH97pusiSEe78iMu+Iqo05Z4reSOoMW
	 sMAVQY9zQyBeYNDhEOv4aCDnjcJCDVL5AJjeEiFtL1r3Jl2QN0Ckdy+XODCjwAteh4
	 ZFxvVtAxMPcbyW+9nv2w/AVdahXto8b5kGUGhPUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 53/63] kernel: dont call do_exit() for PF_IO_WORKER threads
Date: Tue,  3 Jan 2023 09:14:23 +0100
Message-Id: <20230103081311.776185008@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 10442994ba195efef6fdcc0c3699e4633cb5161b ]

Right now we're never calling get_signal() from PF_IO_WORKER threads, but
in preparation for doing so, don't handle a fatal signal for them. The
workers have state they need to cleanup when exiting, so just return
instead of calling do_exit() on their behalf. The threads themselves will
detect a fatal signal and do proper shutdown.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/signal.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2755,13 +2755,21 @@ relock:
 		}
 
 		/*
+		 * PF_IO_WORKER threads will catch and exit on fatal signals
+		 * themselves. They have cleanup that must be performed, so
+		 * we cannot call do_exit() on their behalf.
+		 */
+		if (current->flags & PF_IO_WORKER)
+			goto out;
+
+		/*
 		 * Death signals, no core dump.
 		 */
 		do_group_exit(ksig->info.si_signo);
 		/* NOTREACHED */
 	}
 	spin_unlock_irq(&sighand->siglock);
-
+out:
 	ksig->sig = signr;
 	return ksig->sig > 0;
 }


