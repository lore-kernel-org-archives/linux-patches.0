Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABDE27E05E;
	Mon, 23 Mar 2026 15:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278417; cv=none; b=lGyJ3LuVfTKJwtIMNmiDWkkJnO/hv4ueLmHDIVXe2fQFH2EOmjbSpBDLhXHAiLfxd22SkxfqNlPMbpEsaxmN3DBUV9b1IlDspM9qflpv20WvDwS6lVsrNkfFYi19Lo6WLbi2RHIs2GjHXI+NpdBDmlMJ7ztGC9AdZlB84duZXv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278417; c=relaxed/simple;
	bh=IrT/NXMySSiHjv8XIdDEJhqJzehgAxVg6ASYQKxWnKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k12kWsEbc6bMWYAnnkUjUHciOhk8OSHy/t/MJaxDhiw78wUoyEQIxsPr0Kj0LlUp1j+7vlW21IfjyH+xlt+V2x4jN4uXm2h+HQScPVVPpVGozUft3XcA85q28rtjSMXOT9pwyIicYUuKfArTbOqO7c5K1MVPomLyeGiX/qpiKNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFQqvvOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFQqvvOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721B9C4CEF7;
	Mon, 23 Mar 2026 15:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278416;
	bh=IrT/NXMySSiHjv8XIdDEJhqJzehgAxVg6ASYQKxWnKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFQqvvOb+bAHsqdaVdX9or/lTaKu5ZZcg3FYq8+lqZo0vy/cPYRgNIrO8uzyZVz5f
	 wyVQx3bge4ZJ07nlKv0rHXAW4U+JhsQlB8zHHK4r2QZ1sftapXUO3KTZOFOUZCLzWr
	 kiIXq2x4S3PRzqOpuxXjD8O1O0ctmvjQh63lEm0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 301/567] time/jiffies: Mark jiffies_64_to_clock_t() notrace
Date: Mon, 23 Mar 2026 14:43:41 +0100
Message-ID: <20260323134541.266078047@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1ad88e97b4ebc..da7e8a02a0964 100644
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



