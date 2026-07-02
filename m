Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CA024E4C3;
	Thu,  2 Jul 2026 16:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011251; cv=none; b=HiEF1bKI4l5RABljnkO1x1gKmHeBH32hHMk+9Vc6TXvzpyZQO3/Dgasmps3zBsJB90lBfi3RmGAw2khQ9m7MS9iM8HPRrd6cBWYyd8DYTsZASNlsWiOhe06HmtzW/kOqWE4cw86tdl/TZc/z6NR5f5iXe2cifM5G8XbEYT+Ntb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011251; c=relaxed/simple;
	bh=CzVQE0bo1gvPy9iEDmW+1Nag6emEmgKivl4CF80AiJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaSale7ICghnbCrwGXQfgZRbEhH5UJDRRhTPFsB1Vg6Ho9qNsfvBDsXo3dhN+4RuuYcZ1cx6wiNhxI3AOiyfvW8KELr0VpvJB2hjMQ+hvFZZu3kDGeXpcWDNIarzj/TMP3P1vHncrKfRRPG+YW7po9TVzsBgBsvpj6ISR/00huY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3kALPOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3kALPOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205A81F000E9;
	Thu,  2 Jul 2026 16:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011249;
	bh=zDbBn/h/JpXuW/1aXUh3fpQcsCBhnb3r1cuqpp/RI/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3kALPOBmwqyrKoeIzSRtA9hEI83rl7KJ3+Hh1rHbTqhNqLSivOZ+BlkQwDS/j0Ge
	 kFBYagbMWuKORr2m6d3ydiRhe/0rvwT4Jt4CmhcW/a8dKs0faJOTId19tREHrBIO+q
	 dytVyaulKcPecAP+yWOBfvbUO0hyIj94ZlJeQLlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Ushakov <sysroot314@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/108] af_unix: Set gc_in_progress to true in unix_gc().
Date: Thu,  2 Jul 2026 18:20:33 +0200
Message-ID: <20260702155112.855621743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit d82ba05263c69fa2437fe93e4e561cc40f4c03af ]

Igor Ushakov reported that unix_gc() could run with gc_in_progress
being false if the work is scheduled while running:

  Thread 1         Thread 2                     Thread 3
  --------         --------                     --------
                   unix_schedule_gc()           unix_schedule_gc()
                   `- if (!gc_in_progress)      `- if (!gc_in_progress)
                      |- gc_in_progress = true     |
                      `- queue_work()              |
  unix_gc() <----------------/                     |
  |                                                |- gc_in_progress = true
  ...                                              `- queue_work()
  |                                                       |
  `- gc_in_progress = false                               |
                                                          |
  unix_gc() <---------------------------------------------'
  |
  ... /* gc_in_progress == false */
  |
  `- gc_in_progress = false

unix_peek_fpl() relies on gc_in_progress not to confuse GC
by MSG_PEEK.

Let's set gc_in_progress to true in unix_gc().

Fixes: 8b90a9f819dc ("af_unix: Run GC on only one CPU.")
Reported-by: Igor Ushakov <sysroot314@gmail.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260501073945.1884564-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Add setting gc_in_progress in __unix_gc(). Keep the existing
  set in unix_gc() for wait_for_unix_gc() over-limit throttling. ]
Signed-off-by: Igor Ushakov <sysroot314@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/garbage.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 529b21d043d927..39867170902662 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -606,6 +606,8 @@ static void __unix_gc(struct work_struct *work)
 	struct sk_buff_head hitlist;
 	struct sk_buff *skb;
 
+	WRITE_ONCE(gc_in_progress, true);
+
 	spin_lock(&unix_gc_lock);
 
 	if (unix_graph_state == UNIX_GRAPH_NOT_CYCLIC) {
-- 
2.53.0



