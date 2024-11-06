Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514771DF736;
	Wed,  6 Nov 2024 12:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895842; cv=none; b=UkwuF/oZQwOq6A3z+W258mQGMFnt9gPZg2bNu3ekVRWTAHr+z3uUOLnyJzPufHgV2o+s+vpNgnUM/wqblM4RKiLh+LEKt1YfZTdahmtdfQFeeCtmm4IBtw8Cn5wPuzsdSqN5HGJWRxxnbtEoQcbt7z4ACYzGsph3unrtRU9+dmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895842; c=relaxed/simple;
	bh=/JKGTXHiBnKx4O2bZ3qPTE4/yKD//2czpkD2OPtGiYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkeFdSeg4v87X/nDaUWre2uhsvFIFx9nd0Un+AWd5zPZK0a5iPy/twXlIdM2LNhT5l48qr3u1CXofth8BuLBkNd4Vgeh0DRbJ/QyebeYTvnyUHTCGrwOadUeQ5oEUsI7RB/TskQcy4KeOoTYaT3+JyfmF7CSJkiHMuvIWBERrl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSU/WCBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSU/WCBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A169C4CECD;
	Wed,  6 Nov 2024 12:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895841;
	bh=/JKGTXHiBnKx4O2bZ3qPTE4/yKD//2czpkD2OPtGiYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSU/WCBt5K3eXkFZLf5pLVeYIGRxyWDrDc4UlODQfuGj6V3KlN8+r9ENwCSYzeOTi
	 +XnMX83ADoWezO1GafZ7jwnGpNZMkhYv/MIGmzCUH7CkO2w3j9dham3XCWv2jE4aIk
	 6q8NC+IFFXrkxicYkkGLn6Iv/IbxzYLwGj4QHGsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Simon Horman <simon.horman@netronome.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 329/350] gtp: simplify error handling code in gtp_encap_enable()
Date: Wed,  6 Nov 2024 13:04:17 +0100
Message-ID: <20241106120328.851876268@linuxfoundation.org>
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
index 733cafb0888f6..8ad324ef99a2b 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -865,8 +865,7 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
 
 		sk1u = gtp_encap_enable_socket(fd1, UDP_ENCAP_GTP1U, gtp);
 		if (IS_ERR(sk1u)) {
-			if (sk0)
-				gtp_encap_disable_sock(sk0);
+			gtp_encap_disable_sock(sk0);
 			return PTR_ERR(sk1u);
 		}
 	}
@@ -874,10 +873,8 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
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



