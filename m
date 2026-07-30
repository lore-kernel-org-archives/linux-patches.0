Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B617143C7C5;
	Thu, 30 Jul 2026 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424082; cv=none; b=IbOb48a4x5avmi+bUxlief+jOkqrxh+ByD+CB4oaHxpQkZ2x8HVmUNxPruJOu1alDqpouj24uJTJNyzUkh4BCVrM5t3B5Yz8uyX15JQs2gnxh5BJPsOxjCYBmkaVer51wTJ4e6UF6ZUFw0wASI7JQlIDg8aJPIMpnChk1p0wiEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424082; c=relaxed/simple;
	bh=4D4O3aJ13ajsi/h3zR1ibcBSm+Uj99mrQofiWsOItAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTepjYpvVbqQ6/i/9BM7qWzph7cPPtkws97v858lBlLMo4LYmmvbY/9l7U/rnBWjHrcEVefl0EGdTXupWXoaueyPgCbnI/PzwXq0s1izvEZd051jtaypIBcbnI3mkWlw6T/OXvEdrnLDXggmIrVLOJoEa4HF+d3Mpah6KMQllzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZ+EgfLf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZ+EgfLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182F41F000E9;
	Thu, 30 Jul 2026 15:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424081;
	bh=/f/DOjxMuyepYLX1D+y2vU9GIlB/pdRZCQc1GiHrg2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZ+EgfLf33X6j4KNg6hcht52dJQ9WRU7m0qC3x4rK2DDaL4p+DeCrSrmidiZmpcxs
	 hkZsWQDVdGdPu6NU8+g5Fm8oxijfmb7t0p4F2KfRJsjezmpI5A2rt4BTEKN0QHSNIu
	 O3BSwwP7Ve26TbrMFoU4sJ9NK2zxBYnu0a43ybNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 225/675] nfp: Check resource mutex allocation
Date: Thu, 30 Jul 2026 16:09:15 +0200
Message-ID: <20260730141449.924095558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit a61b4db34a753bdf5c9e77a7f3d3dddd41dcfacc ]

nfp_cpp_resource_find() allocates a CPP mutex handle for the matching
resource-table entry and then reports success.  nfp_resource_try_acquire()
immediately passes that handle to nfp_cpp_mutex_trylock().

However, nfp_cpp_mutex_alloc() returns NULL on failure.  If that happens
for a matching table entry, the resource lookup still returns success and
the following trylock dereferences a NULL mutex pointer while opening the
resource.

nfp_resource_acquire() already treats failure to allocate the table mutex
as -ENOMEM.  Do the same for the resource mutex and fail the lookup before
publishing the rest of the resource handle.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: f01a2161577d ("nfp: add support for resources")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260708143408.3168425-1-ruoyuw560@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c
index 279ea0b5695577..55525f45e447b7 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.c
@@ -96,6 +96,9 @@ static int nfp_cpp_resource_find(struct nfp_cpp *cpp, struct nfp_resource *res)
 		res->mutex =
 			nfp_cpp_mutex_alloc(cpp,
 					    NFP_RESOURCE_TBL_TARGET, addr, key);
+		if (!res->mutex)
+			return -ENOMEM;
+
 		res->cpp_id = NFP_CPP_ID(entry.region.cpp_target,
 					 entry.region.cpp_action,
 					 entry.region.cpp_token);
-- 
2.53.0



