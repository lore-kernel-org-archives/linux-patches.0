Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9F94C62;
	Wed, 21 Feb 2024 14:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525566; cv=none; b=h3hWJ3zk5Sl2YmrCcHlDmnnAeZKVr+DsXlRkv8BnI/CirMktqIhhka1iH3hFXSjw9C0nUKz/sDKNhSD6RZ+R+uJa4CvXVRmoz18ej7FIjSaDHGrE38LM1D8Y4LtvGpgCo4Z7JR8Vu/CTY8ZK/zbBQ9lBGq/jt8vRHvy/y5HwbqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525566; c=relaxed/simple;
	bh=0gfCbG8RQPb4K+ZZ81SvGDwBOJc4W2QupnIvUYgfwCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUV5YfDTEPPn3qA9hLIEalJ6o9Q05p9+JvjGfxfJtMk/bqyPqg36Qwl5F7eiBkIg0tFcMlAzjkbSpa5VKrl+zfuWXCOyBgQ9aO33N+YBqqtSQXXD5kxayQSD1klwSay7cKtQZIdFZ2igce3SY/z2peqWFyZruy715YHF75/mFgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPrxZHCw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPrxZHCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B61C433C7;
	Wed, 21 Feb 2024 14:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525566;
	bh=0gfCbG8RQPb4K+ZZ81SvGDwBOJc4W2QupnIvUYgfwCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPrxZHCwaF4uW/HEh+NYOKfHdnapH0OVVuVK5CqT79Oj54CDFgQXbn8RF6oISQODy
	 8vIA/PSO6u643YAI4HuZg8rhdbrwuqdp5jZge/5CRQ4tULWGJiDQL72qVUgIkwsQJ6
	 TZxyrB5AWj4yQOFPKNceFS3XKAatanZWgGT//hUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 167/267] netfilter: nf_log: replace BUG_ON by WARN_ON_ONCE when putting logger
Date: Wed, 21 Feb 2024 14:08:28 +0100
Message-ID: <20240221125945.371665113@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bb25d4c794c7..e25dbeb220b4 100644
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



