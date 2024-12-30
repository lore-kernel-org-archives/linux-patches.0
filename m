Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D9615E8B;
	Mon, 30 Dec 2024 15:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574130; cv=none; b=K3SIqBGpg5mYEcK/I/UaiXyVIqXWyUa4QxQ8erSMDBMOLTTG+22dIgHWzObwEgTpNmTR/KPRtsX8PS/CNhiIfN3oGTpDdealNeBTtkKb15eTR5l3EjmbF1+Ek+Th+iNIpQt9ue9HM09R1z2Y+OZEVnbfLX0wJAMY05A5ulvRrYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574130; c=relaxed/simple;
	bh=98Hd93qA5wq9xC9Df5pgTI+vDev+Zqnk78i+sS0VsZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5PI2N4sfeYY9wmS7IowYVc0g/7WCDRpwc3aUb4wpVBR49kD4tJvdL3XS/pSCOpjLFVFsvXGzPo1RQ792l/BJuTOe+e7feonAgunQMiuhaTU9pzH7AWXav24JQDmTxHH3tkNaRpI/NRdv0VEAqE7qglQCi2RHjqxT5VRRHF2bDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnU/1Jrd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnU/1Jrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA476C4CED0;
	Mon, 30 Dec 2024 15:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574130;
	bh=98Hd93qA5wq9xC9Df5pgTI+vDev+Zqnk78i+sS0VsZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VnU/1JrdIFRxFXHfTFrYwinX+gaM8ou36C8dcu1ovv6uKeYCNDd/5df3Q2Dl9yON2
	 lWIQWZ6+DQwjjDX2U6pAe4YQVUzvSXr9mJkUPjOSUojvvoI0Op91iyb1dwmWEyyAhR
	 FR8JTdQLhqIOv8Ka89UqrS3u+J7RQ5CxbjJEThdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/114] tracing/kprobe: Make trace_kprobes module callback called after jump_label update
Date: Mon, 30 Dec 2024 16:42:42 +0100
Message-ID: <20241230154219.794067437@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit d685d55dfc86b1a4bdcec77c3c1f8a83f181264e ]

Make sure the trace_kprobe's module notifer callback function is called
after jump_label's callback is called. Since the trace_kprobe's callback
eventually checks jump_label address during registering new kprobe on
the loading module, jump_label must be updated before this registration
happens.

Link: https://lore.kernel.org/all/173387585556.995044.3157941002975446119.stgit@devnote2/

Fixes: 614243181050 ("tracing/kprobes: Support module init function probing")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 263fac44d3ca..935a886af40c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -725,7 +725,7 @@ static int trace_kprobe_module_callback(struct notifier_block *nb,
 
 static struct notifier_block trace_kprobe_module_nb = {
 	.notifier_call = trace_kprobe_module_callback,
-	.priority = 1	/* Invoked after kprobe module callback */
+	.priority = 2	/* Invoked after kprobe and jump_label module callback */
 };
 static int trace_kprobe_register_module_notifier(void)
 {
-- 
2.39.5



