Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308DB3DC4C2;
	Tue, 21 Jul 2026 17:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654215; cv=none; b=UuWnUeJbLaUB/WXH+DTic+ERPAil9tPGQzZ0j/eLWItL///0RxvE1TiyO7RQfzEALtLKXRx3hjAeDWzyHon6RflVK4O5/vWLoNY2/EBFvMKKRv8yYy79yvb+PTTRRZP+OYlADGxasrRjZw+VtBl10T6KV3M0e/G+mrOB3YmDX/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654215; c=relaxed/simple;
	bh=k29IovyL7wMVK85XU9soFc9JJq4GIBScVIruCb1yVzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdyQ0qkgH66VboTCE6BS64dn3J/Jq7bLMtAZI4w33i0erWBai8TNhnMs8nQRVjnKJS9W9ErPX9Smws5Z24OlSig/nHVpZDFwksmtjUIbCKUz5afDF8ZNUIYhjwsbclkGfXH/W7kZn4as7tJ99WGjH+UV8sB+jxwaQqoHYaigCWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/BDqYZW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/BDqYZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F041F00A3A;
	Tue, 21 Jul 2026 17:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654214;
	bh=kDC/h9rl0aBKPy9Bn0bBekEwcg3Z8A+fOM9w551EzGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/BDqYZWtZTHVhqAW/V/JwTI29zeTJoI5Ah+OunDkp2cK3G0wCEBgb2Zqceakq4YU
	 rWGcN9HVACTa8G9lQJSFa0QzildOPUqMNAt4UB7WXF55JSECZLx9Mumz2LSx6V1a3+
	 jBrLLvSjhFI/denb8M+P/s9CnnUgSVGZvtppyRxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 1613/2077] netfilter: xt_physdev: masks are not c-strings
Date: Tue, 21 Jul 2026 17:21:26 +0200
Message-ID: <20260721152630.808029737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit f468c48d488d0ea2df3422b3e1dfafae1611e853 upstream.

... and must not be subjected to the 'nul terminated' constraint.
If the interface name is 15 characters long, the mask is 16-bytes
'0xff' (to cover for \0) and the valid device name is rejected.

Fixes: 8df772afc9d0 ("netfilter: x_physdev: reject empty or not-nul terminated device names")
Cc: stable@vger.kernel.org
Closes: https://bugs.launchpad.net/neutron/+bug/2159935
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/xt_physdev.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -130,11 +130,6 @@ static int physdev_mt_check(const struct
 		if (X(physoutdev))
 			return -ENAMETOOLONG;
 	}
-
-	if (X(in_mask))
-		return -ENAMETOOLONG;
-	if (X(out_mask))
-		return -ENAMETOOLONG;
 #undef X
 
 	if (!brnf_probed) {


