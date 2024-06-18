Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3029E13D291;
	Tue, 18 Jun 2024 13:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716529; cv=none; b=eekSjk5NxICpYiu6JTQjcac/F9gRGfHn+rO1cO8oZ7Ul0xRjF6GwnCOylKSNANi/OdPlAkawsPlh5abFTynrDJVhxzEXNJU2Zn0vHkkw9PXQzB2H2D9n1FcLwKCRl2BNW24HWMlhQERoH+/Uz3IAuWaizi5djC3FCilxZUnL/I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716529; c=relaxed/simple;
	bh=I13VeKCTBVQefNStAuFI6P1663quTNRI+x1HdjdCUTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8xnJrOL5zzIsF4hdVA68Yvt2Yu3ES5H0R7TvAWcW/08UJ8V+sdwIrAesZyyJ81O115yuwxf3M+OHxhgHD2UbBrKiCDG7IGwemcy76paPY4HiuYzj9qWuyBKl9yloPLMCTTTjnVnv51xR0VKujIDFuGACJ48w+dYezDIi7ku8eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOJczXFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOJczXFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF71C3277B;
	Tue, 18 Jun 2024 13:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716528;
	bh=I13VeKCTBVQefNStAuFI6P1663quTNRI+x1HdjdCUTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOJczXFi4xyDnMcqMpAw6AUaVHBfwHViEyVUsdNkGeqNm4CttTGLsXbvPsRQwjln7
	 VsmX6BHL7lExFWloIW/a8Gi7RpswUaItqPTDTwQ1qUb7eAZgCuCOlwJATl3RCXGiH6
	 JaHQso7oblOTUTGps/mfoizjpuP5OMvbXtmME0hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 675/770] nfsd: fix net-namespace logic in __nfsd_file_cache_purge
Date: Tue, 18 Jun 2024 14:38:48 +0200
Message-ID: <20240618123433.334693415@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit d3aefd2b29ff5ffdeb5c06a7d3191a027a18cdb8 ]

If the namespace doesn't match the one in "net", then we'll continue,
but that doesn't cause another rhashtable_walk_next call, so it will
loop infinitely.

Fixes: ce502f81ba88 ("NFSD: Convert the filecache to use rhashtable")
Reported-by: Petr Vorel <pvorel@suse.cz>
Link: https://lore.kernel.org/ltp/Y1%2FP8gDAcWC%2F+VR3@pevik/
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 0b19eb015c6c8..024adcbe67e95 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -892,9 +892,8 @@ __nfsd_file_cache_purge(struct net *net)
 
 		nf = rhashtable_walk_next(&iter);
 		while (!IS_ERR_OR_NULL(nf)) {
-			if (net && nf->nf_net != net)
-				continue;
-			nfsd_file_unhash_and_dispose(nf, &dispose);
+			if (!net || nf->nf_net == net)
+				nfsd_file_unhash_and_dispose(nf, &dispose);
 			nf = rhashtable_walk_next(&iter);
 		}
 
-- 
2.43.0



