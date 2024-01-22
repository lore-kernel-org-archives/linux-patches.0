Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A6A130E42;
	Tue, 23 Jan 2024 00:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969075; cv=none; b=upol9QNDfA/iBzCoVRheIvwvkYpPGLSz13fUwrZBZsTgJ4wZBd5/XDVvTwX0mFYxTuI6Ck+pa+EH2a9rjBbn5dXDrvC8R3prFO6pLWzjlIgqKFgowTYKLdk0zQfXFtYOibakYDWcfJaD6ZgSoSS65D04QtAPdh7kcFdfK7JlqoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969075; c=relaxed/simple;
	bh=fAV0opdsiXYjkBShC6U0lPP9yvyoIK5Q6nU9ZtH2eXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2YONvujkQvgOhjwddDWHxCvCQzCu+WMICmYtx44093KKEJzWuJ1GqL99kUcfXa9NcEYBTePWp4TLs9l6458gXEQpjgQ65T22Dw7PWWrZI8WDv9weB6po/fTWX7ZMg8cLpdRVKDukZ5t3Xa8W7QMF/M4gGv71dja1l2bOIcl+yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjFPJHHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjFPJHHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB044C433F1;
	Tue, 23 Jan 2024 00:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969075;
	bh=fAV0opdsiXYjkBShC6U0lPP9yvyoIK5Q6nU9ZtH2eXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjFPJHHNjA1vkGOhSYOuIn0LhddjTgQuErCeaYUlRYTl7BR5ezVb5pGMVB+AXMmt3
	 sWMdiGrkq57CHaqW6fyKg3mMJvbeCqbhcZGIPtD05SnmZdKNBlVgVyQKbQ4uRFGCeJ
	 /zziYawkYpec/w8dXkCGQNiXgyrFQVjcpBvw9Ls8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Xiayang <xywang.sjtu@sjtu.edu.cn>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 189/194] kdb: Censor attempts to set PROMPT without ENABLE_MEM_READ
Date: Mon, 22 Jan 2024 15:58:39 -0800
Message-ID: <20240122235727.324232473@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Thompson <daniel.thompson@linaro.org>

[ Upstream commit ad99b5105c0823ff02126497f4366e6a8009453e ]

Currently the PROMPT variable could be abused to provoke the printf()
machinery to read outside the current stack frame. Normally this
doesn't matter becaues md is already a much better tool for reading
from memory.

However the md command can be disabled by not setting KDB_ENABLE_MEM_READ.
Let's also prevent PROMPT from being modified in these circumstances.

Whilst adding a comment to help future code reviewers we also remove
the #ifdef where PROMPT in consumed. There is no problem passing an
unused (0) to snprintf when !CONFIG_SMP.
argument

Reported-by: Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Stable-dep-of: 4f41d30cd6dc ("kdb: Fix a potential buffer overflow in kdb_local()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 7c96bf9a6c2c..f8f087193644 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -452,6 +452,13 @@ int kdb_set(int argc, const char **argv)
 	if (argc != 2)
 		return KDB_ARGCOUNT;
 
+	/*
+	 * Censor sensitive variables
+	 */
+	if (strcmp(argv[1], "PROMPT") == 0 &&
+	    !kdb_check_flags(KDB_ENABLE_MEM_READ, kdb_cmd_enabled, false))
+		return KDB_NOPERM;
+
 	/*
 	 * Check for internal variables
 	 */
@@ -1355,12 +1362,9 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 		*(cmd_hist[cmd_head]) = '\0';
 
 do_full_getstr:
-#if defined(CONFIG_SMP)
+		/* PROMPT can only be set if we have MEM_READ permission. */
 		snprintf(kdb_prompt_str, CMD_BUFLEN, kdbgetenv("PROMPT"),
 			 raw_smp_processor_id());
-#else
-		snprintf(kdb_prompt_str, CMD_BUFLEN, kdbgetenv("PROMPT"));
-#endif
 		if (defcmd_in_progress)
 			strncat(kdb_prompt_str, "[defcmd]", CMD_BUFLEN);
 
-- 
2.43.0



