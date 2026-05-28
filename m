Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AF9282F17;
	Thu, 28 May 2026 20:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999595; cv=none; b=ZTiDp03/DsbWUO5TsJivFt99DbpF/JMTiljCp4mC5D7dukFq983wDXj3O6zRYywDUtvfTWuUHI7LGomS3/eu4P2TkRjBL0E+93VBrWagehV6DKaOYKynOlmQikjHN1kp9vlSH2YqSrzfZubzrX9jT2fYRIML4n8oE9BYsuondGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999595; c=relaxed/simple;
	bh=X6OESti9zL5yK6oBm8j+t+R0Rre0Y1Bzp0TVfz2t8eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kwlqq1w5zsRIpQ6QET7kcMUqHCUt9opBXK5DvFLBIwIBSnNo2CoTna+13MxRHidaSLpB52Q4G2oabHGp6LggvvBG4emgxR9heBZ8p7USu5CNrQNssWRFmtSyf0p9PAViWP4cYRm12g53oSX8q+WG1hC43bbowIutrLeOqiQa/S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14AJLWBF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14AJLWBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971CE1F000E9;
	Thu, 28 May 2026 20:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999594;
	bh=MR++RK1ghOyr8eGJW/DjraIMsejNYB2ezXLc/kO7AHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14AJLWBFx/d0HTsHz2kR5BfV+kkWGfLYCjkzlKX34JQxWWc9//sIXdlXrAxtn7V5X
	 ToxnwgqJ3OJCzn4UN/OwF9hxzWOc1onmKLXgcAN7F4j2BACbPrgnnKWCSWrgKnxVum
	 A3JOS5wA73J3pwh8y1JWZwmMuK1q9uWzOfcoGQwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heechan Kang <gganji11@naver.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 123/377] fwctl: pds: Validate RPC input size before parsing
Date: Thu, 28 May 2026 21:46:01 +0200
Message-ID: <20260528194641.905690913@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Heechan Kang <gganji11@naver.com>

commit e7537735028c3ad4b0bfc02ff8fa2a1a28aa04fe upstream.

The fwctl core allocates the device-specific RPC input buffer with
fwctl_rpc.in_len and passes that buffer to the driver callback.

pdsfc_fw_rpc() casts the buffer to struct fwctl_rpc_pds and then calls
pdsfc_validate_rpc(), which reads fields from that structure before
checking that the input buffer is large enough to contain it. A short
in_len can make pds_fwctl read beyond the allocation.

Reject pds RPC buffers that are smaller than struct fwctl_rpc_pds before
parsing any pds-specific fields.

Fixes: 92c66ee829b9 ("pds_fwctl: add rpc and query support")
Link: https://patch.msgid.link/r/20260517062232.1858747-1-gganji11@naver.com
Cc: stable@vger.kernel.org # v6.15+
Signed-off-by: Heechan Kang <gganji11@naver.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fwctl/pds/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/fwctl/pds/main.c b/drivers/fwctl/pds/main.c
index 08872ee8422f..68fe254dd10a 100644
--- a/drivers/fwctl/pds/main.c
+++ b/drivers/fwctl/pds/main.c
@@ -362,6 +362,9 @@ static void *pdsfc_fw_rpc(struct fwctl_uctx *uctx, enum fwctl_rpc_scope scope,
 	void *out = NULL;
 	int err;
 
+	if (in_len < sizeof(*rpc))
+		return ERR_PTR(-EINVAL);
+
 	err = pdsfc_validate_rpc(pdsfc, rpc, scope);
 	if (err)
 		return ERR_PTR(err);
-- 
2.54.0



