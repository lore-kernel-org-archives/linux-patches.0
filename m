Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077E13ED3B2;
	Tue, 21 Jul 2026 19:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661772; cv=none; b=uSw9UYRt1lXT2halYSKJjGHxCq1epNL1p1vKamHpllOc66rDmP0ZfXHl8wut4VNEzGk4ZW2jOr29sDLfufBo3FWSqEbfKpcQjJZJ7GDAwPZ/+RM+ub5HGVXIt2cFpcvQ8Odx3Wu/DcUco3N5P68VfR2Fek7BrDK1dQAE7lEVr1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661772; c=relaxed/simple;
	bh=dklvtB6xbwnMws+Ht4lG2lYvCrKBCo6CMeQuXYQWUNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOnZtMVmpeGjHTD2/A8LqtOaCvqTrBn73OU2QaxqTgs8YQ+fDL7IjtzKlAjFAV5tCqb10ahrlkENXZN7onFGaG0yjhw5QQRRkgtcYtqwmA+ESeDCiL91FygB0PkhEusugCiM4NlpbyZl+g9xWpUtWyPOrrB+uvHhyX4wl2ZYREU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+3aFuHO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+3aFuHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6471F000E9;
	Tue, 21 Jul 2026 19:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661770;
	bh=NxWlVBVfz/wzV/KmjorlAbvLxu9fRH1dNQjItdz6wcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v+3aFuHO6iIA+ClqBY32jPm1PkAT+WTig9LBrhDPaFf3+13Eny2zJNnt6Rm6FSyyw
	 QBQf6vd1Xxrmvz/V2nWj3XI1pF1tMz/PrdoViWm52wRoF7LScUbpyE/Ux+kNvAUDg4
	 cUuDJPpvQlAFkO09beRY//k6WC3iJyEPaKYfmgcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuri Andriaccio <yurand2000@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0193/1276] sched/deadline: Always stop dl-server before changing parameters
Date: Tue, 21 Jul 2026 17:10:36 +0200
Message-ID: <20260721152450.406064571@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit bb4700adc3abec34c0a38b64f66258e4e233fc16 ]

Commit cccb45d7c4295 ("sched/deadline: Less agressive dl_server
handling") reduced dl-server overhead by delaying disabling servers only
after there are no fair task around for a whole period, which means that
deadline entities are not dequeued right away on a server stop event.
However, the delay opens up a window in which a request for changing
server parameters can break per-runqueue running_bw tracking, as
reported by Yuri.

Close the problematic window by unconditionally calling dl_server_stop()
before applying the new parameters (ensuring deadline entities go
through an actual dequeue).

Fixes: cccb45d7c4295 ("sched/deadline: Less agressive dl_server handling")
Reported-by: Yuri Andriaccio <yurand2000@gmail.com>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Link: https://lore.kernel.org/r/20250721-upstream-fix-dlserver-lessaggressive-b4-v1-1-4ebc10c87e40@redhat.com
Stable-dep-of: 4043f5498416 ("sched/deadline: Reject debugfs dl_server writes for offline CPUs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/debug.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 7d14e9fa53ac3b..564ea17ae405e3 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -378,10 +378,8 @@ static ssize_t sched_fair_server_write(struct file *filp, const char __user *ubu
 			return  -EINVAL;
 		}
 
-		if (rq->cfs.h_nr_queued) {
-			update_rq_clock(rq);
-			dl_server_stop(&rq->fair_server);
-		}
+		update_rq_clock(rq);
+		dl_server_stop(&rq->fair_server);
 
 		retval = dl_server_apply_params(&rq->fair_server, runtime, period, 0);
 
-- 
2.53.0



