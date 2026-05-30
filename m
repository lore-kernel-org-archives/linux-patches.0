Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00763A254D;
	Sat, 30 May 2026 16:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158615; cv=none; b=R/zIrVgp4kAsw8pLXtuljMS8hgB6xZvvvHm7lmNSFsStotYPGU8Y9Rl3zChjtB41SAQz0sAWV7Y6Zf1pZyak9X9ECQuoDKjNtSJ//+i0unU2aZQwedLMjJ5B0d4JIB3SUvUFXHd5uTpQ0qH75640wnR06W+4/UxMuEZnYAx+2gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158615; c=relaxed/simple;
	bh=KfB5/V4//7cKiERSDaz02tXKptF7c2aruVxObObf67c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7XLgvW8XkX40NaVuCodBk48Hn2zOwRRvxdUDC4pAJSUTJsr8BuGQoTEUxda/ZFhzMypHa7NbEXRIjCMSUF/dw5yJei6zjj7GxPtC9ALXgy6KCntSEj9VgrRmEHoJo6XDRpq3vaR3+KtDCTrlKuX0xXISKXzU/BWwcEXiJ28b3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vyugTKrk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vyugTKrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD1C1F00893;
	Sat, 30 May 2026 16:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158614;
	bh=j+g+vHj1az37VhAuXgTyPE0ygQmQEl7pPEjx88KDYyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vyugTKrkxRboOzPp3Bs5pf7XmO86+iq0m1xQkPNMVJp9KFIsBFtE2tVMZgsy9/bxP
	 zEx2lGM5vuAcNSTjfVZc8CZVMLisGnicp37NX6Pt2oJ+hsiRK7FihD86SQ748kKIyn
	 oo1zlmX0Rj6ndb9YihU9VuvmZ3BNU23qvmrjxbTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/969] tracing/probe: reject non-closed empty immediate strings
Date: Sat, 30 May 2026 17:52:42 +0200
Message-ID: <20260530160301.475182040@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 3888a59c9dfe9..280e3d0f61b29 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -366,7 +366,7 @@ static int __parse_imm_string(char *str, char **pbuf, int offs)
 {
 	size_t len = strlen(str);
 
-	if (str[len - 1] != '"') {
+	if (!len || str[len - 1] != '"') {
 		trace_probe_log_err(offs + len, IMMSTR_NO_CLOSE);
 		return -EINVAL;
 	}
-- 
2.53.0



