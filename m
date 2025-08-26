Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10DB21D3F2;
	Tue, 26 Aug 2025 14:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219476; cv=none; b=WF+2OKKtbRftHBee6G3vTjZ4lD9fKa7FfwAKKCfRK73cSnOHfvL6UnzfQS+77PlfKW4SkdlXTfr4ZLFvL2q5ABfHgTVmMxTAY3lBch286VafnEct4q7+qfrG74Y8eydu2O5RkcNjMoN6QnmU8bmhDBQaBWbhIIuMevk1b2EPVdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219476; c=relaxed/simple;
	bh=eyqovNf07p7/QFH0p8JwN+VRi1uqbgad82i6az6Bz28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yv0Kf6Aw3KsrHJxmNE++E/c2eRwVAVogamTRE7oSCe3QuGKrUuxwZvPgd/YIPK5WycxsQJn7xOLYmrPsi6Ygxkxf8KHY4L4fXwcElFZvX6KV5h/4O+YMzg8UYWgEaXtjiq0RfR+ZqAjKEaqBLlHmJ+s8bURDOd9GGa2o8sjTh0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0HU1/Kz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0HU1/Kz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE06C4CEF1;
	Tue, 26 Aug 2025 14:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219476;
	bh=eyqovNf07p7/QFH0p8JwN+VRi1uqbgad82i6az6Bz28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0HU1/Kz8YLUaT317HxlYbXnSLZyXsUAXwAIKe7NLzkyvE9v4Ul4Yg8nLwLew7HDzy
	 huEUO/aQ/y0dxMpTP0Hor46hfRSuKdnTgqFabM01PRwhSofpGuCAP0Q8jiCnNKfkt1
	 lvhwAbUFw3N8HRAYw0x05Eqo5wW9oRTkzWha2pHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 397/403] ipv6: sr: validate HMAC algorithm ID in seg6_hmac_info_add
Date: Tue, 26 Aug 2025 13:12:03 +0200
Message-ID: <20250826110918.001856718@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b3b2aa92e60d..292a36576115 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -295,6 +295,9 @@ int seg6_hmac_info_add(struct net *net, u32 key, struct seg6_hmac_info *hinfo)
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
 	int err;
 
+	if (!__hmac_get_algo(hinfo->alg_id))
+		return -EINVAL;
+
 	err = rhashtable_lookup_insert_fast(&sdata->hmac_infos, &hinfo->node,
 					    rht_params);
 
-- 
2.50.1



