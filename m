Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57AD2D97B5;
	Mon, 13 Apr 2026 16:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096712; cv=none; b=GIGTWnqwVe3MVHqlXNEZwdpmK/qx1DVVtq3+MSq0W7M4pS6GuXzJkZP/U4Ggw5agjsXWGgIdgmodYEnJUiPS70oEqoNX6TQJzxgBykIvDqVzX5RUE36lJK2uOLXHstzvilz3iPqZqwsVJMQy9XM+XdyDh8GoTduBWxgfoEO/i+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096712; c=relaxed/simple;
	bh=RUyWKhxPmjpFD3Q5qDRqbSjO3VnFpgz5VbrIeFez/Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUlHPrpifzn5/6sXJaTod3ZLdMUwC2hEpirIU1cn0toxb7qS77/Hqni/u6cohP+IJ0xBWBAtLGCsCd4kpehGbRglXqGjocqguyOz2ugzWmFP1N9qoKr5eg/kXA0C7XEq5REmLa2beHFEQflXOhViFynSYiNU2HzlgG0VFZ+CQRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKWatwJb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKWatwJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D35FC2BCAF;
	Mon, 13 Apr 2026 16:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096712;
	bh=RUyWKhxPmjpFD3Q5qDRqbSjO3VnFpgz5VbrIeFez/Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKWatwJbmlCE0kjxlAcsyQEVUNH/WQ4thR+Vyoz30ikmDf2DNN2hMVvBZl53VrYRs
	 oOTI7cV8AnF+Q1BT3wXmH/5iM0EKJM5g6lr7Hv6yYObzd0un9Xowr+GU0T8d8fYqX4
	 9gpBgLHsJfzoqEM3PI/b5rn5PRV0aJLWpNWHetCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasuaki Torimaru <yasuakitorimaru@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.12 33/70] xfrm: clear trailing padding in build_polexpire()
Date: Mon, 13 Apr 2026 18:00:28 +0200
Message-ID: <20260413155729.421636357@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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
@@ -3849,6 +3849,8 @@ static int build_polexpire(struct sk_buf
 		return err;
 	}
 	upe->hard = !!hard;
+	/* clear the padding bytes */
+	memset_after(upe, 0, hard);
 
 	nlmsg_end(skb, nlh);
 	return 0;


