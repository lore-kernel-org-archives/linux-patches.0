Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C915636655D;
	Wed, 21 Jan 2026 18:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019940; cv=none; b=RCxFM9VuTrt6D5wXl7SqH+trNaUak2jkq+mTMHjj8QwqGxdxwpiFJhdFVGzmgC56RhOVrq6cOPsoP/nnclaCJBDAOlUpQeaRxhZkHsKcGwYI4iAzohnHzQbuSEgFShF1EgnQdsTpxHc5QZ5LjL8Y3jhAcXKldBxvesV2KHuGg68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019940; c=relaxed/simple;
	bh=ybdyyTlbSyUOcuopTcW3CxkWsMT4YUcezz59gCRAHbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JA7cQQiKeqQOJPf3g9Mupqam0eGHGhpmriiDxh7TvmvqT6ywLDU6n22VZGauZwK1C/OZQUdd7/3+7Wu1sN3l0nZDUFBbMx1klFAHGR3M6vPHtRa9dKH39gLhQuZJ6jSlUL5dL4yUSqDBRj7dt/yoIsiLKU+La83ippzJW8eJ3VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qfi20CIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qfi20CIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E22C4CEF1;
	Wed, 21 Jan 2026 18:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019940;
	bh=ybdyyTlbSyUOcuopTcW3CxkWsMT4YUcezz59gCRAHbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qfi20CIKmxtCuIdxiGNiaQcmfShfVxuRduOGgOYK2JF+yM2bP6eskPloEGZ5adFCC
	 dQKXiscRYmn31gdYgOaC9ZRzAZuNRLJ5j4F6j1J1WLYYjyfMDq8pkbZR3k0efFtHXj
	 Q8QFbe/xV90ih/xDMMSyUJJr71fxhrsJWURxdL/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antony Antony <antony.antony@secunet.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 013/198] xfrm: set ipv4 no_pmtu_disc flag only on output sa when direction is set
Date: Wed, 21 Jan 2026 19:14:01 +0100
Message-ID: <20260121181419.025386439@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit c196def07bbc6e8306d7a274433913444b0db20a ]

The XFRM_STATE_NOPMTUDISC flag is only meaningful for output SAs, but
it was being applied regardless of the SA direction when the sysctl
ip_no_pmtu_disc is enabled. This can unintentionally affect input SAs.

Limit setting XFRM_STATE_NOPMTUDISC to output SAs when the SA direction
is configured.

Closes: https://github.com/strongswan/strongswan/issues/2946
Fixes: a4a87fa4e96c ("xfrm: Add Direction to the SA in or out")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 9e14e453b55cc..98b362d518363 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -3151,6 +3151,7 @@ int __xfrm_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 	int err;
 
 	if (family == AF_INET &&
+	    (!x->dir || x->dir == XFRM_SA_DIR_OUT) &&
 	    READ_ONCE(xs_net(x)->ipv4.sysctl_ip_no_pmtu_disc))
 		x->props.flags |= XFRM_STATE_NOPMTUDISC;
 
-- 
2.51.0



