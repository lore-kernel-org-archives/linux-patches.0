Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A35223328;
	Thu, 28 May 2026 20:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000461; cv=none; b=u9VGVcD0kHC1iglUHyKBiqOnNvi8uhfQQOAcFyYYGxO+6Vdjk44E776bhyXzXlRk6BC2DMpPlBkDhCmjxt0K8HOx0W2RDIM06ouAYA+mxZjb/6WiaWL7IHf/AcusZalznQXnt8C/C6EY3lY2pcTdLStRkpO/qOaq420vhKlLLnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000461; c=relaxed/simple;
	bh=KR2RVqmprACWSu2LDJZQXWTQ1UgNGM6Q1SIWvqgJJhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qf9mNARLzEbSY2qKMKUT4isdae1EiFVp/Oh4DUdPrjS7c7tBzH8iXmTrWxpEwQBAI2ZCHrVrVRjj1tG1nyXw0yfbESVC49+mMHtKSITMNY4MtqE6PcBVFQ80zvurKb//rLfrifgGPAgAvZOEZwLOvV0tHbyrdkqpUl8vaQEtTrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfNudNmn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfNudNmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960901F000E9;
	Thu, 28 May 2026 20:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000460;
	bh=RYibwaKoe2zYhxdAxMIjvy5Dl6P5lCM0rQhsH7roFaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfNudNmn4gnsHm46PgSb7YHu3kgRDZiqZpMNBriYmLJQqmFVqgZRpcVZorvWgV8+1
	 UMHQlEqmmj85L6hRGIJoFgo/vOucgMJdBRnvkrb+35lrH4ez6ABXdCZc3/b1su8bEo
	 /AJFmSt2unAAgC0awNgWsYb9ADshI7SajbDd8d18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Lukas Beckmann <lbckmnn@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/272] sched/deadline: Fix dl_server_stopped()
Date: Thu, 28 May 2026 21:46:30 +0200
Message-ID: <20260528194629.837279267@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 4717432dfd99bbd015b6782adca216c6f9340038 upstream.

Commit cccb45d7c429 ("sched/deadline: Less agressive dl_server handling")
introduces dl_server_stopped(). But it is obvious that dl_server_stopped()
should return true if dl_se->dl_server_active is 0.

Fixes: cccb45d7c429 ("sched/deadline: Less agressive dl_server handling")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250809130419.1980742-1-chenhuacai@loongson.cn
Signed-off-by: Lukas Beckmann <lbckmnn@mailbox.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 9c5fa95b345a5..6ff9055a69811 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1879,7 +1879,7 @@ void dl_server_stop(struct sched_dl_entity *dl_se)
 static bool dl_server_stopped(struct sched_dl_entity *dl_se)
 {
 	if (!dl_se->dl_server_active)
-		return false;
+		return true;
 
 	if (dl_se->dl_server_idle) {
 		dl_server_stop(dl_se);
-- 
2.53.0



