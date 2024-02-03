Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124351B96B;
	Sat,  3 Feb 2024 04:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933479; cv=none; b=KcA6Hxq/qDXLaSlR7qlN6GxUdlXGDk4qIvJL+yaULPn4ygi8GSx/YYGZReTBpZh9QAgxeJyDGTVuivZYrMXSsCZ+z5+/NaOSnJT8wed+s8Ev+hiRFDZ2Un0iRCRWOGtxtXJG00NN4gCphjCmLNErofVhim5fiXS/AHNy9iu3320=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933479; c=relaxed/simple;
	bh=Q7rZqqbMjZOWNSvsfa6I1+YCGMs6zE4wjzms/dEqolY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSFQDWe5p8sLFn/BCfiKoefON+jYUWauz49XTmpjlM5I5FNYP74aSkD7xF5MRnJFj3nZSRxRwCbXQNI0mdJiKHs5cD1FLayMWR+PNAMubzj6zI1apJgRChr/lKnAW4U1BZBod4sZRn06cCOYqSVGmQrilm11P3BdvKQsk0eWOyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smr4FXcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smr4FXcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE7AC433C7;
	Sat,  3 Feb 2024 04:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933478;
	bh=Q7rZqqbMjZOWNSvsfa6I1+YCGMs6zE4wjzms/dEqolY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smr4FXcX9HGLVlhhnqMnSUsR4Ybs7RqHOEApxFyjHyc0L3iRK9kW3zQp5eyDq1AVK
	 edlZ2rBvMR2r2DCyfodZpJUkVdE/h5mbxbvmkqxSBN0/BBIygzHar8FSNriJ0kFThf
	 7qn7sjhzIoD9kpRYreCLxQCNVePyCShpRNL1Wr2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/219] netfilter: nf_log: replace BUG_ON by WARN_ON_ONCE when putting logger
Date: Fri,  2 Feb 2024 20:06:18 -0800
Message-ID: <20240203035345.789587671@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8a29290149bd..be93a02497d6 100644
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



