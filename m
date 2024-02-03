Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA878482E4;
	Sat,  3 Feb 2024 04:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933718; cv=none; b=qeIz0EKY7jZQZj9iXZnJsYrUEy/zSbic34plQKU2wDJbctnfiUUhzoa4Bv4tMPOSsSfMhBYXRvHTyFraaNmKRXoqlbMqjGqH3UwsLDzCI3QvGPFNIqFQkoOiYf2t+KrJVReyjAGcTF+by2/5XLCOgCcd7dK3jNIOZrjsVGs+0/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933718; c=relaxed/simple;
	bh=kHyKEygPVo1aTwVjzGYkWjZiIrR9ITqQqcpm1XoiBD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRFSq98UdMTl5FAq09MlImhpuFouZhvHcsPxt6OrojopfpCC3l2BYCAyVjuIxrytMq4UMYJT7KeRIkiWDVMN6ZYfox+1eXN5y+WaUm8VL+uXjTNntO4BpJo8pE6MzV+vZIBAhUw/LQ743yADkfYQKX0fhnOCOAJL8f9BP8if3Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZ/KZBSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZ/KZBSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F7DC43390;
	Sat,  3 Feb 2024 04:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933716;
	bh=kHyKEygPVo1aTwVjzGYkWjZiIrR9ITqQqcpm1XoiBD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZ/KZBSB47SvXdS+gd8ZKglm1+B4y4bZP2dRzcDdS/xZk5IxSaByOD1Sh4dB9rvTI
	 U3OY+hfdzQAK5LhOvgt0PtmmEyvRvsr7PcmlpY3BCtoTtR9cIjlqQeadGy90zOVkCQ
	 GIoD+B03s5lUPlknPWPX83onsVJwrV3/kjN3bWcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 296/322] netfilter: nf_log: replace BUG_ON by WARN_ON_ONCE when putting logger
Date: Fri,  2 Feb 2024 20:06:33 -0800
Message-ID: <20240203035408.623661907@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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
index 8cc52d2bd31b..e16f158388bb 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -193,11 +193,12 @@ void nf_logger_put(int pf, enum nf_log_type type)
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



