Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4861CC14B;
	Wed,  6 Nov 2024 13:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899020; cv=none; b=bYKsw52HLPy5KJPXNTRy0/SEU2JTysXy1mhfJTomvi+ocOetWayWua0UZDCLQ79L1dJqNqdwhe0+bqYz5d54MM8pUrvREojDwmrtZ4U3AOTcBrEPDbs7saK6URzNtbYN+y2DE5kP5nTwPoJg2ZyhaMA0h3T0AjwotA2H/hMo+CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899020; c=relaxed/simple;
	bh=8hxezi0RpsByraFbw4XEwnDiMYni2kei4MC/HA9LAbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNyGxX7o/xnUuPA59R5c2WaIP3YtHt9peQ6HICedx1DR0+uy6j7JbmAvwvNTAb/yM4pQCYI/Hk2UZWnSarvFHiMBlyFU4UgZeocciWFjRvqS7r/FNgxrabk9CZf95l+Ff4hGJNGkYgBf2QgruDtiLOf0B8YOM5cV+VKx/1ZI3ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQauCe9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQauCe9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FADBC4CECD;
	Wed,  6 Nov 2024 13:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899020;
	bh=8hxezi0RpsByraFbw4XEwnDiMYni2kei4MC/HA9LAbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQauCe9HAqUJSf+UvbcBATX5N/Yg2252/LEYk/tisJEGeVjasVjWLa7YOMngAby3E
	 DFpC7ksy3smUJ9hU8uc7ijTjzfr0jTMxkPjcoB6Ab2WvTRkYv/nBQf3buqwsPofKC3
	 N+MHztmBhP7x5wupssfUFGsPbFxQlKeyC+naeLAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Simon Horman <simon.horman@netronome.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 435/462] gtp: simplify error handling code in gtp_encap_enable()
Date: Wed,  6 Nov 2024 13:05:28 +0100
Message-ID: <20241106120342.249040165@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b289ba5e07105548b8219695e5443d807a825eb8 ]

'gtp_encap_disable_sock(sk)' handles the case where sk is NULL, so there
is no need to test it before calling the function.

This saves a few line of code.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7515e37bce5c ("gtp: allow -1 to be specified as file description from userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index c868f4ffa240f..9c62bc277ae86 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -860,8 +860,7 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
 
 		sk1u = gtp_encap_enable_socket(fd1, UDP_ENCAP_GTP1U, gtp);
 		if (IS_ERR(sk1u)) {
-			if (sk0)
-				gtp_encap_disable_sock(sk0);
+			gtp_encap_disable_sock(sk0);
 			return PTR_ERR(sk1u);
 		}
 	}
@@ -869,10 +868,8 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
 	if (data[IFLA_GTP_ROLE]) {
 		role = nla_get_u32(data[IFLA_GTP_ROLE]);
 		if (role > GTP_ROLE_SGSN) {
-			if (sk0)
-				gtp_encap_disable_sock(sk0);
-			if (sk1u)
-				gtp_encap_disable_sock(sk1u);
+			gtp_encap_disable_sock(sk0);
+			gtp_encap_disable_sock(sk1u);
 			return -EINVAL;
 		}
 	}
-- 
2.43.0



