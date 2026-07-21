Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1411740802F;
	Tue, 21 Jul 2026 18:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659127; cv=none; b=iN13Uf7op9EdxlyewRayaEUV1/GF8P5ZA6xdzwZnLzkVUJGxqg+uk9IrFDLPVd/L96PvkxIZYax1M6NSBPugGFTbk9dOCzzquuLS6f/ZLrKjzhiLWu67Cw61Z4x2uKrreGlPGfzIzp8Ggrmt11be5Za6Xh055rfNmwlAhZk8fyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659127; c=relaxed/simple;
	bh=dunkgJ0dSn54meKmJ7dQvQYfind67ZHNSFRoaysF49g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lq1YYNZWfHDe3EUFXBQ+YNoHg8ckwFlbgQu99l5BFFAL7mxD+f6+vgNwhGA7PQuLaPYi9c6rmYug1+I8Xir4gEB9ESH4F6FIIy8QmUnOns2EABm946nQD+Nh5/lVI901AJ5LyXSFsrc3cXoIGo873eAWfByYJ2smTVs+3oRspGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgbmUH79; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgbmUH79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453511F000E9;
	Tue, 21 Jul 2026 18:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659125;
	bh=3z1HjobVquw1ccRjRH1bycwKarLkkapKpNc1hix8/us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bgbmUH799cR04sz7sEb/aSXLHQxQstTHzM+R2+0CCwRM4b65sFUxAIJUc+Y8bZjOF
	 WbKfC0/xUU3op2P+yWubhXfqNfXtyorI89WtoHNgZXecT0qZBMLjWB/q0ajeLPf/rZ
	 nZrgtFM3NQanquQNGyhu4Qsg78XjHtbDi8Ofcl+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edoardo Canepa <edoardo.canepa@canonical.com>,
	Ross Porter <ross.porter@canonical.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1404/1611] selftests: net: fix file owner for broadcast_ether_dst test
Date: Tue, 21 Jul 2026 17:25:20 +0200
Message-ID: <20260721152547.022141722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Ross Porter <ross.porter@canonical.com>

commit b8613e9792002add3bf77122868cc06ce142e953 upstream.

Ensure the output file is always owned by root (even if tcpdump was
compiled with `--with-user`), by passing the `-Z root` argument when
invoking it.

Cc: stable@vger.kernel.org
Reported-by: Edoardo Canepa <edoardo.canepa@canonical.com>
Closes: https://bugs.launchpad.net/ubuntu-kernel-tests/+bug/2129815
Fixes: bf59028ea8d4 ("selftests: net: add test for destination in broadcast packets")
Suggested-by: Edoardo Canepa <edoardo.canepa@canonical.com>
Tested-by: Ross Porter <ross.porter@canonical.com>
Signed-off-by: Ross Porter <ross.porter@canonical.com>
Link: https://patch.msgid.link/20260617061039.79717-2-ross.porter@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/broadcast_ether_dst.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/broadcast_ether_dst.sh
+++ b/tools/testing/selftests/net/broadcast_ether_dst.sh
@@ -44,7 +44,7 @@ test_broadcast_ether_dst() {
 	# tcpdump will exit after receiving a single packet
 	# timeout will kill tcpdump if it is still running after 2s
 	timeout 2s ip netns exec "${CLIENT_NS}" \
-		tcpdump -i link0 -c 1 -w "${CAPFILE}" icmp &> "${OUTPUT}" &
+		tcpdump -i link0 -c 1 -w "${CAPFILE}" -Z root icmp &> "${OUTPUT}" &
 	pid=$!
 	slowwait 1 grep -qs "listening" "${OUTPUT}"
 


