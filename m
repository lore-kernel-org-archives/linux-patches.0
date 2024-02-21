Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E547869951;
	Wed, 21 Feb 2024 13:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522889; cv=none; b=FMwrJv+Vcc/Dy6Rqm9VflmGFxOvYOTvpvI5SvqtJydQ5KwBEmWChcEbIQvGU3GXSjbCIqXfzCE0jzkgenLTgrbJjg0gn4oxK9rFOWGF+RHM25+hMOde/O1ZCnyVUyteQHcK1Q8MMpoZjIFWcE5hZCdDJ4PnwYVdA2Uozp038toc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522889; c=relaxed/simple;
	bh=h9/HYGKhkJGUW1OQCtqOIyKno/UK7rCco8hAXmvg1tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMs24Po3EIY3P1SIYOxFNC7V5h14CRxEKyVnFtXSgSs97S6hdz09bBFH/L7kflc4HDlR2S+EbsIZ10fa5WNKkACdxPcaZYpSSVzFSWL9CS0+PXVnkwJLcYiIi3MbbQ+4aPhvy0UOuUneguvymd7KZDZmub+2MJRDBXI0tB48u5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVsrDur5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVsrDur5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAF3C433C7;
	Wed, 21 Feb 2024 13:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522888;
	bh=h9/HYGKhkJGUW1OQCtqOIyKno/UK7rCco8hAXmvg1tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVsrDur5z0JO3EpgITuUvokPgTWfJsvEyWSTXk3vsihcXYcwoNIAw+bIu9CTvYMy3
	 XlvzciWhaNK6iPkQUS1lx/BEmwaIhNhNg+ZUDJ11mZq2yVTZGafg97pNiiCvNoHBob
	 Z25/BBfo5iMzb1q8ya8uhyGH4/ungsrH15INPBdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 284/476] netfilter: nf_log: replace BUG_ON by WARN_ON_ONCE when putting logger
Date: Wed, 21 Feb 2024 14:05:35 +0100
Message-ID: <20240221130018.501398574@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index edee7fa944c1..8f5362a19b15 100644
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



