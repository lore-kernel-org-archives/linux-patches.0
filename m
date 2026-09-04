Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A2440F754;
	Fri,  4 Sep 2026 05:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498653; cv=none; b=Vr1Sz+FdxEpZlGnrqXXf0HgGuVWNNg8nnwlGRzuadiPsciWLFapHR5pLUP/A3uufWtuOy8uwIgOPBY7fEHL/kj7TutQTsCl51YDts14d/TJUTs1oeMLSEpruVmaw9rnJms+Hm2o9OKS1qDBfbrZRH5JkukKQT2dF8DbA/Ok2pjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498653; c=relaxed/simple;
	bh=3tIcoKFHzmYROWmC1P7prd4Dk0mrgQCPrBvBmRy/PDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deBe4xH8TBWnbQQY8l5ipJgBSVTIQRyMVLevf6Hh5cjdnH66+zTG3D8aGiv/ymgLHJHB0no3HSO7p+lw1iguBIyAcrSL2vfppJNIMa3dqwBVFIVcJQlcw5G0rslIOz0pHvEsPrH2pb6+PVdSiHimBpns9OnFtKLnv9LxedQD2LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/mZPKtr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/mZPKtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B241F00A3F;
	Fri,  4 Sep 2026 05:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498652;
	bh=/yTp5+EiTq4FNCAZXrSriT5eZQ0zPeNHjQxfiAlFJjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y/mZPKtrxbHpeePkoEoMtYV+BjYrDiFChixRN/gRLBbzMZvQwXHkX4r9Ezt1Ws4oo
	 IiArKqq+NR6G2VOoLHiFbaAratcKKFof8oxeIqPrAnCSyRbcRKbYK4YrP3Q91TYpYG
	 /uuK6+7pu11Krr3EhPQl6NATK6+aiz6zqe61BvDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 140/713] NFSD: Fix off-by-one in DRC bucket pruning limit
Date: Fri,  4 Sep 2026 06:51:48 +0200
Message-ID: <20260904045806.966817715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit d0728723c80dcb3432effd67c7e919b596004b1d upstream.

nfsd_prune_bucket_locked() evicts an entry before checking
the freed count against @max. The check uses "++freed > max",
which does not break until freed exceeds max, resulting in
max + 1 evictions. Use ">=" so the limit stated in the
function comment is honored.

Fixes: a9507f6af145 ("NFSD: Replace nfsd_prune_bucket()")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Link: https://patch.msgid.link/20260717001232.438792-2-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfscache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -275,7 +275,7 @@ nfsd_prune_bucket_locked(struct nfsd_net
 		nfsd_cacherep_unlink_locked(nn, b, rp);
 		list_add(&rp->c_lru, dispose);
 
-		if (max && ++freed > max)
+		if (max && ++freed >= max)
 			break;
 	}
 }


