Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062759;
	b=ktwrUZjNT7pGUm61Q0wAwobTJ87S7xfpyx9wBSkWbdmoQZhW/AitkjM7Pob5/OsR9cCK
	 EfnGOX6u55jnNS2WrSTWlm6+fyrPtEvitweC9Y0u/yXUBUJC8xkQHAstEOVnI1lE/n+5m
	 pAuZAUnUBueCU6XtgZKEyT/DYOQ7U2YE7HW80i5ZDG5eCparseqDrTmn42wU1FSxg3QEm
	 90TIN5M87hLTtjTaA4YzVfGzcczh8AZ4olF1gahl7klC0TuDqbTVublPLMboekJ+9URyY
	 fQ3ikSIL/FeLLC+Tmly3dHbOMG21ENwb27l04Wuta5g6vuZJyIB4G/VA+IP83FMliCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HJ5/ylU/bAUBZO9xRPdBTBLjpUndXiOXryoxPdtEFN4=;
	b=lamUKzbSu0hvwkKYI+//z00BasP1p8pGNpgqotbOHfF6OWOsf2f4YORb9wFdz31bqkH4
	 LHlwIHKqaoJpumudSZ+bDLalVP2H/o7bIJCPSJITQ12C/g6TuFgqJ+GXbInDwMoWLO7HP
	 sNef0n4GxVt8DGcfwiGXklVPkqzAz68hNQD/kshuLu+4u9TrboxANhKpvRuKtdxClq6xo
	 khe9xHhcI0MWtGYy3LeLBT5N0BUShfvbXhsujocxpkfd9R/7GVV2VFmf7+uu9AB4XZYiZ
	 vaWDbcitgerqvERS8p9INtSWcBhuDUhB47bxQ2Hmq2tul+c4p87RXljEiC/bAcU9I9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALTotvpl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1008606A32D;
	Sat,  7 Nov 2026 14:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALTotvpl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD761F008A1;
	Sat,  7 Nov 2026 14:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062759;
	bh=HJ5/ylU/bAUBZO9xRPdBTBLjpUndXiOXryoxPdtEFN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALTotvplTxf/wrhCaz7qDJsCu9o+NLzbaQXBoI65W6j4pjDVJasp+8nZbakPzmBte
	 Lv/Pew5mrmcdYkNKtta6et+Za9g6+x+Yui2i3WQ84JGADsZtsdbV9pxeTRrktVoFVS
	 XFYJu7o1rZUw4CH1y1sRq8Jp4j561F1sERGWTRiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/869] fs_pin: publish pins with RCU list helpers
Date: Sat,  7 Nov 2026 08:45:52 -0500
Message-ID: <20261107134854.880636088@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 8d01d6b4c17c406f37a9b6edac93dfb858af30d0 ]

pin_insert() initializes a pin before adding it under pin_lock.  The kill
paths read the list heads under RCU without taking that lock.  Plain hlist
insertion does not publish the earlier initialization to those readers.

KCSAN weak-memory checking reported acct_on() callback initialization
racing with pin_kill() after the superblock-list publication.  The
corresponding LKMM model permits the stale read with plain publication;
the RCU release/acquire pair forbids it.

Use the RCU hlist add and dereference helpers for both pin lists.

Fixes: 2798d4ce6160 ("acct: get rid of acct_lock for acct->count")
Cc: stable@vger.kernel.org
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260903002100.34822-1-kmehltretter@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs_pin.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/fs_pin.c b/fs/fs_pin.c
index 47ef3c71ce907..1a508f2167e0a 100644
--- a/fs/fs_pin.c
+++ b/fs/fs_pin.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/fs.h>
+#include <linux/rculist.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include "internal.h"
@@ -22,8 +23,8 @@ void pin_remove(struct fs_pin *pin)
 void pin_insert(struct fs_pin *pin, struct vfsmount *m)
 {
 	spin_lock(&pin_lock);
-	hlist_add_head(&pin->s_list, &m->mnt_sb->s_pins);
-	hlist_add_head(&pin->m_list, &real_mount(m)->mnt_pins);
+	hlist_add_head_rcu(&pin->s_list, &m->mnt_sb->s_pins);
+	hlist_add_head_rcu(&pin->m_list, &real_mount(m)->mnt_pins);
 	spin_unlock(&pin_lock);
 }
 
@@ -73,7 +74,7 @@ void mnt_pin_kill(struct mount *m)
 	while (1) {
 		struct hlist_node *p;
 		rcu_read_lock();
-		p = READ_ONCE(m->mnt_pins.first);
+		p = rcu_dereference(hlist_first_rcu(&m->mnt_pins));
 		if (!p) {
 			rcu_read_unlock();
 			break;
@@ -87,7 +88,7 @@ void group_pin_kill(struct hlist_head *p)
 	while (1) {
 		struct hlist_node *q;
 		rcu_read_lock();
-		q = READ_ONCE(p->first);
+		q = rcu_dereference(hlist_first_rcu(p));
 		if (!q) {
 			rcu_read_unlock();
 			break;
-- 
2.53.0



