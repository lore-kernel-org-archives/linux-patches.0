Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9764EA39C;
	Wed, 30 Sep 2026 16:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784848; cv=none; b=m4DsL1WklI8XtJKGaSNsE5b0VgJu2xTlO1ADFmyeF3pW1E2MfH5EvbGHHS4v70oVAecCLi1xEkB9pQajjjNOsP29SDWCXi+SMqtoPt5AQ04TRWKLpoK27IqiII8kBiAvGrKjNyKehFq49O9C1Rj5fbM/RlnKsqUAMlO/yyDiCUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784848; c=relaxed/simple;
	bh=qfhEE56J3Czb2GSy9fIwN+FsrhgsrUh+85l40AEd/AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tV5vmQiMjKIEzUldIR/hlEV1Ud13MGixH35rJOf3FfjagCVbJjZdapUtSWNO0hFOxBMtmh8Ma/u1up/pJP1mSy62ZLVTUOgKFF2xTo42J1KHNqNhfV9wTCw5nU/1sSyGovItrKv2HMrY3pBguBUI/2tVIDrylHpMpBj3WGg3ZVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kg8HrxDU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kg8HrxDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED421F00893;
	Wed, 30 Sep 2026 16:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784841;
	bh=tBweYJ2V59XKhRCSyJ/Pu2tHbPnIr4oH5SVFc5VlfYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kg8HrxDU4pgCA+gxjafKFa6orO0MQyQcLkmo+y7LUFQfXWc5Cr2ISJxu7gPi5hHnR
	 5aG2pEekeZuPMgA5A2NuNH+5IyP9hVALCVzs0htIx66RfiyCP7ubt6bb+XSkT+8gDu
	 cp9Gaibm1jkI8Vt/kfcSXjm3QP0IoVDfcfgaR2Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mukesh ojha <quic_mojha@quicinc.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 296/982] tracing/histograms: Simplify last_cmd_set()
Date: Wed, 30 Sep 2026 17:17:12 +0200
Message-ID: <20260930152423.163545582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 545db7e21e64766e6b7cb987fbfd3e79419726ce ]

Turn a kzalloc()+strcpy()+strncat() into an equivalent and less verbose
kasprintf().

Link: https://lore.kernel.org/linux-trace-kernel/30b6fb04dadc10a03cc1ad08f5d8a93ef623a167.1697899346.git.christophe.jaillet@wanadoo.fr

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Mukesh ojha <quic_mojha@quicinc.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 4e131895d6a9c..25c2334bab2d7 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -771,23 +771,16 @@ static void last_cmd_set(struct trace_event_file *file, char *str)
 {
 	const char *system = NULL, *name = NULL;
 	struct trace_event_call *call;
-	int len;
 
 	if (!str)
 		return;
 
-	/* sizeof() contains the nul byte */
-	len = sizeof(HIST_PREFIX) + strlen(str);
 	kfree(last_cmd);
-	last_cmd = kzalloc(len, GFP_KERNEL);
+
+	last_cmd = kasprintf(GFP_KERNEL, HIST_PREFIX "%s", str);
 	if (!last_cmd)
 		return;
 
-	strcpy(last_cmd, HIST_PREFIX);
-	/* Again, sizeof() contains the nul byte */
-	len -= sizeof(HIST_PREFIX);
-	strncat(last_cmd, str, len);
-
 	if (file) {
 		call = file->event_call;
 		system = call->class->system;
-- 
2.53.0



