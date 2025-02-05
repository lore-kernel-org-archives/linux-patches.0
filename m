Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D9014B080;
	Wed,  5 Feb 2025 13:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763129; cv=none; b=gMtuvc4VzcSjj3guAxbsnCdcyGkVO+fzYiBuWTP/uWjSQjdJ/J8Urfc9rqDqf37fmBGYwrhRHaeGaesiwmFUUbutPopQzcAIQ0m+L7rspVM13HNLS5DM6Hfo8RKxNCeN3rqUg3NLQXNS8XKWE9PzgMfMxfgNh5Y26RaJaUC9sXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763129; c=relaxed/simple;
	bh=ij/ZxVh3CHnNGzXO/GSPd3fYYZkvu6FlsG0lrdcVM04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkPtCZzUBVVYKI1tKgalgC4l8QEYYS8X4JhkizQvJsOudZb3BcBxoZnObKPTIPCf4G/2PbNZUf65xErFts0VA4gDXMjDSc9IhWaxUWBCBoFKjU6yKyoe2cu/UlufPLWWdjpNI1o5eoKCsDKGN2TO1soFhDlTg7xz4eIDP0NTA/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoDHLkBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoDHLkBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3974C4CED1;
	Wed,  5 Feb 2025 13:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763129;
	bh=ij/ZxVh3CHnNGzXO/GSPd3fYYZkvu6FlsG0lrdcVM04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YoDHLkBGCZwJQJNsWSo17G9xjbCwzJgtEHobDgdl46Sw+Nyv09wqMLUvCxlTagx/a
	 qESkAwMaJ866i6WDe0SC8cgMjjTjHROn2Y+WbjG71dKkAa1EJaJaS9T8ZqQ/bHWQt+
	 GYgwES8OFdC6S3lexh9Bs7LAaPg9o305dHitMdP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/393] dlm: fix srcu_read_lock() return type to int
Date: Wed,  5 Feb 2025 14:38:41 +0100
Message-ID: <20250205134420.381958140@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 57cdd1a1cf1464199678f9338049b63fb5d5b41c ]

The return type of srcu_read_lock() is int and not bool. Whereas we
using the ret variable only to evaluate a bool type of
dlm_lowcomms_con_has_addr() to check if an address is already being set.

Fixes: 6f0b0b5d7ae7 ("fs: dlm: remove dlm_node_addrs lookup list")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 32dbd1a828d01..0618af36f5506 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -460,7 +460,8 @@ static bool dlm_lowcomms_con_has_addr(const struct connection *con,
 int dlm_lowcomms_addr(int nodeid, struct sockaddr_storage *addr, int len)
 {
 	struct connection *con;
-	bool ret, idx;
+	bool ret;
+	int idx;
 
 	idx = srcu_read_lock(&connections_srcu);
 	con = nodeid2con(nodeid, GFP_NOFS);
-- 
2.39.5



