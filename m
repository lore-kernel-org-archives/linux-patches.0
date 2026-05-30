Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EE827E05E;
	Sat, 30 May 2026 18:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165648; cv=none; b=cpseC5a6NzL3AI0C9y2SEStto1Np4XsOugW9Kn6FClRDVQjwGRGYGi4wNwURFpaR/cr3l72b2ibMLmsyJ7y0g5vHZu/t1CSWq3yriauLQ7ZHoAc2b1g+H0MmgeTZcBA9UEh9+WOkuHFr2u/AvW2lIMqTcPwAxchuQiDmD4cZifk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165648; c=relaxed/simple;
	bh=RSVHDFyafrPotO6f5tOad1go6yqPm7D13AHU80JJiaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+ayz3Z5iYeOefkJgx1BOkbYGsEQk+WMyKA2LXRLXeznplbAgt5PGhXhewFVjXQp93135etIECYNefZ0ItXtQZ8sMqrcGdWA3bQlUZ0Ss0jLrJdDsEVaUDm0eAoHjozsDMIxRJGT0QDEBEhYeTn0XhhoHumej+ejztHTSlc6ifg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oi++MJ4x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oi++MJ4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98CF1F00893;
	Sat, 30 May 2026 18:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165647;
	bh=xpuBm4q+SzTTWltQTWYvoXiS9IKspH0xGtSUB5c1Uig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oi++MJ4x/UKzUcH5q5CAwxZXjPy+JVbsb6PHHh1IiEd6pkmzRA1jB4ncdlLPQnP45
	 +f9qnLMLi2xpicXuBrpgPcC0x0DLHBOol4NremdsKi7c1GQ/Vg5MEAIp9s4iNPNuLB
	 hhZDrVkEXmgEhqPE6bhx1zngeLqvEeQHPzsmZ+vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasuaki Torimaru <yasuakitorimaru@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/589] xfrm: clear trailing padding in build_polexpire()
Date: Sat, 30 May 2026 17:59:43 +0200
Message-ID: <20260530160227.395857382@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
@@ -3290,6 +3290,8 @@ static int build_polexpire(struct sk_buf
 		return err;
 	}
 	upe->hard = !!hard;
+	/* clear the padding bytes */
+	memset(&upe->hard + 1, 0, sizeof(*upe) - offsetofend(typeof(*upe), hard));
 
 	nlmsg_end(skb, nlh);
 	return 0;


