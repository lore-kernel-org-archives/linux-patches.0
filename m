Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131021DF726;
	Wed,  6 Nov 2024 12:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895751; cv=none; b=LzX0DOr68BOTN7U0w7vERO/GQDJPgTq+u8OnSwBAOIh/e5UKQIhpdEWpkdZZiY3iIH/rnlFQPLGN6jJRohsp8cwtjZkvwJdA9NPdQ1/RyNDeVie5ctQ06zDgnxX0BrR79A2Hhlb9FV0oSVft94uE7cNpn+f9pVGq7Q5QTOGVc20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895751; c=relaxed/simple;
	bh=DRFdhs9eB6eIA17lPQc7a5wnBbLBLkInBxCjbUOmXnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YngNekR5A9rD5CLXSCQiCKWShq8zJYAcybANOJW1mI/ho8ehZuxhka/UMjEp8pqmF4SS0+V0GKrt0gS0k3q7gYSIt5A3BEOIuFQqtWvcISsbVUGJoCfodAt5rIcAG0zchwA5CXrief8wtyHYqk7nvIiJo2nHbVAHbu06q7SwC3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzI2+SND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzI2+SND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85448C4CECD;
	Wed,  6 Nov 2024 12:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895750;
	bh=DRFdhs9eB6eIA17lPQc7a5wnBbLBLkInBxCjbUOmXnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzI2+SNDShaUEqr4wmHLWThFdV/tQw6ZGRYA4Wo7lfnRaYCxXm0g3iqZQeVYeCZZw
	 VwJzSUktMSbVH8skZsWbVcUdOoxCWc63vzAE9L0KM+i6e6KpmvQ2o9Knsn1db8s9pp
	 F59IiAkhMxWVvzFb5LKFYekSkdv4Rq3ecvlCDpvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc39f136925517aed571@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Antony Antony <antony.antony@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 322/350] xfrm: validate new SAs prefixlen using SA family when sel.family is unset
Date: Wed,  6 Nov 2024 13:04:10 +0100
Message-ID: <20241106120328.699864824@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 3f0ab59e6537c6a8f9e1b355b48f9c05a76e8563 ]

This expands the validation introduced in commit 07bf7908950a ("xfrm:
Validate address prefix lengths in the xfrm selector.")

syzbot created an SA with
    usersa.sel.family = AF_UNSPEC
    usersa.sel.prefixlen_s = 128
    usersa.family = AF_INET

Because of the AF_UNSPEC selector, verify_newsa_info doesn't put
limits on prefixlen_{s,d}. But then copy_from_user_state sets
x->sel.family to usersa.family (AF_INET). Do the same conversion in
verify_newsa_info before validating prefixlen_{s,d}, since that's how
prefixlen is going to be used later on.

Reported-by: syzbot+cc39f136925517aed571@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 5892ff68d1680..8146ef538ab3d 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -148,6 +148,7 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 			     struct nlattr **attrs)
 {
 	int err;
+	u16 family = p->sel.family;
 
 	err = -EINVAL;
 	switch (p->family) {
@@ -166,7 +167,10 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		goto out;
 	}
 
-	switch (p->sel.family) {
+	if (!family && !(p->flags & XFRM_STATE_AF_UNSPEC))
+		family = p->family;
+
+	switch (family) {
 	case AF_UNSPEC:
 		break;
 
-- 
2.43.0



