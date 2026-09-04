Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6AD38E8DD;
	Fri,  4 Sep 2026 05:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499673; cv=none; b=LDReUZN0fyhQbOxHcbJVFWXreMiawzKStSnVmvqnoF7z5fn7GkJvrdWdVYn3i+0mMEDhMJP1pErW4cED3D2iNrsyXirZ8vQPBD6JT0ZYXarhKmzYHOAAB321ZXNe7/UV4fA1RtwTDiRTLDZ6yipkPjfEhXpMEuq9HSY7x72OkUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499673; c=relaxed/simple;
	bh=dODgK9hedy8/fT/aUmNdxJ5Hn6GTvir1L4Y6Yj5PoiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieyOHAve6dQriOVb3wdxv4CIzwqqvF6WI4fnz6MCeKsrkHRCoVqCMSEQBBawRNpuPO53iR/cdjgGvmXWfUdf9IEZHlPdVEQ8gjXaqmGzkF4AltwWcJSIc0wDdRId4VRdjLm+MUNIcQjZEetR8lTmJYWslDUPX7Bb9ECDCKVsdBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6pgPPQF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6pgPPQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C291F00A3D;
	Fri,  4 Sep 2026 05:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499672;
	bh=VTtN/I2Q+xDOE/audSynXPafqPqJrS5kHdVC5Vfww9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e6pgPPQFUuT+m1HD1tnhHvPzO8vDkw8cb8KquIXC2rYYxrGU/7aHid25WJT1ITYon
	 hHz/2WJHCSZgIFufqFe4HR/Bx7XrLtvlipY1s4nY0V5zWxbPBDFgQBFVjgnHYyGelQ
	 wUkxF50hzq63KTeiby1C2jQVKELGeV6gl4rnxXpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.2 447/713] RDMA/uverbs: Add UVERBS_ATTR_UHW to UVERBS_METHOD_REG_MR
Date: Fri,  4 Sep 2026 06:56:55 +0200
Message-ID: <20260904045813.850354872@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

commit 011199f46f44a9fd93a9e5ab5d7fd1328d80e9bf upstream.

The original commit missed that three drivers (mthca, irdma, siw) have UHW
data associated with reg_mr that cannot be passed through the ioctl. They
also assume that the udata cannot be NULL, so failing to pass a valid
udata can trigger a NULL udata crash in those drivers.

This never happens in real systems since in rdma-core ibv_cmd_reg_mr_ex()
does not accept a udata and those three drivers don't use it, however a
malicious userspace could trigger it.

Cc: stable@vger.kernel.org
Fixes: 5b2e45049dc0 ("IB/core: Add UVERBS_METHOD_REG_MR on the MR object")
Reported-by: Jacob Moroni <jmoroni@google.com>
Closes: https://lore.kernel.org/all/CAHYDg1TOGxRGZrS69d4Y--Shj_DZv0nJuM73iHUBwBM70g_t3Q@mail.gmail.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/uverbs_std_types_mr.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/core/uverbs_std_types_mr.c
+++ b/drivers/infiniband/core/uverbs_std_types_mr.c
@@ -364,7 +364,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_
 							dmah, attrs);
 	else
 		mr = pd->device->ops.reg_user_mr(pd, addr, length, iova,
-						 access_flags, dmah, NULL);
+						 access_flags, dmah,
+						 &attrs->driver_udata);
 
 	if (IS_ERR(mr))
 		return PTR_ERR(mr);
@@ -527,7 +528,8 @@ DECLARE_UVERBS_NAMED_METHOD(
 			    UA_MANDATORY),
 	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_REG_MR_RESP_RKEY,
 			    UVERBS_ATTR_TYPE(u32),
-			    UA_MANDATORY));
+			    UA_MANDATORY),
+	UVERBS_ATTR_UHW());
 
 DECLARE_UVERBS_NAMED_METHOD_DESTROY(
 	UVERBS_METHOD_MR_DESTROY,


