Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AC83AAF76;
	Mon, 17 Aug 2026 14:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975577; cv=none; b=DBXVeA7Rp3fx4MF3rhHdsDODDpQOCQSvxljor5vRMjlkO/DLl/LpIy4ki4FGzEnodSnACM4pEdlOFhiNXsINcgX538G6dqK66coeYO9dct6g2J4sM3ISGTU56rbTE4nTGUA4QMCa8OGjlQ79B+yUpB/pAWtbgcfsi6LxZEiaUhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975577; c=relaxed/simple;
	bh=ovWeTrDCfcGt51KgqKq4f4+tokiOV9B2ap0SOk7uOEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQPYJ0b1hz36f+kButAK9cJNikYXsG25RkMbX+VrJlU7/d/UKsQNnW6tnFK7S3VRvkBH87TGPjHMPX6Ebft0mng/BbSRCuE47eqobPQ89gw3m/vc2k7nF3xkHyGQjIsdz78x71N+OAa5ojqAY+UBWwGkhRLTA4InYryGxKn3GSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbFD60JW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbFD60JW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA161F000E9;
	Mon, 17 Aug 2026 14:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975575;
	bh=hyG1haz4V/FXrvXkA0MoN9v2YqrYPKPNVmB9Ur8w714=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CbFD60JWYsPogGd2OfZzLUKCh/7GZC4RrlqxVJpbhEpYzFU5HvuAcgte3Ezh3iONd
	 NxEtKz1l0r/0LO0/ruCgpbopZULyiPrhrn68rTXcDWNEPwx/GvUE0p1omEYSr+GPdB
	 zckHhgekjNpls2hV5Jox9n37GjseP7vmRcM+4OGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/389] nfp: Check resource mutex allocation
Date: Mon, 17 Aug 2026 15:28:35 +0200
Message-ID: <20260817132542.065595944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



