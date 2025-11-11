Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C285025F797;
	Tue, 11 Nov 2025 01:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824445; cv=none; b=SPMFPl3cv2aE5yJhdXM2h2YniMrmtFD5HC70uD4dp1v598lHX3zcv1P46JyRF6Z3eNeL8OJNcqISiprE/CorJZQelYFsL79d+YVharPEY4sYZI6Kv6btVRRfL/CeTtHa+VWoDpho8uUuXUthffSmZAWMvBa71EyzzwtINWfkIys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824445; c=relaxed/simple;
	bh=er7PZRM4G0R67ZMirWF4+mFTqfpkRtVjE2/oagXA78M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2Ui8p5DcnmnDGlXficjtFJwbYS4og6ZXIB+6HLN4InLU3DyI/FRf3IZq7hmt3JPJgZUf6Cq/pV5EqjI/EbtwUXl5NkYVNaa64NKZ1h2/4iqQ5BhUz9bT30ePYvy3ZfcWW3N9H5h4q5G0p3cg5DJ64nXpH9E6dt8kNnUm1iGW2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJylGDQw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJylGDQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0BFC4CEF5;
	Tue, 11 Nov 2025 01:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824445;
	bh=er7PZRM4G0R67ZMirWF4+mFTqfpkRtVjE2/oagXA78M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJylGDQwS44HWstJD8eq+fYnCMAypXZsUriTEkUogUrKJ74KwQuDi5TgSua7ObY9E
	 Ap7goE+nEroU4Rno4/laEido8coXoMhdHy0eFXO/5BWa2eRqhR0o9lPVLIeCcC7gwu
	 OuXjEN0Y8Z3u5R8Q+ev2YNGzIQL3aPXfi2uwKV44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Riabchun <ferr.lambarginio@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 447/565] ftrace: Fix softlockup in ftrace_module_enable
Date: Tue, 11 Nov 2025 09:45:03 +0900
Message-ID: <20251111004536.944575588@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Vladimir Riabchun <ferr.lambarginio@gmail.com>

[ Upstream commit 4099b98203d6b33d990586542fa5beee408032a3 ]

A soft lockup was observed when loading amdgpu module.
If a module has a lot of tracable functions, multiple calls
to kallsyms_lookup can spend too much time in RCU critical
section and with disabled preemption, causing kernel panic.
This is the same issue that was fixed in
commit d0b24b4e91fc ("ftrace: Prevent RCU stall on PREEMPT_VOLUNTARY
kernels") and commit 42ea22e754ba ("ftrace: Add cond_resched() to
ftrace_graph_set_hash()").

Fix it the same way by adding cond_resched() in ftrace_module_enable.

Link: https://lore.kernel.org/aMQD9_lxYmphT-up@vova-pc
Signed-off-by: Vladimir Riabchun <ferr.lambarginio@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 370cde32c696e..f7208f2525447 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7396,6 +7396,8 @@ void ftrace_module_enable(struct module *mod)
 		if (!within_module(rec->ip, mod))
 			break;
 
+		cond_resched();
+
 		/* Weak functions should still be ignored */
 		if (!test_for_valid_rec(rec)) {
 			/* Clear all other flags. Should not be enabled anyway */
-- 
2.51.0



