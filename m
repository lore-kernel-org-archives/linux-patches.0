Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9028D267F5B;
	Tue,  8 Apr 2025 11:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110519; cv=none; b=N0QKjrlFRsVGvtJnn67oTG9PiMDHxWhjRkfljsmhNhK6c6BPR8+N1NnX1/W5XWMSw8xVVO/MEvQMx66QYQBJa82GW/7wlSZCLdNClhzhQKZ+jRLhTD/nCmTCARzN0mqkWHkZCW3/pQa4XgBTAxKgvokzR6s0eX9sNAcBBiv0+KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110519; c=relaxed/simple;
	bh=uzX5zqLgFAJQbJ3LvienJVzjyQH7m+jRQYI2AB0cV34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=civ3AoM98CWVwI1kWD5PlJ8/U6ur6gQXFuGRTwZ6+Kma4+tkHJ371CfUqTMfAgGScnEcoIepawpFJMUsLA2nZYResFa5aRdnK8pXkcKXkmMBfIH7BLFi5LffutiOm3/yxysoa6uXj2tc+PU7ne/7rP1lluj9urFfER0eNGpp/sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdcw4lhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdcw4lhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E4BC4CEE5;
	Tue,  8 Apr 2025 11:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110519;
	bh=uzX5zqLgFAJQbJ3LvienJVzjyQH7m+jRQYI2AB0cV34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdcw4lhp1fxGbBb2NAQCypFLISc7C2MVcTP7OA24AMfyVOWh8IAj6Bxg2bZ7W2jFm
	 6FVnnE7LRaZjKXZF4YA9BsNf0OHITJoOp1oI4cx68lwp8AstKTaNxg2uo8BcTISQlh
	 wE8pphS9OjrIcgAZy9k345u7FhiWy73BFrZHeBzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 095/731] coredump: Fixes core_pipe_limit sysctl proc_handler
Date: Tue,  8 Apr 2025 12:39:52 +0200
Message-ID: <20250408104916.479339371@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>

[ Upstream commit 049439e22825507a90d4dedf3934e24fd0a8ff62 ]

proc_dointvec converts a string to a vector of signed int, which is
stored in the unsigned int .data core_pipe_limit.
It was thus authorized to write a negative value to core_pipe_limit
sysctl which once stored in core_pipe_limit, leads to the signed int
dump_count check against core_pipe_limit never be true. The same can be
achieved with core_pipe_limit set to INT_MAX.

Any negative write or >= to INT_MAX in core_pipe_limit sysctl would
hypothetically allow a user to create very high load on the system by
running processes that produces a coredump in case the core_pattern
sysctl is configured to pipe core files to user space helper.
Memory or PID exhaustion should happen before but it anyway breaks the
core_pipe_limit semantic.

This commit fixes this by changing core_pipe_limit sysctl's proc_handler
to proc_dointvec_minmax and bound checking between SYSCTL_ZERO and
SYSCTL_INT_MAX.

Fixes: a293980c2e26 ("exec: let do_coredump() limit the number of concurrent dumps to pipes")
Signed-off-by: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/coredump.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 4375c70144d0a..4ebec51fe4f22 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1016,7 +1016,9 @@ static const struct ctl_table coredump_sysctls[] = {
 		.data		= &core_pipe_limit,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{
 		.procname       = "core_file_note_size_limit",
-- 
2.39.5



