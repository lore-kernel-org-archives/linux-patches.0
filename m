Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2DD47604A;
	Tue, 13 Oct 2026 12:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893816; cv=none; b=J0y9bpcLqjZyKpWpqtHUNLnGl6Z+KhbloS9F6lUpyMe3gp5AsAT6ozz7sF0V0OxhV9wuoTBHTX263CXfqAljuTUD/9o/vNGPCgQgLla75WxyrqCdhyZ6mWYpZOrzcQ11PBiv0Ry5YjjKXbZYhPqf45hdv2oykLuT1/MyBtaU1Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893816; c=relaxed/simple;
	bh=E+vLKX73qAA+BtTLrHyJY335y1LWTYL1kInDfgNnn9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqpCXWNTIpj2oASWb3w9rC7yRg7HLYKII2l+piA7V2cLFNBz7CXqm0DMXHNW3vcJ8YqGiic1cb6YiB577RGfS+B+skEquAdpAHHPpA/rY3m/W13RHqX6Yd3kQxyHAZd8CFU3HH5zFjs6woaRGJN5TSSu+sffB5F6V2fRdowsx0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYY40cww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYY40cww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF3E1F000FF;
	Tue, 13 Oct 2026 12:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893815;
	bh=R/ji2yOyPuJN1vqmdiN+EtzT5+eXs/HRbEjPQIp8lME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IYY40cwwDUK3HencvT3as5B1rV1pDbgPaNX3BAmd3oeXftsL41hiPJfMM1Rnf+5aU
	 t0PNraEDeFt1uRZIqcbqi438mKpXiyQoiUJV9JFa8yjipAQ/WisoloccXfdNuOnBdI
	 cBPcU2Y0TmB1GiV/28Ivy6d+iBjZO1e4uqL9vYjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 353/621] netfilter: flowtable: avoid num_encaps underflow on bridge VLAN untag
Date: Tue, 13 Oct 2026 13:35:48 +0200
Message-ID: <20261013112929.227687058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit e052f920773b73be49eb4d8702a9f85de7464363 ]

The DEV_PATH_BR_VLAN_UNTAG case post-decrements info->num_encaps
inside WARN_ON_ONCE(). num_encaps is u8, so if it's already 0 the
decrement still happens and wraps it to 255. The break only leaves
the inner switch -- a later path entry can set info->indev back to
a real device, and we end up returning with num_encaps == 255.

nft_dev_forward_path() then walks info.encap[] (size 2) up to
num_encaps, which means an OOB stack read and a bogus count copied
into the route descriptor.

Should only happen on a malformed bridge path stack, hence the WARN,
but worth handling sanely. Move the decrement out of the WARN.

[ While at this, remove the WARN_ON_ONCE since this can only happen
  with a buggy bridge path stack --pablo ].

Fixes: e990cef6516d ("netfilter: flowtable: add bridge vlan filtering support")
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_path.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index c5bb142f329bc..7a3b795f86277 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -147,10 +147,11 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->num_encaps++;
 				break;
 			case DEV_PATH_BR_VLAN_UNTAG:
-				if (WARN_ON_ONCE(info->num_encaps-- == 0)) {
+				if (info->num_encaps == 0) {
 					info->indev = NULL;
 					break;
 				}
+				info->num_encaps--;
 				break;
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
-- 
2.53.0



