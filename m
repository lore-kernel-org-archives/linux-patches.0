Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA5222A4E9;
	Mon, 18 Aug 2025 13:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525308; cv=none; b=KBZAF+5ZMy/y9H2nyX7uZuo9o+aMo8avoPesnbLYMWX0E2BSSPRUpeJKza+k5RzHVAQ8Z2W6DCo3npTahSBpVkwYqdEFFDsKERMNZdA6JMRT03H/c1gIFs3BHwj1Va4uwkkkVVTMKlrVm7qqVE4xxSkxc3iGL7q2VNFN824ZXWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525308; c=relaxed/simple;
	bh=stZwFapQAVFCiyTjZmdzmLZ8s5erXKwggj3su96nUQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAoU72+Ha5HLa3t07xcuUhwamRgrkwXtdguCeITXxFg4vNkvSVHcEWuFbkLo3iO5BTAG323mrVyB6fo3+necxjBESpnk683/bJzBt/jLaNgnkAKLBtjFst/mCdQ7tsNWnoXEBrkSLu+GD2moh9VB/IjPsTvFJT8k460ExOIe05w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijyjS5AL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijyjS5AL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF01C4CEF1;
	Mon, 18 Aug 2025 13:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525307;
	bh=stZwFapQAVFCiyTjZmdzmLZ8s5erXKwggj3su96nUQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijyjS5ALuek8wH4hfwzZ/idNhZ0sAZgtVtv5YBPjfBhCakPTuUuywjLcvAQRFGm0k
	 Yh0cr6RewWORce2nh/GLrSrbcwWsWuAN1p1UC3k8KpS1Tad4RoixiZTYg7Mq6cPJH/
	 q/LTgp70JH9vXwqY/3/74hu4LekC6yRCPpaxTLyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 222/570] s390/sclp: Use monotonic clock in sclp_sync_wait()
Date: Mon, 18 Aug 2025 14:43:29 +0200
Message-ID: <20250818124514.358532986@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 925f0707a67cae0a974c4bd5b718f0263dc56824 ]

sclp_sync_wait() should use the monotonic clock for the delay loop.
Otherwise the code won't work correctly when the clock is changed.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/sclp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index 840be75e75d4..9a55e2d04e63 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -719,7 +719,7 @@ sclp_sync_wait(void)
 	timeout = 0;
 	if (timer_pending(&sclp_request_timer)) {
 		/* Get timeout TOD value */
-		timeout = get_tod_clock_fast() +
+		timeout = get_tod_clock_monotonic() +
 			  sclp_tod_from_jiffies(sclp_request_timer.expires -
 						jiffies);
 	}
@@ -739,7 +739,7 @@ sclp_sync_wait(void)
 	/* Loop until driver state indicates finished request */
 	while (sclp_running_state != sclp_running_state_idle) {
 		/* Check for expired request timer */
-		if (get_tod_clock_fast() > timeout && timer_delete(&sclp_request_timer))
+		if (get_tod_clock_monotonic() > timeout && timer_delete(&sclp_request_timer))
 			sclp_request_timer.function(&sclp_request_timer);
 		cpu_relax();
 	}
-- 
2.39.5



