Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175E9364038;
	Sat, 12 Sep 2026 09:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205571; cv=none; b=UtcczoHKF3KBQAVa1Mr6FG01FrLa6Ss5r9LvB29EvLf3NqqdSLNaWXD81L5UCY0jXu6t9MqWrAJK5FUpGZbkLKYvf9BfMNn+wcgoTumJWvxNplrgDq05xXMJLQDlbLJAp4f+RE2PtpbLM3isR5bPPsfHm76X30mAPoG/CJ8Z/RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205571; c=relaxed/simple;
	bh=QvY+NGHqOAuaYC5AC3uIKOvhVDBROPK+GX0DPKnX87E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjzKYAOFwVfss+Nz3WAfZak2xryr7R5ihDVrMv4elCvAzA26c9AxKT+bLj3gMc4ZrBuSwowcpt2ykfXAoimdIEKzvsTyNoTHnMzyC/cWATV2RmvRqWFybVYL0+Aaj5Z72Sk4GJ+yxo/sM48Vp/7Qv4yvUItiU6+GL+YZHHVTsxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocIjCSod; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocIjCSod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE981F000FF;
	Sat, 12 Sep 2026 09:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205569;
	bh=G+DP/GP8mY/sZ0T6Xaibk3Q9Sn6bm+27hbmODyCBXhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocIjCSodAfjUmUSdIVSFgdrzkZ6sSyDmO3D+BjMakcRPb/TsaCcXm0F0FMiJ3qVSJ
	 em9jfLYg61o24pETavpnBV/Cci8uvfr7V2KBJQpMVvwqWSoeWR2Jfa4czaNCUAF7ef
	 vzBny3gQ5VaRS94HkDmHm4jSm4t2dnWnRzqOsHq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Li Chen <me@linux.beauty>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0029/1518] nvdimm: preserve flush callback -ENOMEM
Date: Sat, 12 Sep 2026 08:36:38 +0200
Message-ID: <20260912065624.082976307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Li Chen <me@linux.beauty>

[ Upstream commit 6b7108712a4b1c37cac69815aede1dde202b3187 ]

nvdimm_flush() maps provider flush failures to -EIO. Keep that default
because provider callbacks can report host-side or backend failures that
should remain generic I/O errors to the guest.

Guest-side allocation failures should not be reported as I/O errors. In the
virtio-pmem path, the flush request allocation can fail with -ENOMEM before
any request is submitted to the host. Mapping that to -EIO makes resource
pressure look like media failure.

Preserve -ENOMEM from provider callbacks and continue to map other non-zero
provider failures to -EIO. The generic flush path still returns 0, and
pmem_submit_bio() already converts errno values to block status for bio
completion.

Suggested-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Li Chen <me@linux.beauty>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260630092338.2094628-2-me@linux.beauty>
Stable-dep-of: e57140944b5a ("nvdimm: virtio_pmem: refcount requests for token lifetime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/region_devs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1094,7 +1094,8 @@ int nvdimm_flush(struct nd_region *nd_re
 	if (!nd_region->flush)
 		rc = generic_nvdimm_flush(nd_region);
 	else {
-		if (nd_region->flush(nd_region, bio))
+		rc = nd_region->flush(nd_region, bio);
+		if (rc && rc != -ENOMEM)
 			rc = -EIO;
 	}
 


