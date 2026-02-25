Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229B22701DA;
	Wed, 25 Feb 2026 01:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983781; cv=none; b=QEDey30FW4gBndUV1j2Wwqhg639119rD0HIzBBvtT941yx6yiFcGvb0YfF+cYPWgOqGPJZHeY4xnIiTAxLrHmni0Pk6omW9YjMRSbF2oBJvDOhNhDWjzvjP0H+Ogd6p78odra4ZRDq8Q07Aywir3evrWOqeYxp/9NRblxlFnVvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983781; c=relaxed/simple;
	bh=NDyI7V8PuaS/BkSLv+HMtxJz9y731LhEKIzkDOrlNyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wrd5Nina040XIwl8fkQ5Kw8tnSdurud36RckefjEjWHLJmpkldugHHaIXFVOUlHcbUlLhdQ6Z91c6S9eST4VS3LaahFWBoOwZTjHJ4xwthl0WP1f/0zfZUPvRmlQaPtEezy2VsTcN4RsoFIYbRU9ngfh+Rtt/iE6dBubNET6/d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPHUq5Fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPHUq5Fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A45C116D0;
	Wed, 25 Feb 2026 01:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983781;
	bh=NDyI7V8PuaS/BkSLv+HMtxJz9y731LhEKIzkDOrlNyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPHUq5FwVC68fFDQZVvYGDhewt8RCpTcdb7uxZ2wpLcNL+3/ZAvLUbJPPW+k9FOXq
	 Or+KIYTNAzx25/hlKKsAIN6L9i/i9ZfRzJ26Mz9cJ5BkSCDgRUjxtUsMRvIfmwPu8c
	 3mapNzfwzSCvDAN8pfTgP2j7aoqTOxZhSQ6Zm6MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/641] time/sched_clock: Use ACCESS_PRIVATE() to evaluate hrtimer::function
Date: Tue, 24 Feb 2026 17:16:36 -0800
Message-ID: <20260225012350.758855686@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit 3db5306b0bd562ac0fe7eddad26c60ebb6f5fdd4 ]

This dereference of sched_clock_timer::function was missed when the
hrtimer callback function pointer was marked private.

Fixes: 04257da0c99c ("hrtimers: Make callback function pointer private")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/875x95jw7q.ffs@tglx
Closes: https://lore.kernel.org/oe-kbuild-all/202601131713.KsxhXQ0M-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/sched_clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index cc1afec306b3f..425d429906d0d 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -215,7 +215,7 @@ void sched_clock_register(u64 (*read)(void), int bits, unsigned long rate)
 
 	update_clock_read_data(&rd);
 
-	if (sched_clock_timer.function != NULL) {
+	if (ACCESS_PRIVATE(&sched_clock_timer, function) != NULL) {
 		/* update timeout for clock wrap */
 		hrtimer_start(&sched_clock_timer, cd.wrap_kt,
 			      HRTIMER_MODE_REL_HARD);
-- 
2.51.0



