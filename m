Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BB0408039;
	Tue, 21 Jul 2026 19:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662294; cv=none; b=qLkWTUD050VUm273ZyazBHMZetOTjXqZJJEz6BRDfDVqoPLp0PMAKISfBQ+7Pb/fe3sXnxWvK8MmCItakBQEFSHuDjFsLO9hU5jjkwOQmvgSna0W122ExLWnx6ZWDmyC7QNTs/zVS6ZX0Cl/CVSGNMFy+34d379o8Bc4qks7Nks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662294; c=relaxed/simple;
	bh=aDwZK5nwMe9YROSXT+Y89x0bBrrog51W2pwTwzFZ5u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcpFvtVuovR3eyNwJfiBQ2JCN50ubvvpbRwlx7NHH6JSRPVmdfNPK9Vngne1NlexoUo06FmNnf9ht7U2jJkDLgdF7/O/Z5yZU1LKKSSuG3AEAWoGXpLhWrhhanDe/ZS8lHVsMxVpH0gs2YYTlsvPtg16aLU043EETmMfc4qLcJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwBY29wI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwBY29wI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E3C1F000E9;
	Tue, 21 Jul 2026 19:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662293;
	bh=KVqHyVb+APL93rqLKg5E3Y3pXNXa0SfMJoebyTpu+k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QwBY29wI+PIC9m1EJO6Lq4RnODAsTBZaMgRUZGqhytbNbzXtreZBBkI7LYEuuHS80
	 +ZQLH6Uyggm3O9v4fDTXlBUNCXqtedE1TKZfdOuKwUdlz1dXdNGGrMfHW3tjrASwDo
	 4p76D6Kj0ZunpxR5B2kN/bEQ37OLhOB06jPwO0BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0390/1276] KEYS: Use acquire when reading state in keyring search
Date: Tue, 21 Jul 2026 17:13:53 +0200
Message-ID: <20260721152454.835972770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit c1201b37f666f6466ab1fd3a381c2b7a4b7e9fee ]

The negative-key race fix added release/acquire ordering for key use.

Publish payload before state; read state before payload.

keyring_search_iterator() still uses READ_ONCE() before match callbacks.
An asymmetric match callback calls asymmetric_key_ids(), which reads
key->payload.data[asym_key_ids].

Use key_read_state() there to complete that ordering.

Fixes: 363b02dab09b ("KEYS: Fix race between updating and finding a negative key")
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260529033406.20673-1-hanguidong02@gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/keyring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index df2580072cfe16..e105349794f23e 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -576,7 +576,7 @@ static int keyring_search_iterator(const void *object, void *iterator_data)
 	struct keyring_search_context *ctx = iterator_data;
 	const struct key *key = keyring_ptr_to_key(object);
 	unsigned long kflags = READ_ONCE(key->flags);
-	short state = READ_ONCE(key->state);
+	short state = key_read_state(key);
 
 	kenter("{%d}", key->serial);
 
-- 
2.53.0



