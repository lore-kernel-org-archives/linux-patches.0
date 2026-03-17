Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8DF3ED106;
	Tue, 17 Mar 2026 16:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766168; cv=none; b=JV9s3GeH0a6Lp2FCK5iT5zunppkFoJdZIfpcSa1AuDavJ1tLgW1tH353VOfbjl0G2Lb2f9L7vwIojwLB5thmNm7DCKwguRB1fuvLwkb/eYcNl6e3h14/TXf0JrfTaLoPTgfyuqBLszmgTdM+JdHf+FJEYcEkr237zL2Edz8+Uwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766168; c=relaxed/simple;
	bh=SOiUHUCNbVjiOnf/FI+NDoBuXBoZMLaXAlP7tIvVkvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfg5D8K384qAXcnHw4vNdEwLpBoaSncS+k+uMcW7QJ9uPvfY6mq8eEcyvbyTksy8kiv4FeXlqAYD6tjucY6SElHbz2eW6bR21K+gHPr7iQcytvGUs/hgCaeZRJXSlovNyWpekrV+Ihp0Qx9INCgHBNl2E6chbzdkG3KOzSyZJbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXvMkUSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXvMkUSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1605C4CEF7;
	Tue, 17 Mar 2026 16:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766167;
	bh=SOiUHUCNbVjiOnf/FI+NDoBuXBoZMLaXAlP7tIvVkvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXvMkUSrtTcIQSujU9JxQigMBuaJiX36orytmumLNtoFdImmvaNEj35VXeei/axyd
	 Jsx0KVk59zcCTT8yt3f6G1j/87sGwDftVKndppQvtwVLWzqPtG/f/CImKbd1bm8M3a
	 VNKRMNc8t2GNQM0npmAfhd76yk9gNvvKkKYCyYXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 184/378] time/jiffies: Mark jiffies_64_to_clock_t() notrace
Date: Tue, 17 Mar 2026 17:32:21 +0100
Message-ID: <20260317163013.776992020@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 0ba8e3c50d625..155cf7def9146 100644
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



