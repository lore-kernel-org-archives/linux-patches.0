Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335EA20E4
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF53BC433F0;
	Tue,  3 Jan 2023 08:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733845;
	bh=8FhpJ1opUkwD3NDoYK3bwMKQdrS+jBXp72HMkufLcLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBT1NBdLTsuDur/9/tBgkERkRNVdrDS5oVweAjtePOLl1kBZvk+8KJtyputhk4BJY
	 7vd9g8Ulws1iED6wNF5pnf2e236U/ytQeoUmdSlGxFtq9Kb77Msi7BPiUigHguAaF0
	 mfaRCH7YHHJruWzkHkRa6Tr73GIw6HyABvpAHp08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergei Trofimovich <slyich@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 41/63] ia64: dont call handle_signal() unless theres actually a signal queued
Date: Tue,  3 Jan 2023 09:14:11 +0100
Message-Id: <20230103081311.050303537@linuxfoundation.org>
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

[ Upstream commit f5f4fc4649ae542b1a25670b17aaf3cbb6187acc ]

Sergei and John both reported that ia64 failed to boot in 5.11, and it
was related to signals. Turns out the ia64 signal handling is a bit odd,
it doesn't check the return value of get_signal() for whether there's a
signal to deliver or not. With the introduction of TIF_NOTIFY_SIGNAL,
then task_work could trigger it.

Fix it by only calling handle_signal() if we actually have a real signal
to deliver. This brings it in line with all other archs, too.

Fixes: b269c229b0e8 ("ia64: add support for TIF_NOTIFY_SIGNAL")
Reported-by: Sergei Trofimovich <slyich@gmail.com>
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Tested-by: Sergei Trofimovich <slyich@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/kernel/signal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -341,7 +341,8 @@ ia64_do_signal (struct sigscratch *scr,
 	 * need to push through a forced SIGSEGV.
 	 */
 	while (1) {
-		get_signal(&ksig);
+		if (!get_signal(&ksig))
+			break;
 
 		/*
 		 * get_signal() may have run a debugger (via notify_parent())


