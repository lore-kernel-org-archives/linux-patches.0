Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AEA2EF9B1;
	Tue, 15 Jul 2025 13:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587849; cv=none; b=V8fN2lpq7CzWPb1TVQ+E3XK/lR/PFnd+oHE3/8z+qTCnu4FGfmQ/HNhljnBHtUDWu0WZbvGzarDMcC+ZQ6oHo9svgFPmyqpbkPmUevmg8hmwIelDm6BsdJzVZ6e/SEZAw/f66LPTssy4hZH3la5ykGVua+GxgaBDLGlJrtZVU5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587849; c=relaxed/simple;
	bh=1OWtpkLJMr6ckjGdYz9aiIfn5antmJ+kQCpX3LEg6kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjEVBPJXfy8aX9NK07cZk7x1B8aDEa7JHLLeCLHRlbto3luIlhLbo8RipsQXwP0ROFpEjslgmbvfwyvQPe4LyvlgRNQs9ZVlXrAvyIlS0mqlmqX0CHJweSjnJ1kciK1gYxwSyH8kF9i+6Wg+xOrAVi0e3JkmBGaaqgCstBQCk1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=icF4d1E2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="icF4d1E2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D57C4CEE3;
	Tue, 15 Jul 2025 13:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587849;
	bh=1OWtpkLJMr6ckjGdYz9aiIfn5antmJ+kQCpX3LEg6kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icF4d1E2mexzd69aix2gNnOAxr7d8f6rKYzRZjq56zrAJZ88p1BW8KdvKYjzvXWj5
	 vNS+onvVR3E4KikWnmG5IG/k7VSa9/Vq8dwfvsqhNsGvJpQKIjp1iAD78iKXD1rJje
	 oxajdsd988Z93/ehU13LGex6ldBM+3HGBTgQvjRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/208] perf: Revert to requiring CAP_SYS_ADMIN for uprobes
Date: Tue, 15 Jul 2025 15:14:04 +0200
Message-ID: <20250715130816.342188609@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit ba677dbe77af5ffe6204e0f3f547f3ba059c6302 ]

Jann reports that uprobes can be used destructively when used in the
middle of an instruction. The kernel only verifies there is a valid
instruction at the requested offset, but due to variable instruction
length cannot determine if this is an instruction as seen by the
intended execution stream.

Additionally, Mark Rutland notes that on architectures that mix data
in the text segment (like arm64), a similar things can be done if the
data word is 'mistaken' for an instruction.

As such, require CAP_SYS_ADMIN for uprobes.

Fixes: c9e0924e5c2b ("perf/core: open access to probes for CAP_PERFMON privileged process")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/CAG48ez1n4520sq0XrWYDHKiKxE_+WCfAK+qt9qkY4ZiBGmL-5g@mail.gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b133abe23a4b1..bf9f9eab6f67f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9823,7 +9823,7 @@ static int perf_uprobe_event_init(struct perf_event *event)
 	if (event->attr.type != perf_uprobe.type)
 		return -ENOENT;
 
-	if (!perfmon_capable())
+	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
 	/*
-- 
2.39.5



