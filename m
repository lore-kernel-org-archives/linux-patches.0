Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA44107B4;
	Sat,  3 Feb 2024 04:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933958; cv=none; b=bLFiF1SjW7ebwv2GDqFF6Ov4sO34S8cDyI+W9PNeYd/rUxOxfSvSq0JkVtGD70P8EYmNowb7/eWTpYCcvsY7fY8sWDxHlSb3ov4zL4gU4GWj/f/Z6QUsvfl5Kn8MPyAbXeObLUXKswKh0niCC0h9gG75Cyd2whVM/dC1eSFJSFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933958; c=relaxed/simple;
	bh=v/BviCmwb44pmJ4i+Z1tpkbq9GJUIfzMoYFKP03LDpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sC0zcaJ/2bg6iaNnEjcBbx/SsQqtOvwTsvGDsRxWwR/IemWJU0+AJpFX8bZvPh7cFWGRvZCn8QmVQeD+ap579fy666/SYUSrCf6QirbAjfxWK4vw63ynjgfft1M/F0fVjgQNWeIfe+wx8+z/HZWmvSUMo+zdwe8n7fQdbzvteSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nk7fsm4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nk7fsm4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4188C433F1;
	Sat,  3 Feb 2024 04:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933958;
	bh=v/BviCmwb44pmJ4i+Z1tpkbq9GJUIfzMoYFKP03LDpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nk7fsm4VFNJwOoqgt9MHO66hlSgVHMVoPPNw9A40v5twTbmCDfS1a1TE3vin45eQO
	 jutyj7hSJX+TmX6gIPDFqOE3leWRP2+j4sCAhENb/60n6lFWYsclCVENK9WVE+6dsY
	 YdiHbdRUduzRzUS7YxWsold4rZj6h2lE2+tlvEZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 327/353] netfilter: nf_log: replace BUG_ON by WARN_ON_ONCE when putting logger
Date: Fri,  2 Feb 2024 20:07:25 -0800
Message-ID: <20240203035414.153245922@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



