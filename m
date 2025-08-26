Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2536733EAE1;
	Tue, 26 Aug 2025 11:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207998; cv=none; b=tvwgpENwJBb9pv4RD1N0QuoZW9aE9DYXxrddGbJucxLG7S7e9043nrsGEcZ54kT6yHWjJnH418iODNNw5PhtLD1wHlJogF97XWtishPKMHKaqxhcrGfIRoQ485m2pJ84PaJ1W0TYG78EPlhbk1T0e+aBYsAJxFgw2We1p+A78KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207998; c=relaxed/simple;
	bh=0BrNLOlDihK5ofrMcIrE9R7JKugd0XSNxkxprMwmKN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egeckB8S4Ht4ol29hIs6g8K23W2wn/bb2tDpn8Ggyw/qgo4Je7J4fsVKwitkgSwHM3vs5owvfG9diLwDfhd5P+wvBQgp+WV5gr/74YQp0gx6fTQjV2TL557QjlU0UWw0PYQV48Uo9C6W9I7jkii6R+Dw1BcDVuAAHRYjNs3Rflw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdI+9j9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdI+9j9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614A7C4CEF1;
	Tue, 26 Aug 2025 11:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207997;
	bh=0BrNLOlDihK5ofrMcIrE9R7JKugd0XSNxkxprMwmKN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdI+9j9Oq5EfFN13mWM6I5Rh62If+QaFetObckultFDmypgq+6ywkuaqIqj6ubD7O
	 3TCxCsaLmG9r7zb6pf5CxxmoWexS11X0bh/RkSd6WMGbpGv0Ci5qNxiFgPK4vUBP6V
	 I5TllRi3LQuFr+iCL0HLHlHqs4pR9ujvlNgfoIaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 399/457] ipv6: sr: validate HMAC algorithm ID in seg6_hmac_info_add
Date: Tue, 26 Aug 2025 13:11:23 +0200
Message-ID: <20250826110947.156110405@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minhong He <heminhong@kylinos.cn>

[ Upstream commit 84967deee9d9870b15bc4c3acb50f1d401807902 ]

The seg6_genl_sethmac() directly uses the algorithm ID provided by the
userspace without verifying whether it is an HMAC algorithm supported
by the system.
If an unsupported HMAC algorithm ID is configured, packets using SRv6 HMAC
will be dropped during encapsulation or decapsulation.

Fixes: 4f4853dc1c9c ("ipv6: sr: implement API to control SR HMAC structure")
Signed-off-by: Minhong He <heminhong@kylinos.cn>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250815063845.85426-1-heminhong@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_hmac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 5dae892bbc73..fd58426f222b 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -305,6 +305,9 @@ int seg6_hmac_info_add(struct net *net, u32 key, struct seg6_hmac_info *hinfo)
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
 	int err;
 
+	if (!__hmac_get_algo(hinfo->alg_id))
+		return -EINVAL;
+
 	err = rhashtable_lookup_insert_fast(&sdata->hmac_infos, &hinfo->node,
 					    rht_params);
 
-- 
2.50.1



