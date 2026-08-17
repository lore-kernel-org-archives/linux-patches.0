Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AF52EDD78;
	Mon, 17 Aug 2026 15:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979157; cv=none; b=StJiaHc4eZ/3/LICdclzILWJCeVs2lJ2onWeskru1ymBiN2tGqLCNd4SlfDZ4yPU6aiOACfohxtua12U0VwfRAqzEuKklMAHmlD3Olcx6VFCkG2bfIQFyuigeoXnN8F2v6OfuMtJOW2hRDgXb1g8QCKUIM+nITEAD0D0HfeKzBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979157; c=relaxed/simple;
	bh=55YAVOIKeLQy75K8TEpfclfFgcOs+A0oVSaSIBpmwnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhlOo75YDOfdYkzEIzHvaxB8VMuKYIjGp9Ba6exqSo6KKlWQtK/1KomU+3M3pzyq1GpTQz+c7e9Ja19Np34iMgzwaswuasBhzTE/qThhTX1u0RvfOwHlBH5OQVRmlyDSYxQbZkZ7rf50CBEBWaceZz6ydjXmMvusTkwz54UtCbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEzmPoQ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEzmPoQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6081F000E9;
	Mon, 17 Aug 2026 15:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979155;
	bh=o9C7+h9pSMXfscaRkjltx0QJ64y5XVCED8RBT7QspzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SEzmPoQ1itqkBzQUd6OX8Q0Sue9a1O3xetLtGNpXoA60wnjTSA6E1SwyTFkIWfrew
	 anAoKZtLXAR4wv2JnyNlQHPCbkZ4eY+N/v2Of7v42++3nyMEVOa4v89eOUGNeeTI/v
	 /D+UPQKeAk6KljeffMtZauXLKJ6ITDbeqlKlV6yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/609] nfp: Check resource mutex allocation
Date: Mon, 17 Aug 2026 15:27:04 +0200
Message-ID: <20260817132548.149817660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ce7492a6a98fad..908d99f398b819 100644
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



