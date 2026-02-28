Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8818355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301081; cv=none; b=VCAs1s7oEayK7NLhxEWgfgT1ekvub8VgAyPllJLYylsVToWtGrePbyHVrHS45mlb75GnEmcJ0UZbwmxvnaBJDMuEibWD9aeDkx3IqkRzES0oaeC6o5+9ieinTN41m9VzOfqAd2+C43drd+wMgvODxd+vCCrLJmwPD5Gn8nLopWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301081; c=relaxed/simple;
	bh=nzItiEz8QVYN0Ia+mYqox2oKSRk3JCPx68U3AHsJe1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qI+x1NMYaljIX7ny28ZlfbK+X9HtShIa41JaEUcYpJFcSrsKz/utH83D0QZNuRHdSt9RV+tYj1jcGDJlsnctm0h4qizYbmdAiZ7Xz6MMBJmkm3m39X+Wj699r9WqNLoZJP1Y4SC/y3Ftg60uY0Ctzo2J0Vm8zJ/Z2WWy2S1db/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WlAQs70S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WlAQs70S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5AAC19425;
	Sat, 28 Feb 2026 17:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301081;
	bh=nzItiEz8QVYN0Ia+mYqox2oKSRk3JCPx68U3AHsJe1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WlAQs70Sfurvnj9nLDlZEwBQZ4AXTPfY5hF0QJBzMWvcdZlXUrmu1fTE1kxy07h6J
	 vxsERyPzfTITCcmvvxiVAoximqPREl8MV8Jgf5NZiUzTP3cEhF6TEPoM8Np9QI6l+S
	 tg+9TVqOCNdIGMOPU2JSZwvrqpMM3QulBTYD1uJYehFu7Bv6dxop4ovqRpgeHWzMrG
	 Kko4tuMnZF2g7vVL5yESAKN9tM0/HjkkG5qVV8C8BmAUlsLRPrv7zpg/McHoOzkAHz
	 GWxzLj2kkWMspzLyShNLOM8n1waCXM1tK6VQvYkUQTYaWpP5T3lTHXDjTPUR+jqv+L
	 UM6gM9F4dUH5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Wander Lairson Costa <wander@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 229/752] rtla: Fix NULL pointer dereference in actions_parse
Date: Sat, 28 Feb 2026 12:39:00 -0500
Message-ID: <20260228174750.1542406-229-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit a0890f9dbd24b302d327fe7dad9b9c5be0e278aa ]

The actions_parse() function uses strtok() to tokenize the trigger
string, but does not check if the returned token is NULL before
passing it to strcmp(). If the trigger parameter is an empty string
or contains only delimiter characters, strtok() returns NULL, causing
strcmp() to dereference a NULL pointer and crash the program.

This issue can be triggered by malformed user input or edge cases in
trigger string parsing. Add a NULL check immediately after the strtok()
call to validate that a token was successfully extracted before using
it. If no token is found, the function now returns -1 to indicate a
parsing error.

Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Link: https://lore.kernel.org/r/20260106133655.249887-13-wander@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/actions.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/tracing/rtla/src/actions.c b/tools/tracing/rtla/src/actions.c
index 8945aee58d511..15986505b4376 100644
--- a/tools/tracing/rtla/src/actions.c
+++ b/tools/tracing/rtla/src/actions.c
@@ -141,6 +141,8 @@ actions_parse(struct actions *self, const char *trigger, const char *tracefn)
 
 	strcpy(trigger_c, trigger);
 	token = strtok(trigger_c, ",");
+	if (!token)
+		return -1;
 
 	if (strcmp(token, "trace") == 0)
 		type = ACTION_TRACE_OUTPUT;
-- 
2.51.0

