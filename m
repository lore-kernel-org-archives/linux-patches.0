Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A872303A32;
	Tue, 17 Mar 2026 17:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767890; cv=none; b=b1Ob1ki7Zntii/AxfTdt6YIiRvRKplV1x6PolXQani/8mJoLCVxMrippeQNIF08o6JbSTqj45CUUPefgAxz4cnTDWKr7m1eAJd/3Ml+5zIuL2mqJoEWtroxgtyy8lF+b6fE0dKU/fLBcRsvn3rxrrnSZ7Mfxy3v9NcE3adF12NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767890; c=relaxed/simple;
	bh=ATfZ/1XNfiZmCghPtRJ0eksf3sEGAx7sIlkv6S/RljU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBOsKRSu5s1kF/V8+msjJBFoy4IylxH3LJb0jWZftWhtjPC9c6pdmn2buMPsj4fw2/TLgGRxqPPQx+1s4lr8X2iMKFEM1VavVZq36fwZQPSjE7ooOzUzrP278lJgbCF2THFkAQ0fbUJbta4oCrBB6aIsAGqcNGaxgKWgKSnBKDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wEtVkqWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEtVkqWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C14C4CEF7;
	Tue, 17 Mar 2026 17:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767890;
	bh=ATfZ/1XNfiZmCghPtRJ0eksf3sEGAx7sIlkv6S/RljU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEtVkqWgrsnIaMlSJPJSwFCHIn8d7w5tsKfs60GgAeUUbzSkjPulrPRmuNuzp3MFy
	 MZC2UsRiAw+y+zTUrYVwSTHfqTNIGN4YSyYh4AZjzmTNa8Izt+K/8M3rhHBDvZ7p07
	 4qT/qWjj/wNr4NLyT6rtfW6We1RiW5oFxqBBFyEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 174/333] time/jiffies: Mark jiffies_64_to_clock_t() notrace
Date: Tue, 17 Mar 2026 17:33:23 +0100
Message-ID: <20260317163005.809942590@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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



