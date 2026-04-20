Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73585329C6D;
	Mon, 20 Apr 2026 16:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701294; cv=none; b=DNyHYDVtUxLzueNAmHld9GXm1oWG2+DssVIzi3TizFf0tVv2A19rKNyvEPEQuizh5jagDjc+ln14UGxOToiRLD7LFYAZ5HXOXO6oh9divKh4MORMI1+W0XpsAgthhTfV73FckZButnXAb29223T1qUNQ6qADTFYOqhLH6ayHXrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701294; c=relaxed/simple;
	bh=WL0tIXE3pGMTXRBAAkTTse8fxV4h5u6KD/SFO/LNGBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNYjv/SGnMFoowWOJQgLto3vx9P61OAb67cUSR5c8zOFeoB1R+iRdVIn2+uWwg2vWqHi0wIngHMaYWSlF85A0FE9HzYxJkJHFkp4m/RoFH7ZUTkZ7p6W8bUpY3rb+mjckXRtLsW3olvQDJ7ppaau2kZJ3OpZctTL3mazlP6o408=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0GbdKdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0GbdKdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A39AC19425;
	Mon, 20 Apr 2026 16:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701294;
	bh=WL0tIXE3pGMTXRBAAkTTse8fxV4h5u6KD/SFO/LNGBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0GbdKdIiJpLMjKUExR0lxGOnreOz86S4T8M9DitiGjUOth02xomuH4HlrfKvx6R8
	 x8Cc/xTUBiXa2Mk/THlo+iTjcrUffbox7LV4TIlC4i1itnFVeq0QLInhvdDWgqSglu
	 WUlOLtKWoDQgCg5qj+l+B1ANJzQ8+eUbOMMJWk5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/162] tracing/probe: reject non-closed empty immediate strings
Date: Mon, 20 Apr 2026 17:41:30 +0200
Message-ID: <20260420153929.138212951@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 4346be6577aaa04586167402ae87bbdbe32484a4 ]

parse_probe_arg() accepts quoted immediate strings and passes the body
after the opening quote to __parse_imm_string(). That helper currently
computes strlen(str) and immediately dereferences str[len - 1], which
underflows when the body is empty and not closed with double-quotation.

Reject empty non-closed immediate strings before checking for the closing quote.

Link: https://lore.kernel.org/all/20260401160315.88518-1-pengpeng@iscas.ac.cn/

Fixes: a42e3c4de964 ("tracing/probe: Add immediate string parameter support")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 055f5164bd96f..1b937923d118b 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1040,7 +1040,7 @@ static int __parse_imm_string(char *str, char **pbuf, int offs)
 {
 	size_t len = strlen(str);
 
-	if (str[len - 1] != '"') {
+	if (!len || str[len - 1] != '"') {
 		trace_probe_log_err(offs + len, IMMSTR_NO_CLOSE);
 		return -EINVAL;
 	}
-- 
2.53.0



