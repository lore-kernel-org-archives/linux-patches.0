Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74903A641D;
	Thu, 30 Jul 2026 15:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425764; cv=none; b=GuPnIEeS4d1+M3OYEsgF4KIdZ8O7qNL0OMI5Fhg8EADmkBGD+lpxRf/pCAvF8oTkcJmEDwKRHOCUCPeO7qksrNMwKJcwmAN5KoWKxjHH+fug2U1OB3mSkq/OMjIFSXAsRjjrJmHnro2x9+pVajcwRc3EWTdLQQs6qGMRQ/wGBmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425764; c=relaxed/simple;
	bh=YzNn+GXbaoQMiwJ1saHMDgsf+UA9Ia8K3cQSzPeCFMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrNeSY7gBhBozN4XD25TUw3abWeKrMeuko5Q89HSXz99OqhK6DhpCbaPbNfogAEWx0Pypw04IVFTbHK1BeYrJk4rY22myC8eFVNfdgMyoE6IYBkmcUiSkAOlVEWy4n7ZKygvqId7Fb+0KSIUDz2jmKPEa5FFpjquU5Qeo5w8BHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9x/0UFn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9x/0UFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1511F000E9;
	Thu, 30 Jul 2026 15:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425763;
	bh=57s0MTrdz59n8RNgWOL3TPlXzPj7fTAvDNf5MaKykoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9x/0UFnq5lxNnW1cZLqHyOQNp6407coMID2tGWKZX/ahhzGSg9EgSCuBNpizuIS6
	 rBpSc2Jrn+0KhvmekKMMy++EWH2bgp/uCoDzl2k0ycq9JpzZfgUd5xKsHt90C7Ao0J
	 eUqkWPXrpamymSGcKvNpCPNM3a1zWowsITGQr3do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/602] nfp: Check resource mutex allocation
Date: Thu, 30 Jul 2026 16:09:33 +0200
Message-ID: <20260730141439.767389408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



