Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B59228135D;
	Thu, 27 Nov 2025 15:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255690; cv=none; b=LOj1z98vmCZt4J0EL3dtLXzPwBudJNuLhSoXmVuJzq3JEgeLyGjX5vl4dHj+nNtfRdWHU3i4y/M3o2uKjlretZkjKTH3j098uOjRp2IXPz7VRZQPOI0sf09X7gVDverRRYPJFh9ATjUi6bsZhbrpxa85BjjPTXcyy5hYc+Buvi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255690; c=relaxed/simple;
	bh=R34ry8XHla/hnNZtrLnHsQTVHsGAWwsG7CPLOq3YoB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mE4bR8+3jGuW5SWrPa+BPX39AIqVDvhDl/R4FPFYc44JpnuiTtjB+aHVCTKBxD8kPSGvzFI7xG0Q4FiGQPoZ3PNxbx95srtgcs3fuk9P1ZzX413ViQI26FAZ0+GZO6cUh+qMaXYYnLSqKiYqiGxV+1L5LuRk36qSSFeLXV64tDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLO7EIxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLO7EIxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50E4C4CEF8;
	Thu, 27 Nov 2025 15:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255690;
	bh=R34ry8XHla/hnNZtrLnHsQTVHsGAWwsG7CPLOq3YoB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLO7EIxdrHE7ZpkQ/k02rSi6DYJtfPbnWgxwpKRXwMUg5M34t0D9eM/wP1/KKDdu6
	 +UIvojx8Wo8r1k5cx7pmgmNJKcPh4BWKsRav1nB2NHHiD0pIBlVo4s23f5ZCScRiv2
	 z1hSg9YMVtjILxozVHhN6TIpmFqV5FaSSBt7532Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 080/175] xfrm: drop SA reference in xfrm_state_update if dir doesnt match
Date: Thu, 27 Nov 2025 15:45:33 +0100
Message-ID: <20251127144045.888691329@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 8d2a2a49c30f67a480fa9ed25e08436a446f057e ]

We're not updating x1, but we still need to put() it.

Fixes: a4a87fa4e96c ("xfrm: Add Direction to the SA in or out")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index d213ca3653a8f..e4736d1ebb443 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2191,14 +2191,18 @@ int xfrm_state_update(struct xfrm_state *x)
 	}
 
 	if (x1->km.state == XFRM_STATE_ACQ) {
-		if (x->dir && x1->dir != x->dir)
+		if (x->dir && x1->dir != x->dir) {
+			to_put = x1;
 			goto out;
+		}
 
 		__xfrm_state_insert(x);
 		x = NULL;
 	} else {
-		if (x1->dir != x->dir)
+		if (x1->dir != x->dir) {
+			to_put = x1;
 			goto out;
+		}
 	}
 	err = 0;
 
-- 
2.51.0



