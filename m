Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CFA24DCF6;
	Mon, 13 Apr 2026 16:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097538; cv=none; b=kN4i9w+GbMr6n6F5nI/+2Ckhv6Up6YR3t6fel98uo5Tm9FTeN2sXi0OAOswv1lWT3jJlrDw7zdSbTf2A4eL1pt9tbllemCowQJOGuNpx5ypTZ6fkWwGrZpbscmfpPuAMjcIXFuHJGBMqgYJVyoZVdXmCCx2HjqV+z4PfxfZ7GG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097538; c=relaxed/simple;
	bh=QpR0Q3kibLprz9XlSjVkh4aLV0W1IJYRxhAnTKKkjpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxlK8E43O2dVJPgULEv0boF3XNuo7ctgFGA3Vh6y02GWLnXhbVQ5Fm59sY7gbqRUOHFXI0aimLVx7UHc3hgxjF1dN+5yZ1C5bYl2QAglrUhCmCpKyI+v+74SspKA/rhuQaFE9cL3pWhigRx8QF2dBcoDRNue7ogC1IgCjKXfvds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgCi33pt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgCi33pt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C035BC2BCB3;
	Mon, 13 Apr 2026 16:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097538;
	bh=QpR0Q3kibLprz9XlSjVkh4aLV0W1IJYRxhAnTKKkjpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgCi33pthZQtZJc6Aq2CNimLGf6L1v3YrBM3Zlqq4WXCmQxHLUbygEumgJ5o3ooEZ
	 2/hWhbkfH/Q72ZMn36pA3lsZAywNhcvXGAeo+H2c6F1CDMqjneffjLOkhCBV+0QsoC
	 XdE1qW+PG0ZPaOP2s//adPuHAmTE44NgJ/I7W/dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/570] time/jiffies: Mark jiffies_64_to_clock_t() notrace
Date: Mon, 13 Apr 2026 17:54:49 +0200
Message-ID: <20260413155836.370935549@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 755a648e78f12574482d4698d877375793867fa1 ]

The trace_clock_jiffies() function that handles the "uptime" clock for
tracing calls jiffies_64_to_clock_t(). This causes the function tracer to
constantly recurse when the tracing clock is set to "uptime". Mark it
notrace to prevent unnecessary recursion when using the "uptime" clock.

Fixes: 58d4e21e50ff3 ("tracing: Fix wraparound problems in "uptime" trace clock")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260306212403.72270bb2@robin
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/time.c b/kernel/time/time.c
index 50390158e9d97..df582f24f0d7b 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -702,7 +702,7 @@ EXPORT_SYMBOL(clock_t_to_jiffies);
  *
  * Return: jiffies_64 value converted to 64-bit "clock_t" (CLOCKS_PER_SEC)
  */
-u64 jiffies_64_to_clock_t(u64 x)
+notrace u64 jiffies_64_to_clock_t(u64 x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
 # if HZ < USER_HZ
-- 
2.51.0



