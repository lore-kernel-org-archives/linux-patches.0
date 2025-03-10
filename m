Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A8A2D023;
	Mon, 10 Mar 2025 17:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629383; cv=none; b=dWR1ciybA+7+u7D6OqvaMHoTiMPCQTkjYZW+XuX8Q8s1sB++g/gI5MDPykmc2eCql7f+kQGccze4uKYnWOoLZ522v/7Lx0d7SSxhGNnjucoht34WsiTkrZs5s4hC8SMTZjuGan2t3bAquIo5AyozK1t6gELL5mwpOdBxf25vONo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629383; c=relaxed/simple;
	bh=yj78NiunOBJzSlwPB0kKexQaqReYTPQk3axLiKg70zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGMkaNzjpQ//B4AHD379apk5hfYAYhSi4sIxmIEpsbKpZVBXRTlZRbNrgDPCu9/VSaXuQRfl2LBHchKrLtPCr9mtrYvyRbyBU8+/juOwXrcVD4FWQKvrCUYZLmzJ8Ct7MwURARRCscTR96q8CtbHQM2N3P0yRk4YlYTLC46ABtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vC1DxdVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vC1DxdVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D609DC4CEE5;
	Mon, 10 Mar 2025 17:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629383;
	bh=yj78NiunOBJzSlwPB0kKexQaqReYTPQk3axLiKg70zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vC1DxdVQV0VeEzAf1PnDowsZvoLMDtE8rr/mhJL9JTQZTgbkHX4W78bo7FChON0OU
	 vX32C472QQgFgQKc/P8FVTE96XKUeaCELIfSA/XtvX5VZu07cee2ANay2KW9xBlIEY
	 C+4vQuwqYRMU3YyoVGYSc39ymb/io9VqPnMk2qb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.15 275/620] of: Fix of_find_node_opts_by_path() handling of alias+path+options
Date: Mon, 10 Mar 2025 18:02:01 +0100
Message-ID: <20250310170556.474874514@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit b9e58c934c56aa35b0fb436d9afd86ef326bae0e upstream.

of_find_node_opts_by_path() fails to find OF device node when its
@path parameter have pattern below:

"alias-name/node-name-1/.../node-name-N:options".

The reason is that alias name length calculated by the API is wrong, as
explained by example below:

"testcase-alias/phandle-tests/consumer-a:testaliasoption".
 ^             ^                        ^
 0             14                       39

The right length of alias 'testcase-alias' is 14, but the result worked
out by the API is 39 which is obvious wrong.

Fix by using index of either '/' or ':' as the length who comes earlier.

Fixes: 75c28c09af99 ("of: add optional options parameter to of_find_node_by_path()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241216-of_core_fix-v2-1-e69b8f60da63@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -925,10 +925,10 @@ struct device_node *of_find_node_opts_by
 	/* The path could begin with an alias */
 	if (*path != '/') {
 		int len;
-		const char *p = separator;
+		const char *p = strchrnul(path, '/');
 
-		if (!p)
-			p = strchrnul(path, '/');
+		if (separator && separator < p)
+			p = separator;
 		len = p - path;
 
 		/* of_aliases must not be NULL */


