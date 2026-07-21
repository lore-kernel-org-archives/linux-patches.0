Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E3244AB7B;
	Tue, 21 Jul 2026 22:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671755; cv=none; b=PBrORlRY/0BvzhG+dBkagWqE0yGGv/+QIfDV+7wlewk4fgj/PmRyZqcJDgftj9h2hdGU9YMWOA4GFuEtjLzzdJkS/mK6vfRxTuiwXo/NmE8DarOtig/0NetAFMWEx8cdiziCkKHrLfRKOqMSC9IMFlWX56ZhfqG/FKXo57blnbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671755; c=relaxed/simple;
	bh=ICm4UcvQ84hQYDjSXv7Y8nXOAGWwT39AbEw855mtsU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGVhQPPv1JM1MNvuXrvcHjSAaR4WAr6cAkFi0eH6FE7hMukp/Yy3I4mw6TFc778koS8AmekKoYPztNcDBPGN+5iH27ziO9oeVwyJubiay+mfWLxi9TqldjCoWnFZxB3Ay1Wicv9fGHpn4t/43qUjN+nPe0fwOzG8bvu9KVkSbRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilgAOD8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilgAOD8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C361F000E9;
	Tue, 21 Jul 2026 22:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671754;
	bh=F04uFMboeLZYb8Ma3CqEc6iuf9Izr6Hu8h58RLOqag8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ilgAOD8JXpmoh4OESoRRom+KRQHPAAHxoOR0kvAF8v33RpBKL8VLi5L3FDRs2+yFl
	 zty8bJ7RGRH9XtHyi8TfZaG7Q7rjnvjuxV7oSWTWjnJplSdyVS0AHwzP0PI2mgA4rK
	 aqewuKm537I701gfE7gENQeWyVwEalBCyYda7KgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 367/843] KEYS: Use acquire when reading state in keyring search
Date: Tue, 21 Jul 2026 17:20:02 +0200
Message-ID: <20260721152414.286326806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1febc2a8abcf66..08aaa9429ab360 100644
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



