Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711307E769;
	Wed, 21 Feb 2024 14:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524415; cv=none; b=nUCkZwZK9cu7f1iWz5IsWjsRmvrWTOqP6QVYxmqBib+0vJNdft4rXQ9bOyoNjXhhDaibSHIWyTqRnnLdv0TCicbgK4XxXslXnbg/fyBzGNE9mBtNEKKKILzGz0tt4aXuo3ugAcTbkCSh+hW5q+mzesjBcx2PJAaWQwtuGEd+yco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524415; c=relaxed/simple;
	bh=TSzGFlzm2hjIXVd8mTo8vrkTJI1GoJXgpagSR0k4ejE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWxzES7vmKCV+u8RIigGlUsE6szORFSIj3B2rNjmcXrV4QKqDWFU62XmHJWJNUSWX+TH0NiXoXqZjyUR3hqyo8Q+MfhwQFIGVlubLlqvljOzv/mATJb4Jyu1AD7fd3I7AHeSqJbfqDh68IIw1jBHShcgoRk+4cN6Sy1EBdTd+yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11Vs6Y5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11Vs6Y5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954B9C433C7;
	Wed, 21 Feb 2024 14:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524415;
	bh=TSzGFlzm2hjIXVd8mTo8vrkTJI1GoJXgpagSR0k4ejE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11Vs6Y5Q8xIQ+6ipRtoTmKNzA4hfsPy4fc7IlIHiLLjvKZih8RceBbc5H06UOtYPs
	 KuKFAN1E8BG0VeDrHl6XvdzfTPNJ/WVuz36ELscTPb9w9j22YglzsA51DttPaLXgqx
	 htSXcSurhDNEUGsbpBlf7iIMDu5P6MdL8jjQAOVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 236/379] netfilter: nf_log: replace BUG_ON by WARN_ON_ONCE when putting logger
Date: Wed, 21 Feb 2024 14:06:55 +0100
Message-ID: <20240221130001.896213499@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 259eb32971e9eb24d1777a28d82730659f50fdcb ]

Module reference is bumped for each user, this should not ever happen.

But BUG_ON check should use rcu_access_pointer() instead.

If this ever happens, do WARN_ON_ONCE() instead of BUG_ON() and
consolidate pointer check under the rcu read side lock section.

Fixes: fab4085f4e24 ("netfilter: log: nf_log_packet() as real unified interface")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_log.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 6cb9f9474b05..28c6cb5cff0e 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -203,11 +203,12 @@ void nf_logger_put(int pf, enum nf_log_type type)
 		return;
 	}
 
-	BUG_ON(loggers[pf][type] == NULL);
-
 	rcu_read_lock();
 	logger = rcu_dereference(loggers[pf][type]);
-	module_put(logger->me);
+	if (!logger)
+		WARN_ON_ONCE(1);
+	else
+		module_put(logger->me);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(nf_logger_put);
-- 
2.43.0



