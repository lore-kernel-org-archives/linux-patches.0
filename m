Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905803B6BE5;
	Tue, 21 Jul 2026 22:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672127; cv=none; b=FjDikI215pRu8h4IUEjPMNJj+9v5CcyOp06wAVwGR0m5IRspW63bjDN7ajdjrgANJ3dIpnWJ2ibJS2J9zVGewL9qAWxrjwWEXUq8IkVtTTdjalu8rCE4hZucQb9ohbOxupHTTEaJ1qHKXZ1ea/tP/4Vt/wqGYNd44S5ptc2mGAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672127; c=relaxed/simple;
	bh=YlvDe1Bn+FIXS1y/yPMtDEmUvT73x69hONWLT6zo040=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6XzsU57sW9+kWvGWy+o+snc9bDxxf6EdUUSnRd86MoLT5SGgL4QseW1wsrtZykkzVwDEwzbYsF8jtxiRwUez5gQnpEQHGLQOtkZg5AXylrhxb6e3pX433NB2KVmeNCNbx9aTf3c5L8RIZzFAizS0EE9GuNmBOmPKdzd0h9yaMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qmBdE+S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qmBdE+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37891F000E9;
	Tue, 21 Jul 2026 22:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672126;
	bh=Vg3Zgdt0mvvJOt9OVtj2E4ZoWyGqJ3qqwtR5ImjBQWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0qmBdE+SExBliaVwQSnpW8O1ymggQ+jpkDUvzWa7HaXc42ocn5eiB145/9qMSn0Fj
	 orXh/idp1KqLyY2q/wsONMy6IuSk8aUefCwtp5YuT1VMl98SCgvshTEn1DiQwdJeIS
	 PLITOSt3hjHB9eCC7BQgbapXWpIaG+AMoOaa5xb8=
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
Subject: [PATCH 5.15 508/843] afs: Fix error code in afs_extract_vl_addrs()
Date: Tue, 21 Jul 2026 17:22:23 +0200
Message-ID: <20260721152417.456868869@linuxfoundation.org>
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
index acc48216136aed..631ee7e0629dc1 100644
--- a/fs/afs/vl_list.c
+++ b/fs/afs/vl_list.c
@@ -88,7 +88,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(const u8 **_b, const u8 *end,
 {
 	struct afs_addr_list *alist;
 	const u8 *b = *_b;
-	int ret = -EINVAL;
+	int ret;
 
 	alist = afs_alloc_addrlist(nr_addrs, VL_SERVICE, port);
 	if (!alist)
@@ -106,6 +106,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(const u8 **_b, const u8 *end,
 		case DNS_ADDRESS_IS_IPV4:
 			if (end - b < 4) {
 				_leave(" = -EINVAL [short inet]");
+				ret = -EINVAL;
 				goto error;
 			}
 			memcpy(x, b, 4);
@@ -116,6 +117,7 @@ static struct afs_addr_list *afs_extract_vl_addrs(const u8 **_b, const u8 *end,
 		case DNS_ADDRESS_IS_IPV6:
 			if (end - b < 16) {
 				_leave(" = -EINVAL [short inet6]");
+				ret = -EINVAL;
 				goto error;
 			}
 			memcpy(x, b, 16);
-- 
2.53.0



