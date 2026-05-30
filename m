Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2EB23392B;
	Sat, 30 May 2026 18:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164260; cv=none; b=Feoq5AmORbch2aSmZQTs+eOGQC4V7fLJYvrUcsRN7TvmQSeC4aqF5cd8z1ILhsgGW5fRpKCgEUFfzrVrfmAMDegaEUBfTQR8ao20H2gRCp6VhQ1kUMJES9MoWorAMlhXTAZw8nVFZAeQAEb91ZsQMNS9Nohhg+PiXB9IJvK2LDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164260; c=relaxed/simple;
	bh=p8QtX6byK+8vzZKgn54mkS4KNs+hmkG2ULUWrUHNwwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4+vRCMhFZsmrX66PTfvt3kdjC/P6oRr+sR/+On4x5jIR2aXzCMFeyfIrtUrDPZ8/qB0Ia5hhCo4rRo6Tuc6E5FvK/M3K8VVSd2kVVAwB6KY3WNE8lLEY2Ocv3SnbT4QCm2/UIm+T8orP7m1zt1Ewo8fTpnKLhKom64VQbxS1bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rjoy0f30; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rjoy0f30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900891F00893;
	Sat, 30 May 2026 18:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164259;
	bh=MuOOvIPqVZLop6qecp0RlyyXY8E/cfOmMll8mL6GXow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rjoy0f30KERiabG+h0kZC5hgiUBDfmjdZdm8Xel5+7mResbmK/tSyI3SYde/21zST
	 lPtKZmBxph7wPwz89U5tL7QEyOmoGxEor1cF0IOGOOIb9t8uJ0741W/e4r7wn+NaKS
	 ekIJQETTjDXwbEiNOodGHjWqj/V5KPsznhRWUjC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Zanussi <zanussi@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 502/776] tracing: Rebuild full_name on each hist_field_name() call
Date: Sat, 30 May 2026 18:03:36 +0200
Message-ID: <20260530160253.263757282@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8795913425416..03473d1e5f8bf 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1141,12 +1141,14 @@ static const char *hist_field_name(struct hist_field *field,
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



