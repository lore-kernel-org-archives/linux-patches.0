Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0095B1FBF;
	Tue, 23 Jan 2024 02:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975804; cv=none; b=E18su+7FQUwRbmw639BfuomnaOy6kaaAOMuRRnekoAOeKscGng/GhrW60+Ttf5ijszGhCzXnqZul9x4y2gOeIGrB0leRahL6GHpr34qKKi9T8jsfyuvZ34TAVUJDB26QkjsAskJKwcV07WYZxWUk/BDo7DRZOQ2DDGrWGTOLQFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975804; c=relaxed/simple;
	bh=MuvmWwLJAT1CPr1RizmHMYj4Jb8aOiYXv8dWFJ9m6uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxqjPiC43DvtJDC+Kkiw/wzkiWGcW8zFHNZs67/ngdKkemK4mnYgGDPLzmb3j3Eo3bKQLEWkn8PT1nUXy4LDKiDLUuMUtasA95bTIqZ0shgJEbdnBa9LIx/94PEeZ/t9BQwci06r5fuZQj8N6fOJD8k+uaiWhef7L8V+ZgIiV1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrzYtJVT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrzYtJVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32E1C43390;
	Tue, 23 Jan 2024 02:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975803;
	bh=MuvmWwLJAT1CPr1RizmHMYj4Jb8aOiYXv8dWFJ9m6uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrzYtJVTKDtfhQjaIAJCYwSRWywnRnZp6IJppWTnpImILivno3zbtY5BSVkoYsPCV
	 TMNj9p/NAWdFk5oo3wHLPf1OrFstuRpXSQBoN4rsWhK6s9dHJh8d6ptHc8cQdrDaH6
	 VZGqWh5KMqxt6rZXAXvl8UIf68o7cYzfl26d2JZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 572/583] arm64/ptrace: Dont flush ZA/ZT storage when writing ZA via ptrace
Date: Mon, 22 Jan 2024 16:00:23 -0800
Message-ID: <20240122235829.689365677@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit b7c510d049049409e8945b932f4b0b357fa17415 ]

When writing ZA we currently unconditionally flush the buffer used to store
it as part of ensuring that it is allocated. Since this buffer is shared
with ZT0 this means that a write to ZA when PSTATE.ZA is already set will
corrupt the value of ZT0 on a SME2 system. Fix this by only flushing the
backing storage if PSTATE.ZA was not previously set.

This will mean that short or failed writes may leave stale data in the
buffer, this seems as correct as our current behaviour and unlikely to be
something that userspace will rely on.

Fixes: f90b529bcbe5 ("arm64/sme: Implement ZT0 ptrace support")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240115-arm64-fix-ptrace-za-zt-v1-1-48617517028a@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/ptrace.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 20d7ef82de90..b3f64144b5cd 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1107,12 +1107,13 @@ static int za_set(struct task_struct *target,
 		}
 	}
 
-	/* Allocate/reinit ZA storage */
-	sme_alloc(target, true);
-	if (!target->thread.sme_state) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	/*
+	 * Only flush the storage if PSTATE.ZA was not already set,
+	 * otherwise preserve any existing data.
+	 */
+	sme_alloc(target, !thread_za_enabled(&target->thread));
+	if (!target->thread.sme_state)
+		return -ENOMEM;
 
 	/* If there is no data then disable ZA */
 	if (!count) {
-- 
2.43.0



