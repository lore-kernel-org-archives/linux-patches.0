Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDBD12837F;
	Mon,  8 Apr 2024 13:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583393; cv=none; b=ccQ7njuoWFnbInmJEvnxdTP5vC5YwD2nPmcPeSfz90vbpZgk8l4PG6mq3MKZe6Wr2cf0qjxc9Yp7Q4A1Ya9kv1B9DvwbH4tNBaw36E9kiiBM9QT7uXEypevZX/PYHXrO9qkPMXOqDMV1perVJSVT2V7s8HnKMZ2oCyq7fk5BQD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583393; c=relaxed/simple;
	bh=y7I308wMdYENCbpCdBpeHopAnxgXZR7SdRtmZnqS30w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9Tgx1UA8IqYceQtd68+Bx/4Ui1ePQwmobdHl7htwAMEYJpvWO1OetV0Bs936zdJjw7rFFBPOxcjCgfgv5GW57GSxmsmxcFtXvAWgfhZm1UNY6CZn7Pc02BqxvNYUnfKzA1510RwM72xm9KNFXv1jyDbgOxyS9TgEbYxFec2P4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CP8PnpZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CP8PnpZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6479EC433C7;
	Mon,  8 Apr 2024 13:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583392;
	bh=y7I308wMdYENCbpCdBpeHopAnxgXZR7SdRtmZnqS30w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CP8PnpZyDcqA3YvGm9tkEwnthfbtBfgYrNJEjn7hr/EMLSJzHwhEqPuqtqxK0hXEa
	 P/80lRb1UvlKFkjrHVAPgKhjjetFlTIP6vUNH6lL1nb58CeDg1LkELGJc6JsjrZu0A
	 GgbvVKVet3+rxjBVX74dFsxVwIyNavDl09Exob58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/252] s390/pai_crypto: remove per-cpu variable assignement in event initialization
Date: Mon,  8 Apr 2024 14:58:10 +0200
Message-ID: <20240408125312.586264239@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit aecd5a37b5ef4de4f6402dc079672e4243cc4c13 ]

Function paicrypt_event_init() initializes the PMU device driver
specific details for an event. It is called once per event creation.
The function paicrypt_event_init() is not necessarily executed on
that CPU the event will be used for.
When an event is activated, function paicrypt_start() is used to
start the event on that CPU.
The per CPU data structure struct paicrypt_map has a pointer to
the event which is active for a particular CPU. This pointer is
set in function paicrypt_start() to point to the currently installed
event. There is no need to also set this pointer in function
paicrypt_event_init() where is might be assigned to the wrong CPU.
Therefore remove this assignment in paicrypt_event_init().

Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: e9f3af02f639 ("s390/pai: fix sampling event removal for PMU device driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_pai_crypto.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/s390/kernel/perf_pai_crypto.c b/arch/s390/kernel/perf_pai_crypto.c
index 0921cea849125..1ac74333a78dc 100644
--- a/arch/s390/kernel/perf_pai_crypto.c
+++ b/arch/s390/kernel/perf_pai_crypto.c
@@ -216,7 +216,6 @@ static int paicrypt_event_init(struct perf_event *event)
 	 * are active at the same time.
 	 */
 	event->hw.last_tag = 0;
-	cpump->event = event;
 	event->destroy = paicrypt_event_destroy;
 
 	if (a->sample_period) {
-- 
2.43.0



