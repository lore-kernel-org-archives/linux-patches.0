Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673D53AA4F8;
	Mon,  4 May 2026 14:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903969; cv=none; b=kLnoCwKTt04vZU9g5LPuLyNYyfITmI3R4v8cXNhvrXwerIV458vrIs/JJ9LUz1A+2I+5FsxyPWAi4uPCyV45x6YxqLPg0cvxf9Q20POnWsieu/1GwoUrlVFiMZVnzwnHaVj7R1crP07XTsEPPFAwhpAdj5Z+28Ifypoecp7Qw5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903969; c=relaxed/simple;
	bh=+XgYqY2VPBR1BtUtvipQYfZE2uYbgy42/vysquHCilc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjmHTrAquAwdt919JsHfXW201JcENNWF2Tfgm8ZEpxonw3Kky0ktW2Wi4Ydu5Eq98bWxTKkF2EETDPynC5XhA0vwQ7W8T1QAde5jJlxuUraN8nYKHh6RqLDJSm6FTBfStax16cFIlOclm/JB1JcyJ4djRkbr/qa4fnQ6qabwFF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUTN8HGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUTN8HGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D0FC2BCB8;
	Mon,  4 May 2026 14:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903969;
	bh=+XgYqY2VPBR1BtUtvipQYfZE2uYbgy42/vysquHCilc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUTN8HGFo4NH6u94R/wrj9AhZlK+KGfBrqymji9DHiMxwBaHNStHspikoSujCnGrM
	 NUgSl40OfgChd0r/BAXpZ2NgEdG6LNUfux4/Rb7eFceSlzHVmKE9rkcFNs8dxtAPBb
	 xdWKPPEjgajo8GFwWM4K4PIp4dHwEUl7soHdccuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 133/275] libceph: Prevent potential null-ptr-deref in ceph_handle_auth_reply()
Date: Mon,  4 May 2026 15:51:13 +0200
Message-ID: <20260504135147.842327463@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit 5199c125d25aeae8615c4fc31652cc0fe624338e upstream.

If a message of type CEPH_MSG_AUTH_REPLY contains a zero value for both
protocol and result, this is currently not treated as an error. In case
of ac->negotiating == true and ac->protocol > 0, this leads to setting
ac->protocol = 0 and ac->ops = NULL. Thereafter, the check for
ac->protocol != protocol returns false, and init_protocol() is not
called. Subsequently, ac->ops->handle_reply() is called, which leads to
a null pointer dereference, because ac->ops is still NULL.

This patch changes the check for ac->protocol != protocol to
!ac->protocol, as this also includes the case when the protocol was set
to zero in the message. This causes the message to be treated as
containing a bad auth protocol.

Cc: stable@vger.kernel.org
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/auth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/auth.c
+++ b/net/ceph/auth.c
@@ -245,7 +245,7 @@ int ceph_handle_auth_reply(struct ceph_a
 			ac->protocol = 0;
 			ac->ops = NULL;
 		}
-		if (ac->protocol != protocol) {
+		if (!ac->protocol) {
 			ret = init_protocol(ac, protocol);
 			if (ret) {
 				pr_err("auth protocol '%s' init failed: %d\n",


