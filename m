Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182792110E;
	Tue, 27 May 2025 17:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365599; cv=none; b=eILVE5JNickqr6Amdsfow5gnmjf4+w1is7npoMDKj+X0S1BStFt4pESmeIzk32QPwd5JQUNZNULn+ByJ3bpkKvEjoE8SnvxzuSEKUSTUtJFpX6zw332clDEDqkMJdZ7O2SNDu0bPceXTmRCYGiDTTHruuF/58zKMPgyyfxns5qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365599; c=relaxed/simple;
	bh=TOv3kPrI9gAX5vKmWPiBWaWR9dambjY9kpDUx9RFoHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjyjG9NblNi6giM2KGJybBr1YQk2VAnRU4vsoj8LLfJovtHODJtrjJ4lyjYIUWdoUbPNk80BrYor/zuUJ3+Fn1QY22Y9cXxOB2dReS1EB1AphYd4BbyfRKAboyf14ogBC1QfaPLHc6PJyb4922EY+a5CJbDTpjBVWSPpWxTo3nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gosb9tr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gosb9tr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F712C4CEE9;
	Tue, 27 May 2025 17:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365599;
	bh=TOv3kPrI9gAX5vKmWPiBWaWR9dambjY9kpDUx9RFoHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gosb9tr3zYWjPu/wylfNSiPAvNbc+C6FhfleuUf63FJc9Lv/+hP4i98PxUm5jB3/w
	 iqPt+czyOubFzZHcULaqNv6EMdQhZn9YG90N/jnir9oGweVgFHWkJgTNIZE/KGtky5
	 TTxhMKLP07Xq7nszcFD+1uhHiifZ/3KGB99DmDPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 411/626] xfrm: prevent high SEQ input in non-ESN mode
Date: Tue, 27 May 2025 18:25:04 +0200
Message-ID: <20250527162501.706981125@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit e3aa43a50a6455831e3c32dabc7ece38d9cd9d05 ]

In non-ESN mode, the SEQ numbers are limited to 32 bits and seq_hi/oseq_hi
are not used. So make sure that user gets proper error message, in case
such assignment occurred.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 87013623773a2..da2a1c00ca8a6 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -178,6 +178,12 @@ static inline int verify_replay(struct xfrm_usersa_info *p,
 				       "Replay seq and seq_hi should be 0 for output SA");
 			return -EINVAL;
 		}
+		if (rs->oseq_hi && !(p->flags & XFRM_STATE_ESN)) {
+			NL_SET_ERR_MSG(
+				extack,
+				"Replay oseq_hi should be 0 in non-ESN mode for output SA");
+			return -EINVAL;
+		}
 		if (rs->bmp_len) {
 			NL_SET_ERR_MSG(extack, "Replay bmp_len should 0 for output SA");
 			return -EINVAL;
@@ -190,6 +196,12 @@ static inline int verify_replay(struct xfrm_usersa_info *p,
 				       "Replay oseq and oseq_hi should be 0 for input SA");
 			return -EINVAL;
 		}
+		if (rs->seq_hi && !(p->flags & XFRM_STATE_ESN)) {
+			NL_SET_ERR_MSG(
+				extack,
+				"Replay seq_hi should be 0 in non-ESN mode for input SA");
+			return -EINVAL;
+		}
 	}
 
 	return 0;
-- 
2.39.5



