Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B6D13D2BD;
	Thu, 23 May 2024 13:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470073; cv=none; b=r97JwlFPZ3HHzXkFp/Y25qfL1SocjsAZqgodyfEyQqY3BH8Kjmt175LKr6uPDu93dhvLc4ir2RNWaEQHX9X77mSCV88wYY1D52bL/UUOHjjK4aJQnwDE/5fVYyItlZcLKXkUBmLlIpeGEXZ/VcI4gjW5UZ/hqS9UCqVA1fVNQn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470073; c=relaxed/simple;
	bh=X1YWvJJ1O2G9nqCBd0rwPvoVVE0LYnf7Ru8EAEK2hJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbwDU7YLMMbtvM0503Yd8VR9Wu0f7LDPrXXb2VlTWvgYTzBkmEj5892MB4bZeKAX4Sf+2o/f26JKSdNiuZbD4u3STHEmO3lm1HR3y9RLEKrFcgaYKubJPIzvBunfIqfj3Uog+P0aynR9e50fR7yareOL/5kSvc8PhWvczsJxO0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MoW9wU2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MoW9wU2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E82FC2BD10;
	Thu, 23 May 2024 13:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470072;
	bh=X1YWvJJ1O2G9nqCBd0rwPvoVVE0LYnf7Ru8EAEK2hJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MoW9wU2ILX6ZXs0Mm7eY5+H2kWS1JCHqQ4s1LmemMFPYFSqkSz40Bzve9e6W7BHVX
	 HragR1SD09DmalsGHchPidT6H0W5rm9Biazy1LLw8lS65XxftMJbDrBsN+LoIn8ZNt
	 g1SYq9v9RIMO84iYqQS5rM5GUxgnvu+hjbH5kRo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Zanussi <zanussi@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 4.19 12/18] tracing: Have the historgram use the result of str_has_prefix() for len of prefix
Date: Thu, 23 May 2024 15:12:35 +0200
Message-ID: <20240523130326.203755609@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.727602650@linuxfoundation.org>
References: <20240523130325.727602650@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

commit 036876fa56204ae0fa59045bd6bbb2691a060633 upstream.

As str_has_prefix() returns the length on match, we can use that for the
updating of the string pointer instead of recalculating the prefix size.

Cc: Tom Zanussi  <zanussi@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -4410,12 +4410,13 @@ static int parse_actions(struct hist_tri
 	unsigned int i;
 	int ret = 0;
 	char *str;
+	int len;
 
 	for (i = 0; i < hist_data->attrs->n_actions; i++) {
 		str = hist_data->attrs->action_str[i];
 
-		if (str_has_prefix(str, "onmatch(")) {
-			char *action_str = str + sizeof("onmatch(") - 1;
+		if ((len = str_has_prefix(str, "onmatch("))) {
+			char *action_str = str + len;
 
 			data = onmatch_parse(tr, action_str);
 			if (IS_ERR(data)) {
@@ -4423,8 +4424,8 @@ static int parse_actions(struct hist_tri
 				break;
 			}
 			data->fn = action_trace;
-		} else if (str_has_prefix(str, "onmax(")) {
-			char *action_str = str + sizeof("onmax(") - 1;
+		} else if ((len = str_has_prefix(str, "onmax("))) {
+			char *action_str = str + len;
 
 			data = onmax_parse(action_str);
 			if (IS_ERR(data)) {


