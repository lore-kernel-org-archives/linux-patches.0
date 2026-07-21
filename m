Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7A545BD4E;
	Tue, 21 Jul 2026 15:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648813; cv=none; b=oU13bm6ByjjaOxocVfCsDMyhv6bl81lKrQCh9PagYYjFt51Oy2sW4URGkNru+sZyLe57Lbv/G6AyBiJS2qLaVyfrM5AyqSdlCVj7qYzvq5/rOuWkqQeh4i/zfOPZCE5Hsi6f7GY9ymF2w2fiC7MrlurPlbl0Qw76xJ4XSAUeyGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648813; c=relaxed/simple;
	bh=Ev7xXxjUYQ7fX8eRLFigsGJlJQdGfzmCkhTDhND/+RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucvYRW9nCKUiAJQGGrp4jOfmEPCVtNvQnjTf9caM2df+Di5iMVAjLVCCwukBHwW7N78ShgSvx+KWS49Hp5pSJTArEb9q5QC320TOLwtchSrZREHfB3efgU2tBJc9z+yywzAKhpyztQI+5Vq9ZQRaHZ8G5WAYmmxY8Ps0+BKvAPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXU1ivmP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXU1ivmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9271F000E9;
	Tue, 21 Jul 2026 15:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648812;
	bh=0lunfYwj3wmRaItierXNZqPVj/UV08v0MRjDFOAXxfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXU1ivmPseht3ZF42DmwPKUanFS/j4KQu/YVhksqIexFTK44AhhO/9Ynusz1JC0MU
	 WKME5u3GhDyI5Y+6G6qEBN81hkt5FbtQiRz08doirvQx+PAPJ9ZxSgWOKUKAm/3LFn
	 Q/ZsCen2iPO5C+3AfD/SlPvXtU9GyWm8zZqHECsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0341/2077] rtla/actions: Restore continue flag in actions_perform()
Date: Tue, 21 Jul 2026 17:00:14 +0200
Message-ID: <20260721152600.727900681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit dd520daffbc901f10d49a51a58313547d417b506 ]

Currently, actions_perform() only ever sets the continue flag (when
performing the continue action), but never resets it. That leads to
RTLA continuing tracing even if the continue action was not performed in
the current iteration.

For example, the following command:

$ rtla timerlat hist -T 100 --on-threshold shell,command='
    echo Spike!
    if [ -f /tmp/a ]
    then
      exit 1
    else
      touch /tmp/a
    fi' --on-threshold continue

should print Spike! at most once, because after hitting the threshold
for the first time, /tmp/a exists, the shell action will fail, and the
continue action is not performed. However, unless /tmp/a exists before
the measurement, it will print Spike! until stopped, as the continue
flag stays set.

Set the continue flag to false in the beginning of actions_perform() to
make RTLA continue only if the action was actually performed.

Fixes: 8d933d5c89e8 ("rtla/timerlat: Add continue action")
Link: https://lore.kernel.org/r/20260526102523.2662391-1-tglozar@redhat.com
[ correct Fixes tag to include 12 characters of hash ]
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/actions.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/tracing/rtla/src/actions.c b/tools/tracing/rtla/src/actions.c
index b0d68b5de08db2..bf13d9d68f1694 100644
--- a/tools/tracing/rtla/src/actions.c
+++ b/tools/tracing/rtla/src/actions.c
@@ -247,6 +247,8 @@ actions_perform(struct actions *self)
 	int pid, retval;
 	const struct action *action;
 
+	self->continue_flag = false;
+
 	for_each_action(self, action) {
 		switch (action->type) {
 		case ACTION_TRACE_OUTPUT:
-- 
2.53.0



