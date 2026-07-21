Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000ED322DB7;
	Tue, 21 Jul 2026 17:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653556; cv=none; b=R6T7b6LmghJMEnxxDT4Urrnw0LJZALT3yr+j9xsqWhkitgtWannvPN8vOJnvZuGHYNwlNVHv/9quFatmwZKmyz5dNP/zYkmBFG4AXowaFIp0xRj14TqdIgtO9DGwKKiHPe50dKWViUYI2ue4t4rNroWXPa8KobOEYWtZ2pTYhSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653556; c=relaxed/simple;
	bh=NZU3hJ/Oa/SGkgvqyEb9mhXvOs284prjl0WX3kyi4EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meAABvemh1hNfX83sXzedM6prN6EcEjClQ+3SZmV10qcDqi7VMbQmXfAgbAjOJnBvkLISsADQzws82w5SWcIwG5EIKBHytIteHWkvXcS3nrioIxIgMhG9w1xSJrUXJp5z5aDuUbnz0wmp/vBecZyfjR9lytjJv13U+MovPLHUk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLUR68jU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLUR68jU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF101F000E9;
	Tue, 21 Jul 2026 17:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653554;
	bh=qLkyMc3kkc97k7WKUNJw2nUg/wMdniM8iNFj1kyZfzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tLUR68jUOLWEXFevYVq4xsaPMN80n9i4ihnq5XNITW9VWidFsUgawOGbdlub32dp3
	 7EsP9HPYH9u2cZc1vHJOda5ztRp3w593/5obOe5GkrL3ZFipIf2Sd0Rd6cSzFvvKRF
	 OFFP5KMOG6Fn7V3fhNOtlpK4wwhWLQOgihtfgrL0=
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
Subject: [PATCH 7.1 1370/2077] afs: Fix error code in afs_extract_vl_addrs()
Date: Tue, 21 Jul 2026 17:17:23 +0200
Message-ID: <20260721152625.130568199@linuxfoundation.org>
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
index 3e4966915ea4cc..003889cf0f18dc 100644
--- a/fs/afs/vl_list.c
+++ b/fs/afs/vl_list.c
@@ -92,7 +92,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(struct afs_net *net,
 {
 	struct afs_addr_list *alist;
 	const u8 *b = *_b;
-	int ret = -EINVAL;
+	int ret;
 
 	alist = afs_alloc_addrlist(nr_addrs);
 	if (!alist)
@@ -110,6 +110,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(struct afs_net *net,
 		case DNS_ADDRESS_IS_IPV4:
 			if (end - b < 4) {
 				_leave(" = -EINVAL [short inet]");
+				ret = -EINVAL;
 				goto error;
 			}
 			memcpy(x, b, 4);
@@ -122,6 +123,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(struct afs_net *net,
 		case DNS_ADDRESS_IS_IPV6:
 			if (end - b < 16) {
 				_leave(" = -EINVAL [short inet6]");
+				ret = -EINVAL;
 				goto error;
 			}
 			memcpy(x, b, 16);
-- 
2.53.0



