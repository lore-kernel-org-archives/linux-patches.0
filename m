Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840F43EEAE2;
	Tue, 21 Jul 2026 18:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659941; cv=none; b=l8IlWNDKz3+uV0qpEPS2pJifg4VMNJ7egzwjXVrVEGYnzh1jLYxpUs0EWYVHOmLaWxM/ubRREu8bHBzdxDbKtSK4cM+pnTQlwJ5+fuPDIf4MWj9L5Mhdws7FuIly1zWRg7SHHcWoyR4xHHHVJAos9iKJXLS2uzVx2jy3ZdUYCCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659941; c=relaxed/simple;
	bh=9Jxlx8Vkd0jrZKmFKhjWVOMmg0YYuiRkWJLurbv5sMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKvXElFLkbssgvCM1hsuFdtQ9mNbBjJtYAKAVaUwMt2t/iG5HaD04yNuLmZKYEdLiqT9oEghgKUrW25ewCbUazLozdhsl0IWKJAb18KH6u4hAauBnRGIEd2L6Ups3dwiDC9JprsSUJrb6jl+XWyVJdcn9mCljA2qTJ2QinI85Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UN28RQlu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UN28RQlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3D91F000E9;
	Tue, 21 Jul 2026 18:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659940;
	bh=A0r4X91fWycQ7SFyEtfljbZpE4VJSCp+KOHNdguP6KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UN28RQlur1/OibJeOkJZ1ht+UKATKIDHCZ/b2CfXvtdKiU7s0wF3I+k8hUkiVI0TQ
	 ylW+F/4TqOVbJxwcgW9sFOps4wv6f8gQ+oflb6R/KLYyCcYSn6lfPjWncfvCd+j8Tk
	 cu7jfauNpnYMZPsMdeP3KHFBWBhS6xZ+iftrzkP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0792/2077] KEYS: Use acquire when reading state in keyring search
Date: Tue, 21 Jul 2026 17:07:45 +0200
Message-ID: <20260721152611.476566295@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5a9887d6b7be3c..7a2ee0ded7c931 100644
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



