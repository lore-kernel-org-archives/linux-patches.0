Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EC01BA294;
	Tue, 27 Aug 2024 15:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771480; cv=none; b=N7hr9/lmBqb69gWmQ2mREv4SDz3oM3ScJBUdwvtc+HnMFwKwjit9SfOdFik9VHdYL/oLD9FM5nkvFX/pYUsFbtkwiIAjP6Zw2T8jhACAY0FVaUfi6SmArSHmXT+cn5d5O7f/fQxKAgQEkK7SbtP7S4QGfZ2Seb3xPZj8z4GTkTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771480; c=relaxed/simple;
	bh=HlxWOut96c5Cu+s2N7Ek8a6JpymZOmZxFdJO4p5OMb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAEfwUCyx7s/bmRAvBY/1F6j8Va0TVXTLa+m70DNCFXFZDbe1euy9WrPTUPhVLKbfNinNkws0BUB1qXH8b+WEdOwVYlJ5qydzS7/akIRBeBtqtZueI9ISIaln/NjaiVHXYzqHAjp1viuHxEqBTe81C3VWHzJt83KfZtJBteZWlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpgs0xGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpgs0xGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F373C4DDED;
	Tue, 27 Aug 2024 15:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771479;
	bh=HlxWOut96c5Cu+s2N7Ek8a6JpymZOmZxFdJO4p5OMb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bpgs0xGxLFF2htsZ0COlTglUVSAhMw9rLYZQUNJKyv7dnpZdMluRhYj7uFrcnuA0p
	 lBYnM5ochn242a6FYkyuURldBr3iUQFN6nUSiF+75jC3rK7ZuLXkC66G8McwVWd0CN
	 tc2uX+xqVV+PW8grIhOaYq+br3u3BA0So9YoYbd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 169/273] bonding: fix null pointer deref in bond_ipsec_offload_ok
Date: Tue, 27 Aug 2024 16:38:13 +0200
Message-ID: <20240827143839.839769499@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 95c90e4ad89d493a7a14fa200082e466e2548f9d ]

We must check if there is an active slave before dereferencing the pointer.

Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2370da4632149..55841a0e05a47 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -604,6 +604,8 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 	bond = netdev_priv(bond_dev);
 	rcu_read_lock();
 	curr_active = rcu_dereference(bond->curr_active_slave);
+	if (!curr_active)
+		goto out;
 	real_dev = curr_active->dev;
 
 	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
-- 
2.43.0



