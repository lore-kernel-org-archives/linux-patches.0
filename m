Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704EF36B059;
	Wed, 20 May 2026 16:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295861; cv=none; b=tdVLxg2uJB0YaFUmTXNCfph4piVCEhTN/HF3IMO7c/2cIO5ab8KrONsKuwTLwwKaHqKO3CwHMIwuuj08BvK7njTWD1wBgDrfKfhS8u2hTC/1TUMb/ScX97BVZ8Q8VIuga/geNlZ89qV4SYKRCSWz71wbp3IKkQ8K2htui7qb7fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295861; c=relaxed/simple;
	bh=m6h7R/EPcmRBj4I8SJosYwcs+eX7OJkrWUo8OJTjUAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HU9+pHEmcuCOCm3m81DE0Ac/xId53IwaWayWezDlEdATn87ktuxOJb847SJRYGwNpBTKIX6zsgObPYqLEhS9DWH4BJvO4B5oDkHluk6G6ZObUB3gg46co+3c+JNTVEyu/1zcdyC9QG2LrXqC5Sh1yBltxI+f9+a+zrS8iswWxv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dm1GHt2v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dm1GHt2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D446A1F000E9;
	Wed, 20 May 2026 16:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295860;
	bh=zkj790kqfroBwMJFFKG2QlHGZKf3sGCr5xxJOUX5Jjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dm1GHt2vhYtp+chi5j17hokgTs8H90O1FlUgHikzADYbdedJxi7b7jgsRnmUpaIX5
	 LMj4GBmD+0N1Ol2Had7a/eJmdpzbID7t/CxKIEYMr8lfMA2S2SZilh0maIaRrWTHpM
	 CO1EONAYzVoZzDJpcF2NGinWQsvEBcDXub7Gq1OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Zanussi <zanussi@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0580/1146] tracing: Rebuild full_name on each hist_field_name() call
Date: Wed, 20 May 2026 18:13:50 +0200
Message-ID: <20260520162201.308168975@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5ec1d1e97de134beed3a5b08235a60fc1c51af96 ]

hist_field_name() uses a static MAX_FILTER_STR_VAL buffer for fully
qualified variable-reference names, but it currently appends into that
buffer with strcat() without rebuilding it first. As a result, repeated
calls append a new "system.event.field" name onto the previous one,
which can eventually run past the end of full_name.

Build the name with snprintf() on each call and return NULL if the fully
qualified name does not fit in MAX_FILTER_STR_VAL.

Link: https://patch.msgid.link/20260401112224.85582-1-pengpeng@iscas.ac.cn
Fixes: 067fe038e70f ("tracing: Add variable reference handling to hist triggers")
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Tested-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 73ea180cad555..f9c8a4f078ea0 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1361,12 +1361,14 @@ static const char *hist_field_name(struct hist_field *field,
 		 field->flags & HIST_FIELD_FL_VAR_REF) {
 		if (field->system) {
 			static char full_name[MAX_FILTER_STR_VAL];
+			int len;
+
+			len = snprintf(full_name, sizeof(full_name), "%s.%s.%s",
+				       field->system, field->event_name,
+				       field->name);
+			if (len >= sizeof(full_name))
+				return NULL;
 
-			strcat(full_name, field->system);
-			strcat(full_name, ".");
-			strcat(full_name, field->event_name);
-			strcat(full_name, ".");
-			strcat(full_name, field->name);
 			field_name = full_name;
 		} else
 			field_name = field->name;
-- 
2.53.0



