Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132AB3BD659;
	Sat, 12 Sep 2026 10:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210756; cv=none; b=BGpZ5KGx9v3JK2CHEnOWShRJt2PyyJFMK2fL8EB7matiMBoZOSWwhWHYHXlCXJdFfLU3Jfvwa9dq9FPRqWFLl9LyYGcD4EY5s+MGmrVHJidmm8N+RUsHE/M1Jj+e/nSx/mqSHqXVPboXBoeAmSqlD4qjDxJKQDJH4f2cifNsFS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210756; c=relaxed/simple;
	bh=o2IGx/98wjFfgbqi0Ra+t0hwu6lE3U/x98A2BDrHEn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIZgBGtSxY1AirvH5yo9Wjz+kaEM6Agz55Q3ztoqwSeex0rQ4KUQhtTF3VAKx53XcM+6PYuakJ5Oeptrl+2wzv5gjUH9ahfEhP+lR5RVcD2Q6dsK0F/Ddr2dGfd2uxCsTHpBmUWEgc5CVd2772v8TJUB5Wanef6trgWCsnRCp50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvKkvyRH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvKkvyRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09061F000FF;
	Sat, 12 Sep 2026 10:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210755;
	bh=nvy/i9ly7Z4SOwKc7d8s65vh5exConJE79nLJbgGnTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nvKkvyRHujHtv57SJXjqyH7C3xKxc1P2TUbSy85VjTOQI/FYM5DxcjkBPigxqsGOm
	 QeFBmAA3OH4zl7C+ghXDw9rt+ooWlDu7Rl6YhJbfdp1MLKbTOSPGpWCRLEUYxllAX4
	 +DNd2amub0vCporAgauudpyzd55Fb8cc9M8GM7H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Luo <luoliang@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1090/1518] selftests/sched_ext: Check skeleton open failure in exit test
Date: Sat, 12 Sep 2026 08:54:19 +0200
Message-ID: <20260912065648.109419405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Liang Luo <luoliang@kylinos.cn>

[ Upstream commit 4dc310b41aba43e9d8dfafe46dce86f8b55c0354 ]

exit.c does not check the return value of exit__open(). If it returns
NULL, which happens when the skeleton wrapper fails to allocate the
object or open the BPF ELF, the very next line dereferences it via
SCX_ENUM_INIT(). That macro expands to SCX_ENUM_SET(), which accesses
skel->rodata, causing a NULL pointer dereference.

Every other selftest guards this with SCX_FAIL_IF(!skel, ...); exit.c
is the only one missing it.

Fixes: a5db7817af78 ("sched_ext: Add selftests")
Signed-off-by: Liang Luo <luoliang@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sched_ext/exit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/sched_ext/exit.c b/tools/testing/selftests/sched_ext/exit.c
index b987611789d16..01b17092d5c8f 100644
--- a/tools/testing/selftests/sched_ext/exit.c
+++ b/tools/testing/selftests/sched_ext/exit.c
@@ -31,6 +31,7 @@ static enum scx_test_status run(void *ctx)
 			continue;
 
 		skel = exit__open();
+		SCX_FAIL_IF(!skel, "Failed to open");
 		SCX_ENUM_INIT(skel);
 		skel->rodata->exit_point = tc;
 		SCX_FAIL_IF(exit__load(skel), "Failed to load skel");
-- 
2.53.0



