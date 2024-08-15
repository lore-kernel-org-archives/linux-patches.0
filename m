Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E6D1714D0;
	Thu, 15 Aug 2024 13:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729021; cv=none; b=qhc23Z/JbUMFxGyuVRudf2t1Idja3LQ08Ye5BOpS6HhvB2iL3My2fg0DYoGBogK73x92lcF1za2CalCeuGC7ih/SZarDqxoAygJA2oEctcvevOvItHVQDps3ygQtzK1AUJTIvEIO4bi9+/HS2D/vgW0qiGxcVkq7pjlGO06cyeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729021; c=relaxed/simple;
	bh=CMAfFPxcG70kUPy61KOREBD7RrR/QOCfg0jXOvmVprE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MryCN9APyDaMAh1Pl/XSgwGm6XIMJNZGo206O8fQIPctx25Io56fpOxN0ENIH4TD9r4y4IGFHQ7jqQNnUBrt8jxPusRGUMwVxql8GTCvfDIk7QrhZJlS9T3Yfmy0gHoRaxRgdFGTVfcUFQlnvvs2DQGUx5MoJutpeN3Ewia45tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YclZ5WTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YclZ5WTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3140FC32786;
	Thu, 15 Aug 2024 13:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729021;
	bh=CMAfFPxcG70kUPy61KOREBD7RrR/QOCfg0jXOvmVprE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YclZ5WTh5GUVR5xr36xo3kPWPWW3EI9cTg/bizhL42Wt4D6FoUU5RT0NsfWFnKLN8
	 DN+DvpxcSVHDZAqU0Q1TOi6r+djDgx+htB9gt9pYUhmkAe5UuyjeG+BxE1QQPrq47F
	 EdJXPvAaOrpR6SbKb1W2+bLEtk2hCRzxcA0oKdu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Miroslav Lichvar <mlichvar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 178/196] ntp: Clamp maxerror and esterror to operating range
Date: Thu, 15 Aug 2024 15:24:55 +0200
Message-ID: <20240815131858.882788517@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Stitt <justinstitt@google.com>

[ Upstream commit 87d571d6fb77ec342a985afa8744bb9bb75b3622 ]

Using syzkaller alongside the newly reintroduced signed integer overflow
sanitizer spits out this report:

UBSAN: signed-integer-overflow in ../kernel/time/ntp.c:461:16
9223372036854775807 + 500 cannot be represented in type 'long'
Call Trace:
 handle_overflow+0x171/0x1b0
 second_overflow+0x2d6/0x500
 accumulate_nsecs_to_secs+0x60/0x160
 timekeeping_advance+0x1fe/0x890
 update_wall_time+0x10/0x30

time_maxerror is unconditionally incremented and the result is checked
against NTP_PHASE_LIMIT, but the increment itself can overflow, resulting
in wrap-around to negative space.

Before commit eea83d896e31 ("ntp: NTP4 user space bits update") the user
supplied value was sanity checked to be in the operating range. That change
removed the sanity check and relied on clamping in handle_overflow() which
does not work correctly when the user supplied value is in the overflow
zone of the '+ 500' operation.

The operation requires CAP_SYS_TIME and the side effect of the overflow is
NTP getting out of sync.

Miroslav confirmed that the input value should be clamped to the operating
range and the same applies to time_esterror. The latter is not used by the
kernel, but the value still should be in the operating range as it was
before the sanity check got removed.

Clamp them to the operating range.

[ tglx: Changed it to clamping and included time_esterror ]

Fixes: eea83d896e31 ("ntp: NTP4 user space bits update")
Signed-off-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Link: https://lore.kernel.org/all/20240517-b4-sio-ntp-usec-v2-1-d539180f2b79@google.com
Closes: https://github.com/KSPP/linux/issues/354
Signed-off-by: Sasha Levin <sashal@kernel.org>
[ cast things to __kernel_long_t to fix compiler warnings - gregkh ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/ntp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -686,10 +686,10 @@ static inline void process_adjtimex_mode
 	}
 
 	if (txc->modes & ADJ_MAXERROR)
-		time_maxerror = txc->maxerror;
+		time_maxerror = clamp(txc->maxerror, (__kernel_long_t)0, (__kernel_long_t)NTP_PHASE_LIMIT);
 
 	if (txc->modes & ADJ_ESTERROR)
-		time_esterror = txc->esterror;
+		time_esterror = clamp(txc->esterror, (__kernel_long_t)0, (__kernel_long_t)NTP_PHASE_LIMIT);
 
 	if (txc->modes & ADJ_TIMECONST) {
 		time_constant = txc->constant;


