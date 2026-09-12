Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B262DC792;
	Sat, 12 Sep 2026 10:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207426; cv=none; b=SSoBR42IXPlb9NmMtAzHkSyJHLnc7/rZ5U4dlCMkI6tGkNOgBB5nXnnzxvLzzMWDzCfjpEHsebs9SgeSqom7DZ+A15qlmjkH7qVkhaXq3Nanwu42B+1BXf74E3fVl3hhY/I0J4Z0pvnomIIeSWuCxIS6ncijIt509+Aw6kTlqZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207426; c=relaxed/simple;
	bh=oRHG23q2QS7o60Zk7NLwgXLBB6MECofrLep5vefk/4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hP04E8uGBraGq5FnUyaMW1ki2s7H1ViaITCzDs7geB5ZhkqorK2nEICkPS4MTMpdB5oH+XXxUF9OGzTHb7wfdl/Ao9syXT4zholFFdwRURAVPMeXFnqdzjRHSQNkSMn8PkVJh+Y20Qi05XJy7gTPOK2f28V4kD5PrkKN7DcenEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7wfuBE+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7wfuBE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9D11F000FF;
	Sat, 12 Sep 2026 10:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207424;
	bh=bbkv6mDTQjBa1Q2Fdwb0yM7Eb/nYp32rY4iVtmUhg1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7wfuBE+lnKOXMU3GlpZiRMiiyuK67mItRkWGFvMPRfyZ4XZLVn4LeR2ENgCaCN83
	 sG9huCF8981vwimqc4MSVb8vf+VvrRvKmdJQxfopWs58tOwBkAJL/kRBvgFvff9ieh
	 ZePzO+EcYfEWDTv2NjkFDELLe2OzdCsdNcRnB4sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0408/1518] perf: evsel: Fix error handling in tp_format lookup
Date: Sat, 12 Sep 2026 08:42:57 +0200
Message-ID: <20260912065632.688252581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 4968708beaad53940b67e4952e34a97d8768091d ]

In evsel__tp_format(), when trace_event__tp_format*() returns an error,
IS_ERR() checks the local variable 'tp_format', but PTR_ERR() incorrectly
uses 'evsel->tp_format' which hasn't been assigned yet.

Fix this by using PTR_ERR(tp_format) to extract the error code from the
correct variable.

Fixes: 6c8310e8380d ("perf evsel: Allow evsel__newtp without libtraceevent")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 22e43a57dc95f..e01103443b23f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -646,7 +646,7 @@ struct tep_event *evsel__tp_format(struct evsel *evsel)
 		tp_format = trace_event__tp_format(evsel->tp_sys, evsel->tp_name);
 
 	if (IS_ERR(tp_format)) {
-		int err = -PTR_ERR(evsel->tp_format);
+		int err = -PTR_ERR(tp_format);
 
 		errno = err;
 		pr_err("Error getting tracepoint format '%s': %m\n",
-- 
2.53.0



