Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B945C15E8B;
	Mon, 30 Dec 2024 15:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574276; cv=none; b=lo/9u0KqklgkXvnA8o+lceWCbY5spD8BL6B8x+Ckvi23YM6EYNU5p3tR2WYbcKGO4n5eCCdmqYliA8DXwwG3ZgYfFsqq2w4r6mgysCihO/00vyGXTdP5cqW2n2BnTXikS2hSNJhMMljj2nVYQJNhViQEVCG9FX7d0oLXgcqPhu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574276; c=relaxed/simple;
	bh=JP/x5QOFzz1Z/8ZDHzVyBPK1/7hmW+tRPu8SM3nYwGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPD1D5qHfUK4RRaeaZ70Xmw0yXb/PWVzt6DEnzgvnvnQ6LVJQ6W2F4qFecd9mxxZ39MrohDyRmULH5jxg4BCGBI1TMrukZrrT0jetcea0jpS67b8oD3qr6ziH6DbCFztr0EYgJA18NQBMJdDOsEmop0cnSfshKNfYkvlDJDP0hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Exqi0Ri+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Exqi0Ri+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204DDC4CED0;
	Mon, 30 Dec 2024 15:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574276;
	bh=JP/x5QOFzz1Z/8ZDHzVyBPK1/7hmW+tRPu8SM3nYwGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Exqi0Ri+dYA91skgWnZMLW1tsIhbF1VohxtI56sbgbMjuwsmrGoO+HSU/QPzXB7um
	 EwT5HZwIA+v2lRmCq/Uu4pQEkkURh3JKQlT0ELxP1LFkvRolXqlkwJlmDPJ0sZicJI
	 VBtxkwZBmJa++LqycN2Wu7mlpOKU0PX1VQTkoQCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brahmajit Das <brahmajit.xyz@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/114] smb: server: Fix building with GCC 15
Date: Mon, 30 Dec 2024 16:42:56 +0100
Message-ID: <20241230154220.363752554@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brahmajit Das <brahmajit.xyz@gmail.com>

[ Upstream commit e18655cf35a5958fbf4ae9ca3ebf28871a3a1801 ]

GCC 15 introduces -Werror=unterminated-string-initialization by default,
this results in the following build error

fs/smb/server/smb_common.c:21:35: error: initializer-string for array of 'char' is too long [-Werror=unterminated-string-ini
tialization]
   21 | static const char basechars[43] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

To this we are replacing char basechars[43] with a character pointer
and then using strlen to get the length.

Signed-off-by: Brahmajit Das <brahmajit.xyz@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 75b4eb856d32..af8e24163bf2 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -18,8 +18,8 @@
 #include "mgmt/share_config.h"
 
 /*for shortname implementation */
-static const char basechars[43] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
-#define MANGLE_BASE (sizeof(basechars) / sizeof(char) - 1)
+static const char *basechars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_-!@#$%";
+#define MANGLE_BASE (strlen(basechars) - 1)
 #define MAGIC_CHAR '~'
 #define PERIOD '.'
 #define mangle(V) ((char)(basechars[(V) % MANGLE_BASE]))
-- 
2.39.5



