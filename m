Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDFC423A8E;
	Tue, 31 Mar 2026 16:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976375; cv=none; b=iDM0Lkh8AKCNGBYtnl7YkIOP/zfYLCwFmLoNmdl403Gyc/WCtuGk7PhRrPSfE/lIxT8QzvfHgSuzSbiSnhfMqI/aIKn5BtKJ3XDJ2GFQr9RrGTpAcf4H5EZpMEeXSLzDjc1frbf6GugFUL7zxkPlibF0tOpa6jWgWgMEWEnVu1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976375; c=relaxed/simple;
	bh=fdjnPHH1zG7mjS29kyhOhnhrmCW2J5BRQqihrNh67bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDP5bbat4RyBkrhepLCjKTg/bxfqimTpeK3tInWfifWpypKoQ3DqdoALwbqPFCO0jTVpnVLfqyybfCt2t6MxMEGGhrQPAe0WE0gUJr/woiI4l0vsHP3Kt1PiESltZKbdIL2XcEulZqbISflvUTp4nKJXUkgwsDFPZuCjsz6Lg74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4KjE06B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4KjE06B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABF8C19423;
	Tue, 31 Mar 2026 16:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976375;
	bh=fdjnPHH1zG7mjS29kyhOhnhrmCW2J5BRQqihrNh67bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4KjE06B3P+++OUo5WEmxDpKzh5L+LMwW+nQZZXKF/+8H/04gbJPXoE5shzTHI7gu
	 FJR5dCJ7SB/40gsd77MHrwlFq0GEUOg5Pl0SgUatVsTBXsNdGgvBlfY1Y9ZturBFJv
	 JY8N02t+V/nfRggEbAHdsB/4/lBpM0uGEKtEprdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/309] xfrm: fix the condition on x->pcpu_num in xfrm_sa_len
Date: Tue, 31 Mar 2026 18:19:32 +0200
Message-ID: <20260331161756.027707069@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit b57defcf8f109da5ba9cf59b2a736606faf3d846 ]

pcpu_num = 0 is a valid value. The marker for "unset pcpu_num" which
makes copy_to_user_state_extra not add the XFRMA_SA_PCPU attribute is
UINT_MAX.

Fixes: 1ddf9916ac09 ("xfrm: Add support for per cpu xfrm state handling.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 3e6477c6082e7..4dd8341225bce 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3676,7 +3676,7 @@ static inline unsigned int xfrm_sa_len(struct xfrm_state *x)
 	}
 	if (x->if_id)
 		l += nla_total_size(sizeof(x->if_id));
-	if (x->pcpu_num)
+	if (x->pcpu_num != UINT_MAX)
 		l += nla_total_size(sizeof(x->pcpu_num));
 
 	/* Must count x->lastused as it may become non-zero behind our back. */
-- 
2.51.0



