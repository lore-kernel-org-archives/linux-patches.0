Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51668332919;
	Sat, 30 May 2026 16:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160017; cv=none; b=HR/Vp1uLfy/Kw2hvyEtrcLgVbSRWvSQQmZtJw2MXYnSw0DvJuHpb1vgwTXYMq7sdS38enXWbnYdG8ywK1WUozmb1gq6J0kvxI6FyNDrhBcGql2a/l11IT3Dz//KwH4qq7+MpGtpbGKpxC8qPPI+wC/ZT/5ARG6k9Fo15ohZV0dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160017; c=relaxed/simple;
	bh=LslzZGiElNFFM9FNJbX2SoBE/Y41uo+9mwOWAPLN3zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0iB1YtPFN+AEcS/TN0zvwQPezPZu7H2c6v8rU10AlB4xG06zHMpT2v0ug5VGw3YrgcthlprM8E+EE57RtHYC5z+e9P83OeU2DM7/cnQZN19SJnAjvsv2H8e5h/yOUuvVYKCHmuuh1Eht7uOqbJ3gI97nUJ4Mmf60l/mN2OWeBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtm8BVQu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtm8BVQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9506E1F00893;
	Sat, 30 May 2026 16:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160016;
	bh=wQq24BzuBf5Yr9ahrvHwGimrgg8fzTPlvydag5RBfes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rtm8BVQutuWbZz08X/BACcYhn2varHzRDayzOf8+FQlpEqS4toSsgSYSIsn24XC1N
	 axOUn5fKIigWxI7IGqCd2E9BG+Lg4YNqZuMeq4yhFiNOuezCceSJf1WcSj46pGOylj
	 3PEJ6ao4yO9tMaV8rQmmzr0w9BZ9g7Zbk3mSoDhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 221/969] libceph: Prevent potential null-ptr-deref in ceph_handle_auth_reply()
Date: Sat, 30 May 2026 17:55:45 +0200
Message-ID: <20260530160306.557054825@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


