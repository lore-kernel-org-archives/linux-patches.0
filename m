Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718C23CAE7F;
	Tue, 21 Jul 2026 22:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674023; cv=none; b=e1XRIfDGu9CoIs5Lyi1N3LWM2Hhx2HLJKF+9nPPorvngzp76JkQNs4XHoBwz34ceq2wO9FJBlEou6SOEJ0kr1lfYwLW3/I5D/GABfcImLgEAPIRs6hrVu44emKjSOKA4FCaDZaGssoxJ2KFFwRIUk08GxG2reN/MkZhJGMaiFvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674023; c=relaxed/simple;
	bh=z1MFFbiK3eRL8qiulUvETjfYq8qh9RuZSeg1kXfDDvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bm9z6nbfUsOtHie60JhWkRyD4Nwisvxtx5Vnq4TNvHmpUSbtL8hu7rgcuhieVp45OxrIZaOKFh5SUk/kfOvpjGucWRyP/i8HXyoqgKSDxlBQf2oehPxuqVUl8NSeOeHyDLgjUlOf1DG4r+6vTzwypWTIw4zqm07sEKd0b4W3a+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dE6IBHrc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dE6IBHrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F741F000E9;
	Tue, 21 Jul 2026 22:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674022;
	bh=mSgx5UyDDcTkha//UbfWjs6zfFoZ7fuwEkwv/rh6D90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dE6IBHrcmD8J40TYDZzirRSD1OwXKyCtyNqdis5x2PqBXhicjTxF56XXEV2g6r8D4
	 /VLBdqvyYZvsqR8VHhiKo2kBuWZaNfCFrNV376NxBlOMkKVHAfDht/aYdsz5VEZ+BV
	 ot+Ty3l7UqbZ1ZDL42XGMgjLCQdCitCyxG7nqm/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 384/699] afs: Fix error code in afs_extract_vl_addrs()
Date: Tue, 21 Jul 2026 17:22:23 +0200
Message-ID: <20260721152404.356232408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 4897cb71d4ab1f7e1a214adb1e4b80176702368d ]

The error codes on these paths are only set on the first iteration
through the loop.  Set the correct error code on every iteration.

Fixes: 0a5143f2f89c ("afs: Implement VL server rotation")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-3-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/vl_list.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/afs/vl_list.c b/fs/afs/vl_list.c
index 38b2ba1d9ec0df..8508d225509bb0 100644
--- a/fs/afs/vl_list.c
+++ b/fs/afs/vl_list.c
@@ -95,7 +95,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(const u8 **_b, const u8 *end,
 {
 	struct afs_addr_list *alist;
 	const u8 *b = *_b;
-	int ret = -EINVAL;
+	int ret;
 
 	alist = afs_alloc_addrlist(nr_addrs, VL_SERVICE, port);
 	if (!alist)
@@ -113,6 +113,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(const u8 **_b, const u8 *end,
 		case DNS_ADDRESS_IS_IPV4:
 			if (end - b < 4) {
 				_leave(" = -EINVAL [short inet]");
+				ret = -EINVAL;
 				goto error;
 			}
 			memcpy(x, b, 4);
@@ -123,6 +124,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(const u8 **_b, const u8 *end,
 		case DNS_ADDRESS_IS_IPV6:
 			if (end - b < 16) {
 				_leave(" = -EINVAL [short inet6]");
+				ret = -EINVAL;
 				goto error;
 			}
 			memcpy(x, b, 16);
-- 
2.53.0



