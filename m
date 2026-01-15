Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA4D3D1CA9;
	Thu, 15 Jan 2026 17:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499619; cv=none; b=nOkMptb3RLbHLR57raHkeB3sEJBJhd2aCbPgau46vJHOOX2sgy0KnScK7bxRx1aut4BMZcNXPydSZw7Bg2II2EJm9oEaTZ/TbudC1zXCRrzqUF72qr9lAxsrdlNHKGvUREf9oadafeEPJqlh19MICBQIgTzmn8VHcn4CmVhCi78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499619; c=relaxed/simple;
	bh=YCpKph1RWUxL6uHpu6tOlfiLHUKYtEm1bnATUomk2hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZs6SJT1hJX7rbu2jMTFtvhM7fETYQN9HLiVqwQmL4iUjhkBQqlNznC6b2OUJLwdWc/OxyxLtgCpq+s2yMQN1sku/zPWq5P06+YYkI7nTN0jT/3CigULhxHUXhHDikuwEEu8nmnXkZT2V6eqob44BH5mqnpnACwkbWM8YWTiis8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pz6aULUO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pz6aULUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BEAC116D0;
	Thu, 15 Jan 2026 17:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499619;
	bh=YCpKph1RWUxL6uHpu6tOlfiLHUKYtEm1bnATUomk2hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pz6aULUO7rkZOl0qoWKq8FMvNJHwr7FNhVtzLQxoITMmku6P5XXAEn/URb38ptHC8
	 LJUfM/IM9IASDyqwDvOrNde9gWBfJ/+r3b1yBu4nTLvwnK09eiS8FzuvIvaFDASq+o
	 sXp8B4EpLHgNf+waHb0ZEcrb6iEk+OzI9y/1j2gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fatma Alwasmi <falwasmi@purdue.edu>,
	Pwnverse <stanksal@purdue.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 290/451] net: rose: fix invalid array index in rose_kill_by_device()
Date: Thu, 15 Jan 2026 17:48:11 +0100
Message-ID: <20260115164241.373403764@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pwnverse <stanksal@purdue.edu>

[ Upstream commit 6595beb40fb0ec47223d3f6058ee40354694c8e4 ]

rose_kill_by_device() collects sockets into a local array[] and then
iterates over them to disconnect sockets bound to a device being brought
down.

The loop mistakenly indexes array[cnt] instead of array[i]. For cnt <
ARRAY_SIZE(array), this reads an uninitialized entry; for cnt ==
ARRAY_SIZE(array), it is an out-of-bounds read. Either case can lead to
an invalid socket pointer dereference and also leaks references taken
via sock_hold().

Fix the index to use i.

Fixes: 64b8bc7d5f143 ("net/rose: fix races in rose_kill_by_device()")
Co-developed-by: Fatma Alwasmi <falwasmi@purdue.edu>
Signed-off-by: Fatma Alwasmi <falwasmi@purdue.edu>
Signed-off-by: Pwnverse <stanksal@purdue.edu>
Link: https://patch.msgid.link/20251222212227.4116041-1-ritviktanksalkar@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index f8cd085c4234..04173c85d92b 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -204,7 +204,7 @@ static void rose_kill_by_device(struct net_device *dev)
 	spin_unlock_bh(&rose_list_lock);
 
 	for (i = 0; i < cnt; i++) {
-		sk = array[cnt];
+		sk = array[i];
 		rose = rose_sk(sk);
 		lock_sock(sk);
 		spin_lock_bh(&rose_list_lock);
-- 
2.51.0



