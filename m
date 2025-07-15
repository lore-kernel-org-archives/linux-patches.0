Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E9B2EBBB7;
	Tue, 15 Jul 2025 13:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586695; cv=none; b=ZlHHnvQpgdEyRjBH1mEAGEYDHUba+7VvW+RB2bBDqDnU80bjvo/jk27NO273xolxCp/MWXKKkRoOm6Ms4tV5OS5MYT0YxL3EaBeyepdf8RIMBeVJqTNkXYAGCeotfvBlszOeOs0mqwT+ykS94tfDSLgjTJpw89hxAusmH0hYf0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586695; c=relaxed/simple;
	bh=pzuve52sQ/8WyDHODI5wpKCfeoyBa+VipjYHE9QVO94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoeheFkxIdf5/W6+9/pS3UguCmsUPwOdiWWSuhOjzf5XlB4+3BZF5Cg77Mls9budAA8K3toMp7QRg2q9HlgSiEliXdJxgDTz96JGsL6YKo/TQq0KzNjTRPcQcQLUc3XMhPVVqJJbeXZqy83z5BxCBFh2OwxE5wd58rDzh5kJYMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oua/2D1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oua/2D1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0F8C4CEE3;
	Tue, 15 Jul 2025 13:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586695;
	bh=pzuve52sQ/8WyDHODI5wpKCfeoyBa+VipjYHE9QVO94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oua/2D1BvoRbFQdTnuR8ECIIQ0ldpOToPkBCP9xpYuGfvgxbGyY7ZDMzq3BRfuIQd
	 DJbIu17iztBIHc1bIadKLiLdwxexGvI7p1uw1acchVzwISATYIsOOl6Qo6XA9FjQPG
	 tQmJub5n6afza9qrffduZ7RkIiN0Nq1IezEtYpHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 014/192] perf: Revert to requiring CAP_SYS_ADMIN for uprobes
Date: Tue, 15 Jul 2025 15:11:49 +0200
Message-ID: <20250715130815.434960868@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 53d2457f5c08a..5a2ed3344392f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11050,7 +11050,7 @@ static int perf_uprobe_event_init(struct perf_event *event)
 	if (event->attr.type != perf_uprobe.type)
 		return -ENOENT;
 
-	if (!perfmon_capable())
+	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
 	/*
-- 
2.39.5



