Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F643A900B;
	Sat, 17 Oct 2026 17:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257271; cv=none; b=m1PUXOnU0JCravaAfoEqqT1CwzIKF7gGqmqHQF8TDNYzAe1r9vWuSTvr6b+9Qh0u7fUgwCRDR2u1xD7pn0DAupEqPHnZ3tpCdQCrytB+ZaFgDF6G24LO0iH7PbmDmc7rM8iR4S8Mf4u43V4GFCMstqMmh4agR044uxwthPFatiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257271; c=relaxed/simple;
	bh=YjwCn93TYuIrmeiIGyi9sLmKS8xGmyAQZ8GvBrns4Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0JMwRbdSXfxiiQg0dS8q73bP552RTjRAXXAYqohH5jBYlf067miTbSRceEEgPcGbGLHfC8lJQ8WCkmER53Tw4OwAzS16bNJAeOzO7vyES2f4WqCGBSzbtdE4QRVpHeoetjXLfsxeEmjWz+GNSSm6Sv+teIWMqGhA+pW0EPUojc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7EgcqQW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7EgcqQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C9C1F000C4;
	Sat, 17 Oct 2026 17:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257270;
	bh=Mpp8EBT+vamnCyKFHUnTqg5wcjJbX5nJ7VBViQBR6Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K7EgcqQWOybEf/a/YpfJYdjBO2UkliB0KB0h9pAVHuzgV3FlukC6e92NaxwMi4rTq
	 GG2OqmcieBfkSsItIJdOo93gLMGeNzSFzzD/xBv9Pm9i36Njk4sNvQIyp7ariT3dcp
	 X1xD7uRy3ufNwXVFm2FNsjGVkkRRRqVpLDvEnpDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Karl Bonde Torp <k.torp@samsung.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 0506/1674] nvme: fix swapped ZRASF zone state values for full and read only
Date: Sat, 17 Oct 2026 17:46:18 +0200
Message-ID: <20261017160444.096334331@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Bonde Torp <k.torp@samsung.com>

commit 564e46d9f6e87912effa03f123d37a511d520f09 upstream.

The Zone Management Receive command Zone Receive Action Specific (ZRASF)
reporting option values for the Full and Read Only zone states are swapped
compared to the NVM Express Zoned Namespace Command Set Specification,
Revision 1.5, Figure 35:

- 5h lists the zones in the ZSF:Full state.
- 6h lists the zones in the ZSRO:Read Only state.

The nvmet ZNS backend uses these constants to map the ZRASF value received
from the host to a block layer zone condition when filtering zones in
Report Zones. Because of the swap, a host asking for full zones was given
the read only zones, and a host asking for read only zones was given the
full zones.

Swap the values of NVME_ZRASF_ZONE_STATE_FULL and
NVME_ZRASF_ZONE_STATE_READONLY to match the specification.

Fixes: aaf2e048af27 ("nvmet: add ZBD over ZNS backend support")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Karl Bonde Torp <k.torp@samsung.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/nvme.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -1099,8 +1099,8 @@ enum {
 	NVME_ZRASF_ZONE_STATE_IMP_OPEN	= 0x02,
 	NVME_ZRASF_ZONE_STATE_EXP_OPEN	= 0x03,
 	NVME_ZRASF_ZONE_STATE_CLOSED	= 0x04,
-	NVME_ZRASF_ZONE_STATE_READONLY	= 0x05,
-	NVME_ZRASF_ZONE_STATE_FULL	= 0x06,
+	NVME_ZRASF_ZONE_STATE_FULL	= 0x05,
+	NVME_ZRASF_ZONE_STATE_READONLY	= 0x06,
 	NVME_ZRASF_ZONE_STATE_OFFLINE	= 0x07,
 	NVME_REPORT_ZONE_PARTIAL	= 1,
 };


