Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B75628E613;
	Wed, 23 Apr 2025 15:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420801; cv=none; b=bQmGp9/vbDGAXnd46CvX4lbHemee5HIcmPslVfxmNTOUkhBZoKmBIpQ2+hK/cvZOdC6qvrbX+v6BsNlmj+9OzYiSRq4Yow9N0z7osByR2J+aAM/LkhCgEkcZbXwORX/fCwuTFTpAM7P5DHP0qXaMNglDkjxYTdlJ/dAZhFzNgiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420801; c=relaxed/simple;
	bh=7Y2VH2DM89Je1lveUwpO/GybBdW5V6FR6RwoQhmZMps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+sQWtBioNH7FwaxxdB7hwYCBJmjDyPK4ME+vMI/Cdn6kdsjvKliDW5v4wgMWcS+Qjqhuxh8fxHJLOXybgOzgzS7vZhBEtM9iRQD9y6P27ull72YBTjj7Oe0Ji/SBBOGhbvYI2FqFXUoPXQTtaxuyKsntJQpuL6/L8Ikf8GXoZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGAIRqoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGAIRqoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30CDC4CEE2;
	Wed, 23 Apr 2025 15:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420801;
	bh=7Y2VH2DM89Je1lveUwpO/GybBdW5V6FR6RwoQhmZMps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGAIRqoy87sS1Q1qb74orB2y8RhoLp5UmqFiOo5W1FEup8THR6GJjGX+ZGp7uLjTN
	 3AqGCeJMpNrlq1vuCcSJ7DFaLyIXc3m4AlUZwtO7KEBAvTkaRWryv0eymW/rB0Rxzr
	 ezTHnhitBZxS3koTl0h3o0HI49VZSNH5obdd/c5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 123/241] ftrace: fix incorrect hash size in register_ftrace_direct()
Date: Wed, 23 Apr 2025 16:43:07 +0200
Message-ID: <20250423142625.602006598@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit 92f1d3b40179b15630d72e2c6e4e25a899b67ba9 ]

The maximum of the ftrace hash bits is made fls(32) in
register_ftrace_direct(), which seems illogical. So, we fix it by making
the max hash bits FTRACE_HASH_MAX_BITS instead.

Link: https://lore.kernel.org/20250413014444.36724-1-dongml2@chinatelecom.cn
Fixes: d05cb470663a ("ftrace: Fix modification of direct_function hash while in use")
Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 62d300eee7eb8..201e770185dde 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5912,9 +5912,10 @@ int register_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
 
 	/* Make a copy hash to place the new and the old entries in */
 	size = hash->count + direct_functions->count;
-	if (size > 32)
-		size = 32;
-	new_hash = alloc_ftrace_hash(fls(size));
+	size = fls(size);
+	if (size > FTRACE_HASH_MAX_BITS)
+		size = FTRACE_HASH_MAX_BITS;
+	new_hash = alloc_ftrace_hash(size);
 	if (!new_hash)
 		goto out_unlock;
 
-- 
2.39.5



