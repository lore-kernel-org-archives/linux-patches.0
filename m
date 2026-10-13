Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108FF4EFFC8;
	Tue, 13 Oct 2026 11:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892190; cv=none; b=n+6y/+eOxFf9O+p8wpHpa5lueCpYxvRd2+SpHl7CLtm81dCGltwqvumAblw1vSoaOoHP7V8VbG8npCzi6mtplu9bpH7AyMHj4ec66PU0vmuSSliBnA9PUZC3WjA+NCXUiiM6f/632kE5zq1vjwZoYr8O3W+oX/yPhW0vtMF10m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892190; c=relaxed/simple;
	bh=tqaUukSglNF4NhSVdu7Mo6qC2nM1dTXabZp0VthA/IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPZYQPPsC2pvvvOS+OYsPWkJZc6COGd8jfoaKggzE6R9HieO1Jx3ZFgb4FwAqGt3jYfUnUa/z52tXuenIhIZAIFtO7aqp/JnyicnyTb1j2nQLZ/8t/CM1OqUaDjjS+DaL1jUIlForudqy81rihGs9tY9k9OzfRwCc3chVrp7ty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wInltfzb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wInltfzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D63C1F00893;
	Tue, 13 Oct 2026 11:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892188;
	bh=XyL7Vd19Ylr5SovMM1Te2ILDA1L/kuPEX5uxL1Rf62E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wInltfzbnfw/sKskL2Rbw2a5sW7z2Bg/lQ8Ox78N35ki/IkURa2/2zQYjLPUhaRlZ
	 qugniqieHKrRz2yzM6sc1zGi6svmcJ2/3KPXF8/lIhd5qujKgLNqHCXXJgLSZZxGxz
	 AdYgbmjRow/RuhVrx5FwVV9y07wSMs8fA7mTmheQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Karl Bonde Torp <k.torp@samsung.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.2 091/281] nvme: fix swapped ZRASF zone state values for full and read only
Date: Tue, 13 Oct 2026 13:36:47 +0200
Message-ID: <20261013112857.343233928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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
@@ -1266,8 +1266,8 @@ enum {
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


