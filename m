Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053DA426693;
	Mon, 17 Aug 2026 14:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978218; cv=none; b=NAG9jcGgmu3SIS2Tw3CnYQ6Yhno8NXMxUKx+lVWmUau9y/9t/HUKwtUVwKDJo+1sDG3glYksfmcO6SJyODkLREScnHQuib0+00Ej6Ec5uVJyT0rpwt2SmjVN3BMSnlem03FS/t56Tpk5HiosDAF2D0a/BglyYNrSPMZd0A4eSk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978218; c=relaxed/simple;
	bh=uyJWP6tCYR4UmerHo2PnYmTnPpcgHAfrxRCzblTWWeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPKw6LWaOTKoFqtNmu2mHepgl/1jsRcOByBu1srXz0cbc0y3+cAeUy7FSluX/Lt+5VRaebF29DlRieoFrYjDPgGpoMQpmAYgXIKI//lrpdyH8yi5mGeg3RiKC9hpNQkTnTOdDNoQIczggQQStH+jJPvGnyxwW8HA47LnicBunvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSm9Jtua; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSm9Jtua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFBD1F000E9;
	Mon, 17 Aug 2026 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978216;
	bh=LvcRO0Cct0bPg2hRhqHhhkoM7DsmrYzKrez6+Jf49SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zSm9Jtuashxe9yfh+O/DI2YKXGMLwT45vfqMyxyCS0RCtb2L968Jyc83m2plXPFJv
	 vi8vTT/7uETg40A8wludm0QZJUelqwVUVR10GXOyXIB9YWk6AtqHJWbY6q7iC7TkNS
	 iF3fupyBIf0kSabcr/Diets1cfawDDKB4ttjHA+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 142/181] ipv6: prevent in6_dev_get() from resurrecting inet6_dev
Date: Mon, 17 Aug 2026 15:33:56 +0200
Message-ID: <20260817132541.237515564@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

commit 0e243671bc7b8eaf00f83dd2f4367436dc0cff98 upstream.

in6_dev_get() reads dev->ip6_ptr under RCU and then unconditionally
increments its refcount. Device teardown can clear the pointer and drop
the last reference between these operations. The increment then
resurrects an object whose RCU free has already been queued, so callers
can use it after it is freed.

Use refcount_inc_not_zero() and return NULL when the object has already
reached zero. RCU keeps the memory accessible through the attempted
reference acquisition, and a successful increment pins the object for
the caller.

An independent run on the exact unpatched 6f5156d7a31a (v7.2-rc3)
kernel reproduced the invalid reference acquisition as UID 1000:

  refcount_t: addition on 0; use-after-free.
  ip6_mc_source+0xef4/0x17e0

It was followed by the corresponding reference underflow in
ip6_mc_source(). The supplied trace from the same unpatched revision
additionally shows the access after the RCU read-side section ends:

  BUG: KASAN: slab-use-after-free in mutex_lock+0x76/0xe0
  Write of size 8 at addr ffff888015b50240 by task poc/1219

Bug found and triaged by OpenAI Security Research and
validated by Trail of Bits.

Fixes: 8814c4b53381 ("[IPV6] ADDRCONF: Convert addrconf_lock to RCU.")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260803122758.666112-1-david.lee@trailofbits.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/addrconf.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -382,8 +382,8 @@ static inline struct inet6_dev *in6_dev_
 
 	rcu_read_lock();
 	idev = rcu_dereference(dev->ip6_ptr);
-	if (idev)
-		refcount_inc(&idev->refcnt);
+	if (idev && !refcount_inc_not_zero(&idev->refcnt))
+		idev = NULL;
 	rcu_read_unlock();
 	return idev;
 }


