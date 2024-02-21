Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2B653816;
	Wed, 21 Feb 2024 13:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521678; cv=none; b=TmPvaykgKSk6lrP0UngfKF+FDHt4yC9fA3NAhIgw2p9S+VDOo1XdQEnpsGsbTTu8aAF0EDqAcW3r56KG/zCwn/tMxPIoMvTOewYd1e54hH5Fe7T8EfkTtaTQ/i2VRQ/OQAt8bHJPGW4OfK2FHOsMyH1H57heuxFW0+WD45NtJI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521678; c=relaxed/simple;
	bh=iI6NtBWolpdSeWyhVc5BQuZ8b1rp+4PcfjoV11EAFC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrAOuFzfCk8wXgvRHoK+ARjkgSxH+acBhtUiD3cWfXktGYeG8iG7o7UP6iQGr3DKIZ+OHFJ4Cv5nFzlzxdkrzEPIDsTAFh739smtQlL9HGTcmHAJej+b1rB9chyQmC3CjO3QkM9UFTjZHEk0UvutRF78OszBN4feNpOdKbkfbCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXku7ROm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXku7ROm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AC5C433C7;
	Wed, 21 Feb 2024 13:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521678;
	bh=iI6NtBWolpdSeWyhVc5BQuZ8b1rp+4PcfjoV11EAFC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXku7ROmWGBc/v9Lcfst1Wz2ITZ62buW8yDNBDjleSawM1Y/7uJWGb7In3dpi3I5m
	 TdTEHYLZfJDc/6zPSsvZ5nM+xOyJY68UtAL8HvYU/ITh1TrrKHDP1SI2nfPGVoW73w
	 RnTbXVMLcdveQa2yMy6oH7WBofIbeeI6amXb52TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 138/202] netfilter: nf_log: replace BUG_ON by WARN_ON_ONCE when putting logger
Date: Wed, 21 Feb 2024 14:07:19 +0100
Message-ID: <20240221125936.170464956@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index a61d6df6e5f6..75bdeee325eb 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -202,11 +202,12 @@ void nf_logger_put(int pf, enum nf_log_type type)
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



