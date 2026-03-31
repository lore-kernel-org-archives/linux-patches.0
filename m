Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D91F3F7887;
	Tue, 31 Mar 2026 16:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974879; cv=none; b=tanxml21zt/UdKB5P6PQoeJFypSRxIxi+fxV8Nrt0aeqPTR1/dkKXbAVa1Zy9FtLIV0cwEAvntNnGDOxjWH3YB3MwLv0eaplmW03J0LNRIWs2bKtIn7zhacZ4+f9+d7mp/K7eT0bdRacuyDnC+rq0oL8naoNIz2bZysAdGh1UK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974879; c=relaxed/simple;
	bh=NdiY8vZb0O4eOTsWesjSilOXbHhP3V+EtcPKwGT10MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmRo073H8WUstaWKenvm47UDTSdPxTE4SkidZKI4fYPO7OmLQ0zzUSeIk4KWkGflJ1AXeE9M0E0iSHMsMfNq2k41ZwphGg6cEYKi8iBZvSbvC18K2RxfV1XCfEDtDkpfto5aPb1kxzEb3Vzf2nvgxU82u53mFEGDvpy5X/qZtFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8Mi0Hmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8Mi0Hmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CA7C19423;
	Tue, 31 Mar 2026 16:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974879;
	bh=NdiY8vZb0O4eOTsWesjSilOXbHhP3V+EtcPKwGT10MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8Mi0Hmh7e3ZETpHZiH4RZV/j+CebA4h+by1qxVDykGQeNbp38R8zcy0W6lZ9k3hC
	 wV9HT2UeSlfwaixwlYvDaUqydwSwbTswd48Tdvq7F9kdVShIU2H+M8kq7R1kTwwiY6
	 2qC1wAtS55jzejf4ONsmWLoGEO4gRdMRLb4UO2rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 079/342] xfrm: fix the condition on x->pcpu_num in xfrm_sa_len
Date: Tue, 31 Mar 2026 18:18:32 +0200
Message-ID: <20260331161801.797378487@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



