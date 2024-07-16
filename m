Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452C219E7CF;
	Tue, 16 Jul 2024 15:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145001; cv=none; b=cpCyb5g5o7lBee05taMqfmJpat51xKuIXUl2fUx4fqRgGzZQU53xj1ToWGKosxTJtNVVNoFC3MUAlBrsOHEEi65WLAUORiXSenbwYMJU3mSUx8lR9sTv3EH9MZ8uAHrTB64tanYOCgFe1NM79oZ8KBNeM6ZH7ai3R2porYU/j3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145001; c=relaxed/simple;
	bh=idtORb1cdWbMpllf6Sb/z3RYg+3q5YiIdorbZW/ImxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpyDZeni27xZodmzvttGBCwZyW/k1glGdGYjt08HRk1AJ67Gm/pE9aSMqSvu7ODEco9XyPQSKumpAJZFk8TMQz7rgI7uIizWULvuV6iUZ2+pBXFxOI9wTBVbFBzdEa5whb7JvCKRc1vDullm90tPjwLPCpMpnVkEtoTHtl/4Xkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K47Eoh3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K47Eoh3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6BCC4AF0B;
	Tue, 16 Jul 2024 15:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145001;
	bh=idtORb1cdWbMpllf6Sb/z3RYg+3q5YiIdorbZW/ImxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K47Eoh3IjPtLhIYDFMtUVqvyy2sMz3P1cgngaHzykN+JvbT5vr0w1nw9iHrgVJi42
	 HihLMlfyXvMjUPSGTaiBJ5Qm3airX5gkDEQZAGcKqh2OauMqU6UH79GMBuKdGLN2mH
	 9xcfxF1owamTMGF2VxwItusTkXmNgWZZyDXIsDiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saeed Mahameed <saeedm@nvidia.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 058/143] net: ethtool: Fix RSS setting
Date: Tue, 16 Jul 2024 17:30:54 +0200
Message-ID: <20240716152758.211489124@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit 503757c809281a24d50ac2538401d3b1302b301c ]

When user submits a rxfh set command without touching XFRM_SYM_XOR,
rxfh.input_xfrm is set to RXH_XFRM_NO_CHANGE, which is equal to 0xff.

Testing if (rxfh.input_xfrm & RXH_XFRM_SYM_XOR &&
	    !ops->cap_rss_sym_xor_supported)
		return -EOPNOTSUPP;

Will always be true on devices that don't set cap_rss_sym_xor_supported,
since rxfh.input_xfrm & RXH_XFRM_SYM_XOR is always true, if input_xfrm
was not set, i.e RXH_XFRM_NO_CHANGE=0xff, which will result in failure
of any command that doesn't require any change of XFRM, e.g RSS context
or hash function changes.

To avoid this breakage, test if rxfh.input_xfrm != RXH_XFRM_NO_CHANGE
before testing other conditions. Note that the problem will only trigger
with XFRM-aware userspace, old ethtool CLI would continue to work.

Fixes: 0dd415d15505 ("net: ethtool: add a NO_CHANGE uAPI for new RXFH's input_xfrm")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Ahmed Zaki <ahmed.zaki@intel.com>
Link: https://patch.msgid.link/20240710225538.43368-1-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index e645d751a5e89..223dcd25d88a2 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1306,7 +1306,8 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
 	if (rxfh.input_xfrm && rxfh.input_xfrm != RXH_XFRM_SYM_XOR &&
 	    rxfh.input_xfrm != RXH_XFRM_NO_CHANGE)
 		return -EINVAL;
-	if ((rxfh.input_xfrm & RXH_XFRM_SYM_XOR) &&
+	if (rxfh.input_xfrm != RXH_XFRM_NO_CHANGE &&
+	    (rxfh.input_xfrm & RXH_XFRM_SYM_XOR) &&
 	    !ops->cap_rss_sym_xor_supported)
 		return -EOPNOTSUPP;
 
-- 
2.43.0



