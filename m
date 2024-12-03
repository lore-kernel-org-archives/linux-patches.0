Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31281F76BB;
	Tue,  3 Dec 2024 15:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240290; cv=none; b=Muc9YTePLTcli/OPqvNf0auBJ/JnRH1rrjFlOqwyIuqq3BKaSOtvHuVZ65bJ967+Jebh0sDclOHyW88PQljGht9keM2WfrgkSiT7niP6mwSM64eBGsSP2fOYTnyabBF3xnMccUeEoGLFqSvl5HSkMpDgYjLIttE1WsHEhTCJ72I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240290; c=relaxed/simple;
	bh=VOPlqoMUFwO10iTe/Z4xDOYNn/x24KZXfEYwPPB8wS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMZL4Nn84HnpvjXcM52vamDVwYqlyQeRBkpwolinKylRpcRfflWgnFVj8pYHx2MfgauKGl3gJlctYETjLH4UEXJuigfG3nhWfBB7liCXKwt6pgclSfSUBhrj0UsP757aNJw9SUsVvcHMm3HqeSIT6eORRhb92FSg+IpKzBeTXjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvyzHKSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvyzHKSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C809C4CED6;
	Tue,  3 Dec 2024 15:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240289;
	bh=VOPlqoMUFwO10iTe/Z4xDOYNn/x24KZXfEYwPPB8wS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvyzHKSGueqMDO38j4YHT6PAavPdj1LfPyVT5svRbNXZGcUu5wEgr+vzBvEaVHTzF
	 bslFmkDOb1+jvrCSIycG86HaP3UYyhmfEq5hoxze9TmDXs10MD5x8JAgeC7CPLNQwu
	 GZwYRaEv5E0Jirlxfkx7rFLgYGH43vnYukMNdmf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/826] timers: Add missing READ_ONCE() in __run_timer_base()
Date: Tue,  3 Dec 2024 15:36:55 +0100
Message-ID: <20241203144747.163662096@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 1d4199cbbe95efaba51304cfd844bd0ccd224e61 ]

__run_timer_base() checks base::next_expiry without holding
base::lock. That can race with a remote CPU updating next_expiry under the
lock. This is an intentional and harmless data race, but lacks a
READ_ONCE(), so KCSAN complains about this.

Add the missing READ_ONCE(). All other places are covered already.

Fixes: 79f8b28e85f8 ("timers: Annotate possible non critical data race of next_expiry")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/all/87a5emyqk0.ffs@tglx
Closes: https://lore.kernel.org/oe-lkp/202410301205.ef8e9743-lkp@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 0fc9d066a7be4..7835f9b376e76 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -2422,7 +2422,8 @@ static inline void __run_timers(struct timer_base *base)
 
 static void __run_timer_base(struct timer_base *base)
 {
-	if (time_before(jiffies, base->next_expiry))
+	/* Can race against a remote CPU updating next_expiry under the lock */
+	if (time_before(jiffies, READ_ONCE(base->next_expiry)))
 		return;
 
 	timer_base_lock_expiry(base);
-- 
2.43.0



