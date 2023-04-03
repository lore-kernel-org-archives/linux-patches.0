Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6528A6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA46BC4339E;
	Mon,  3 Apr 2023 14:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533331;
	bh=StEsn3dk1QY88RqxVzwXk0GuyPKH/bC1cwTvloS4JQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCHALHfGWNqxPcGoSrmBr+c++dfIlEqpsJ5zhbskd2Yc0dDKWDMlAm8PD6bl1Qj39
	 +upzWbg6gIZvAJocF84LyjLYvHcrmD1Gf8Emokn7ECtZFbGaIRGqNaL7HBWJoQ47Lm
	 S7vkxEBARs0zxhER6iAOmN29llzmPt9B5zTvVeAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 142/187] io_uring: fix poll/netmsg alloc caches
Date: Mon,  3 Apr 2023 16:09:47 +0200
Message-Id: <20230403140420.680737304@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

commit fd30d1cdcc4ff405fc54765edf2e11b03f2ed4f3 upstream.

We increase cache->nr_cached when we free into the cache but don't
decrease when we take from it, so in some time we'll get an empty
cache with cache->nr_cached larger than IO_ALLOC_CACHE_MAX, that fails
io_alloc_cache_put() and effectively disables caching.

Fixes: 9b797a37c4bd8 ("io_uring: add abstraction around apoll cache")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/alloc_cache.h |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -27,6 +27,7 @@ static inline struct io_cache_entry *io_
 		struct hlist_node *node = cache->list.first;
 
 		hlist_del(node);
+		cache->nr_cached--;
 		return container_of(node, struct io_cache_entry, node);
 	}
 


