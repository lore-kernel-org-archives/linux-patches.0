Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79173C09F5;
	Wed, 30 Sep 2026 19:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794981; cv=none; b=QQmiNwlRZjVvuSASFaj7wB8afHGRO4wbrjR7JM+sP2OUSGPHZ44T6AKOFtLupOHSkcE2mmuDGYJhzGlzTj5JKsbGe9zeSu0eC6/Dd3jXkaIqU2j93RUKZ/wHK4I5dRXaWQDehwbbOl6RBdkgmMzjKDwx6IprmJQ0RIDAiTzjxIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794981; c=relaxed/simple;
	bh=1dkbZa9nB564UEJejoChXpc/Qs3LOOOidTkRqZd3jEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3hU8mm691wSOS8ur0pIYTujNos7YqNo9jMFgKRHKwQrT++fEGCUBBfo7iu3fyAgMiXbfU42CG8AYOMMiv/ZGV55RL99P3qAhbbj/EP05npM+4rWNKUKFpV6cU38tPFrGLeEoo/mX8iT0PGnWQEnSFgewj7A7AzbhjrEMI4qI1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afT37DBh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afT37DBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD7D1F000FF;
	Wed, 30 Sep 2026 19:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794980;
	bh=2Xa9WFy9AmOZRiFm/RPLDghQLlMLXobfNzDdxfR4R8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afT37DBh9GS4FNLTpSyIl6KgDCPPtenRFjoY2l2MKOyELx0i8WXHZK6vuJytaSDcc
	 O/Vkc+PkMsbimT7rz4qRd3/poY5fxSz4Gj+2o4VR1OIJywFNsgyL6p7HrRfiAV97xS
	 YpDFMiM2jIM77S1LvVKQ8kiA263YPPJ6Jwg7iv78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0374/1193] EDAC/igen6: Fix channel selection hash
Date: Wed, 30 Sep 2026 17:17:38 +0200
Message-ID: <20260930152442.488612684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 540b79536f3a89a66c5b6c490110298d43025618 ]

In channel selection hash mode, the hardware decoding logic always
includes the channel interleave bit in XOR operations. However, the
hash mask may or may not include this channel interleave bit. When
the mask does include this bit, the current igen6_edac code performs
XOR on the interleave bit twice, effectively ignoring it - which is
incorrect.

Fix this issue by ensuring the hash mask always includes the interleave
bit, so XOR is performed on the interleave bit exactly once.

Fixes: 10590a9d4f23 ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260730024238.4096623-4-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 56d3ec3db67d2..a7e8356651399 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -467,14 +467,22 @@ static enum mem_type get_memory_type(u32 mad_inter)
 
 static int decode_chan_idx(u64 addr, u64 mask, int intlv_bit)
 {
-	u64 hash_addr = addr & mask, hash = 0;
-	u64 intlv = (addr >> intlv_bit) & 1;
+	u64 hash_addr, hash = 0;
 	int i;
 
+	/*
+	 * In hash mode, the @intlv_bit is the lowest selected bit of @addr
+	 * to be XORed. While @mask may or may not include this @intlv_bit,
+	 * we enforce that @mask includes @intlv_bit to ensure @intlv_bit is
+	 * XORed exactly once.
+	 */
+	mask |= 1 << intlv_bit;
+	hash_addr = addr & mask;
+
 	for (i = 6; i < 20; i++)
 		hash ^= (hash_addr >> i) & 1;
 
-	return (int)hash ^ intlv;
+	return (int)hash;
 }
 
 static u64 decode_channel_addr(u64 addr, int intlv_bit)
-- 
2.53.0



