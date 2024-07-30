Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A15A8BE8;
	Tue, 30 Jul 2024 16:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357213; cv=none; b=oRCq+ae7oUd5SRmGjr0+hJJCAYrwomoYdNfZnw0p/pnqy6BQ1rzygDzCGoT5/QJBlXWKkKN2G536A/t1dFyiq2mPKEoDwjZvlzRMwiPWCWenlVl9NZtbxSvYDMZQPfCVMO0+eLXwZXiK3GRS/y7oNseDJoXgaaZjeDpJbXYgAks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357213; c=relaxed/simple;
	bh=WcmXgu77wXyeAzaU+DxC/VvLpUJlDh9gneZfqccD7dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4Zu5t1SIpaS8SLhz4cX/HKcpmkD1J47Ki44UTNDd8wiJz5a38xeWj9vBCYwwD+XWanvFxCeMh89qPzeFxZCykcusJwctcVqofJWAzePGjUtuus/Ipr0L9cmkbc1p1T01BfQJ4yoB9lX/TwYI1V/9Wp391MtxYDag1fVVOOjf2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcRmzgS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcRmzgS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F729C32782;
	Tue, 30 Jul 2024 16:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357213;
	bh=WcmXgu77wXyeAzaU+DxC/VvLpUJlDh9gneZfqccD7dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcRmzgS8ry0UvLQKVp08UwkrW8hUtqOupZ3xAZSzCeUiGvGcxT75/EJBDBdUVemBB
	 1Rpb0jJK687xmh9Sz7TVXVBZQrlJessE4ASFlwKgE3MPVLovnPsJaDxS/2TPUY2iTQ
	 BJ0sp9LOnhFfqQwKElgDilG8vF3YdBUd59bPcGAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 233/809] bpf: helpers: fix bpf_wq_set_callback_impl signature
Date: Tue, 30 Jul 2024 17:41:49 +0200
Message-ID: <20240730151733.810439456@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

[ Upstream commit f56f4d541eab1ae060a46b56dd6ec9130d6e3a98 ]

I realized this while having a map containing both a struct bpf_timer and
a struct bpf_wq: the third argument provided to the bpf_wq callback is
not the struct bpf_wq pointer itself, but the pointer to the value in
the map.

Which means that the users need to double cast the provided "value" as
this is not a struct bpf_wq *.

This is a change of API, but there doesn't seem to be much users of bpf_wq
right now, so we should be able to go with this right now.

Fixes: 81f1d7a583fa ("bpf: wq: add bpf_wq_set_callback_impl")
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Link: https://lore.kernel.org/r/20240708-fix-wq-v2-1-667e5c9fbd99@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 3243c83ef3e39..7268370600f6e 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2786,7 +2786,7 @@ __bpf_kfunc int bpf_wq_start(struct bpf_wq *wq, unsigned int flags)
 }
 
 __bpf_kfunc int bpf_wq_set_callback_impl(struct bpf_wq *wq,
-					 int (callback_fn)(void *map, int *key, struct bpf_wq *wq),
+					 int (callback_fn)(void *map, int *key, void *value),
 					 unsigned int flags,
 					 void *aux__ign)
 {
-- 
2.43.0



