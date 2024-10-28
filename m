Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9BD15B10D;
	Mon, 28 Oct 2024 06:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097761; cv=none; b=rKDLeyJcyWTzUYNwiPKjAM3DbTT+cBxoydqMbOZ6hc033UYlJXyW+b0Mt/9kjLyocYE3AHMJezmLvGXj6Dabhnf4AAA4GtlLXtwqkNgIXkyu+8l9GJnJix1NpvipEZlJeaxewCXqVQxmrmRAE8tIq/KQBm2JTz158ippEDnVJ8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097761; c=relaxed/simple;
	bh=OBO6Y+axA7OLHasVgrRtBlJGMdN/HfSt1Yki2AENKL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+u/KcwehsSJ7ESNr74VIJn4WxRJfPcKEgeaCYUWmuG/ntUhEzBiyL6qv9I75aSKGsZGc4Z/O3PGQEoT1o2Jr/RFMlqci++4GoEcnRFKfExGtnmWJAVpDDHMBxa3VDB5KecytRDrKkr6cDeSdoDudZCYtJRIICKPffai0+Ijo1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnCNnUlI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnCNnUlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDE2C4CEC3;
	Mon, 28 Oct 2024 06:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097761;
	bh=OBO6Y+axA7OLHasVgrRtBlJGMdN/HfSt1Yki2AENKL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnCNnUlIbQ++KZE9bBUADZMGHFGJUGfIz1ptBPYsItR7KLQE6VutwO3VYdsA1RKKE
	 rriOH/OLALm6Po8TUWEAHdthoILQqJzbPLDKN5AuxxPChP5p+F5n2PKQcNagJCND5D
	 7SpXGJ+2+8Zpkhdd3U4B/c+0HUBWCjIPZtjzN7jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cc39f136925517aed571@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/208] xfrm: validate new SAs prefixlen using SA family when sel.family is unset
Date: Mon, 28 Oct 2024 07:25:14 +0100
Message-ID: <20241028062309.939580777@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 4328e81ea6a31..12e9d0e703e70 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -201,6 +201,7 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 {
 	int err;
 	u8 sa_dir = attrs[XFRMA_SA_DIR] ? nla_get_u8(attrs[XFRMA_SA_DIR]) : 0;
+	u16 family = p->sel.family;
 
 	err = -EINVAL;
 	switch (p->family) {
@@ -221,7 +222,10 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
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



