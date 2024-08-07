Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BF12AF07;
	Wed,  7 Aug 2024 15:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043347; cv=none; b=s9A3rNGCjsNSGawmmoaPqDBLtjYArbUS9IS+tOyH4u6s1NQlHa0QwPlLsXbaLdtJvRm/r7gYEKZlSzkHw19uyBVnkt6zsXNqzRuNh/zTm/RB8DduUyTn1dAJOcIcgyu4jfHd783wBqn2hovcP8VBqojnrBaaA/OoYenVF6AdcMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043347; c=relaxed/simple;
	bh=0wqAqoSfSLqxvYX/U1zqspuWv+OovESFLJ94iqLOBUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRjNTOfAYejGJa0fJEJYbDYuC+z5UBMLc3ovr3HxZZj/9SdGtBekeRu/0nz7L9mV9zwRzEq8zGlYpR/Nj3LNkS9ZnZLnEp6OUlL0/7vdzJdrfwO1Z/cb+1bePjUcTQoAj0qKtyguxy9mFWyyCLH7dkcBMYpUoW5BWYBh+hwawlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngOsBUDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngOsBUDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8898C32781;
	Wed,  7 Aug 2024 15:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043347;
	bh=0wqAqoSfSLqxvYX/U1zqspuWv+OovESFLJ94iqLOBUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngOsBUDZVaVIVsl/4PhYgROHmclXMmO/LO90tEVUE78vAdTHDVH1xAaeVnS5/ZE8n
	 1fSSZr8fb87rBXpNuKX7RM2WyZ37qtdPmcBY7/7p8U/7AboMDyz4mPTTh6ItEaGAtw
	 lMg2I4vHcTOXoeh6okjXA7p+1rctYoY5caVOTtJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/121] ARM: 9406/1: Fix callchain_trace() return value
Date: Wed,  7 Aug 2024 16:59:42 +0200
Message-ID: <20240807150021.041113666@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 4e7b4ff2dcaed228cb2fb7bfe720262c98ec1bb9 ]

perf_callchain_store() return 0 on success, -1 otherwise, fix
callchain_trace() to return correct bool value. So walk_stackframe() can
have a chance to stop walking the stack ahead.

Fixes: 70ccc7c0667b ("ARM: 9258/1: stacktrace: Make stack walk callback consistent with generic code")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/perf_callchain.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/kernel/perf_callchain.c b/arch/arm/kernel/perf_callchain.c
index 7147edbe56c67..1d230ac9d0eb5 100644
--- a/arch/arm/kernel/perf_callchain.c
+++ b/arch/arm/kernel/perf_callchain.c
@@ -85,8 +85,7 @@ static bool
 callchain_trace(void *data, unsigned long pc)
 {
 	struct perf_callchain_entry_ctx *entry = data;
-	perf_callchain_store(entry, pc);
-	return true;
+	return perf_callchain_store(entry, pc) == 0;
 }
 
 void
-- 
2.43.0



