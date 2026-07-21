Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B8E46F494;
	Tue, 21 Jul 2026 17:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656058; cv=none; b=O+B86/yX6WC54zypYVnvhe7ySNm4zGrxwkbssCrGx0CQopmga3JsGE/H3WKYfEZJbTuTVsFLkrmyX8U7nYkDSZ6T6ReUCDDwINz9GqaVRP6sjPhHe40i8iLEHxOfYW5FL/aJoAPAhgEUWTp+dUrUqVBbivAhe3OzYVejKSM69zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656058; c=relaxed/simple;
	bh=DsTwZRDTsusm8+804DeVVM9WlYWhhJT/85zytSR0+cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQNO7GAfj5kar+N7SXKxJfla3L2k+pWWxGVF+pg1n1eELNRHto5lcNbMjLvTme4IskLQogVgZ9H/67zbw+QM1P/QbtGOrYOt1ktoaiGbsl2yRP/wvMAIP6CdVGMIuQC61vB/I073zj7b9M33N4ZOkhBwlwxja37vz7JV5cfbkYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDJwKjJh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDJwKjJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FDA1F00A3F;
	Tue, 21 Jul 2026 17:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656057;
	bh=ym9iWKRlJVOwgKAaVmS1SwtEXx5xdblok861Iw8paiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDJwKjJhzXJYgY+ko//pUDBGWIuiJVaDZRFqzxiMRNdsfKJnD1VjudcvS0Fconh/A
	 9gm1xrP05/gDtgrK3z6QyCgQhNs4inFrSmHPTjNH2R37cEmVeYr2dyg3MyKpOUNhuf
	 uKTT8V+SbNg9UlycBqfzWUTT4s5f8ijf+X2EWRkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0244/1611] rtla: Introduce for_each_action() helper
Date: Tue, 21 Jul 2026 17:06:00 +0200
Message-ID: <20260721152520.510550181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit 648634d17c813b35da775982662e56ea8ce750de ]

The for loop to iterate over the list of actions is used in
more than one place. To avoid code duplication and improve
readability, introduce a for_each_action() helper macro.

Replace the open-coded for loops with the new helper.

Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Link: https://lore.kernel.org/r/20260106133655.249887-4-wander@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Stable-dep-of: dd520daffbc9 ("rtla/actions: Restore continue flag in actions_perform()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/actions.c | 6 ++++--
 tools/tracing/rtla/src/actions.h | 5 +++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/tracing/rtla/src/actions.c b/tools/tracing/rtla/src/actions.c
index 4274fa0894b04d..5f83ffc1008f83 100644
--- a/tools/tracing/rtla/src/actions.c
+++ b/tools/tracing/rtla/src/actions.c
@@ -32,7 +32,9 @@ void
 actions_destroy(struct actions *self)
 {
 	/* Free any action-specific data */
-	for (struct action *action = self->list; action < self->list + self->len; action++) {
+	struct action *action;
+
+	for_each_action(self, action) {
 		if (action->type == ACTION_SHELL)
 			free(action->command);
 		if (action->type == ACTION_TRACE_OUTPUT)
@@ -226,7 +228,7 @@ actions_perform(struct actions *self)
 	int pid, retval;
 	const struct action *action;
 
-	for (action = self->list; action < self->list + self->len; action++) {
+	for_each_action(self, action) {
 		switch (action->type) {
 		case ACTION_TRACE_OUTPUT:
 			retval = save_trace_to_file(self->trace_output_inst, action->trace_output);
diff --git a/tools/tracing/rtla/src/actions.h b/tools/tracing/rtla/src/actions.h
index a4f9b570775b55..fb77069c972bae 100644
--- a/tools/tracing/rtla/src/actions.h
+++ b/tools/tracing/rtla/src/actions.h
@@ -42,6 +42,11 @@ struct actions {
 	struct tracefs_instance *trace_output_inst;
 };
 
+#define for_each_action(actions, action)			\
+	for ((action) = (actions)->list;			\
+	     (action) < (actions)->list + (actions)->len;	\
+	     (action)++)
+
 void actions_init(struct actions *self);
 void actions_destroy(struct actions *self);
 int actions_add_trace_output(struct actions *self, const char *trace_output);
-- 
2.53.0



