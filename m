Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483E621B191;
	Sat, 30 May 2026 17:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162962; cv=none; b=FNasPi+qlpPe+8RhtXCwNQCmzH5tF1ybS+IGMYauRaIPZ3XUoSKg6OxXBufFovYcbLCFVuXqDZ8qUqRl0MbRiL7YmXjsDgZAjhFnsMJZ3IO5sis3Zwy2I4AnCgG0BsR8r74+tzOR3vHvVsCp5lzi2qLCJ8p5vgoy/ShA3zPUqi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162962; c=relaxed/simple;
	bh=UC2ArauqVji7X3REUSJ1NpwBtJ130hPJWddlGK3KCbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E88rv1glG2r9kie2Gc+nQIFfu9zzLQrD+PPEMOlP2n5p2Xlu0OPrvAuZcFbBR94TdSeBPeVNmqUxt0jymkxnV7voLFNgEpRmwSPnRjmOdScBaOzFBClB0VzrcVb+p1KDrTmaGMhthw7mu328cUYW3FeCspoPmFnvhG+th3UazTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNUskzxB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNUskzxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5461F00893;
	Sat, 30 May 2026 17:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162961;
	bh=Xn9rcvCStmOuROhpWmMFtRXVIkkBh5apI1f0KfX04Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FNUskzxBsSuiS5O2yS/D1zVV1DuLxeLDcocxHvYpSFzq9gXvalhQ1MznOuMZdNxYj
	 Iu5wgnd2aWA1KmPJJsnq9Tkohkf2FlkcOS59Dx3+To+AV6LREh+Tsm7HffXno6wea0
	 s2gpqKxruesjnciZlsaw4SzZKQFIbmK0/3MCZBXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasuaki Torimaru <yasuakitorimaru@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/776] xfrm: clear trailing padding in build_polexpire()
Date: Sat, 30 May 2026 17:57:02 +0200
Message-ID: <20260530160243.144331317@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Yasuaki Torimaru <yasuakitorimaru@gmail.com>

[ Upstream commit 71a98248c63c535eaa4d4c22f099b68d902006d0 ]

build_expire() clears the trailing padding bytes of struct
xfrm_user_expire after setting the hard field via memset_after(),
but the analogous function build_polexpire() does not do this for
struct xfrm_user_polexpire.

The padding bytes after the __u8 hard field are left
uninitialized from the heap allocation, and are then sent to
userspace via netlink multicast to XFRMNLGRP_EXPIRE listeners,
leaking kernel heap memory contents.

Add the missing memset_after() call, matching build_expire().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Yasuaki Torimaru <yasuakitorimaru@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
[ replaced `memset_after()` macro with equivalent manual `memset()` call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3389,6 +3389,8 @@ static int build_polexpire(struct sk_buf
 		return err;
 	}
 	upe->hard = !!hard;
+	/* clear the padding bytes */
+	memset(&upe->hard + 1, 0, sizeof(*upe) - offsetofend(typeof(*upe), hard));
 
 	nlmsg_end(skb, nlh);
 	return 0;


