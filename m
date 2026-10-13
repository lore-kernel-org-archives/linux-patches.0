Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D114A35;
	Tue, 13 Oct 2026 12:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895837; cv=none; b=ObPCKhYKDY/X1VNmS/xYlG83UulQrJVX1Fi943PNjUTVMMEuUpjmMlsOR2FfPlaBVtyInP+NsWEIroPRw7M5H0xoQUapp6RWiBo6PkP5hqAa0GkqK9DMd6sLupIyxAr0HjmmHxmUaVkbwjtCsUJYzTJHDA0i0aOkyPn5Waq+pw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895837; c=relaxed/simple;
	bh=R5Qt/LXyUcnV9AjB0TNF7e+3h+ladoTJUT189ODv4qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwu0tn7xEL8kJhtGX4X9retd++C44EFNG+0ZNHDoVTW+WEx8zaeqlz0qZ6l3Q635oBpfY2DWQhBefKYQ1sbu7X+IDN3h1SV/CyRJ7lJXit/bh8DMQXyabkmSHny4lbYx0vwWWlG13lFdTY9dmfnTlLC4Ww24nT6EfxvaX1y3/FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUKCOsXM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUKCOsXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2431F0089B;
	Tue, 13 Oct 2026 12:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895835;
	bh=u8GyoDADbWh22fbA+W2RAX5EiM7YygnbqX3BDpjSEuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUKCOsXMQk6UBZH+MzNMr6mIJZB2rQ2jrDQRw0WGzqNubjfc1wUD4E2zH8aqvMKwx
	 54m68zXutEDnVCLpC8SemawJtPBcmsB4pyRjxu9NW8+6E80ceqOXKoKMBey2JNNI9A
	 NbslyIHXfK4v+hj4qnz82THK9jkR3dOvwb0+Eqp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Karl Bonde Torp <k.torp@samsung.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 407/497] nvme: fix swapped ZRASF zone state values for full and read only
Date: Tue, 13 Oct 2026 13:39:34 +0200
Message-ID: <20261013112917.550913296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -1110,8 +1110,8 @@ enum {
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


