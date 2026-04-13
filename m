Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D634A24E4AF;
	Mon, 13 Apr 2026 16:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096864; cv=none; b=Fh4H1JOrEOok3IJee2bv0hKwzVJRvqUTwl9r7m6yR71oVPqFbvJ+SaRzqFi5DhYsVsRC42dj1Sl94C85nrWgEYXKWKmC2hdTxx+ab8lJq5aSoKKkkF/Sraq/KnIMInspxBYA5Ogy237h4Li5e5a60TiVzu7nldDAp0TqABZLcS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096864; c=relaxed/simple;
	bh=hvWOM+ei0W60wPjjKqd+FNn/7v5dZinvrZ3PU8tIVmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuWLm9Vv8dHFWxZJA31Ex/km5Rbwus8ZFZZU1RP30KT0v5OkG3TA9JkAPGcoZi1unYvPixTo4wwkfQAMVgfbBF6QXnxxmrvgIrGW9FXEkb6Et4ktYNQq8eo369gHCvdrGUvA3xNGm4U67jEufqX0hx11cs98W7JFm9qU3rGodtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIeG7ont; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIeG7ont"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C74DC2BCAF;
	Mon, 13 Apr 2026 16:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096864;
	bh=hvWOM+ei0W60wPjjKqd+FNn/7v5dZinvrZ3PU8tIVmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nIeG7ontY05NW3jXuQOJh+li5SgotA7kZScMQJb2qRJyslqDnxjobmMegtAS2O8Sc
	 5UiriIvumKapIp7tWdZaKH9c1P8soi+18M21BuyISanYj+/vA1CFLns5oX+Xf4VXsx
	 QRJLrm1tFpAS2POFCDReq/472bNyus5Tjq4PP3a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasuaki Torimaru <yasuakitorimaru@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.6 21/50] xfrm: clear trailing padding in build_polexpire()
Date: Mon, 13 Apr 2026 18:00:48 +0200
Message-ID: <20260413155725.304611882@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yasuaki Torimaru <yasuakitorimaru@gmail.com>

commit 71a98248c63c535eaa4d4c22f099b68d902006d0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3583,6 +3583,8 @@ static int build_polexpire(struct sk_buf
 		return err;
 	}
 	upe->hard = !!hard;
+	/* clear the padding bytes */
+	memset_after(upe, 0, hard);
 
 	nlmsg_end(skb, nlh);
 	return 0;


