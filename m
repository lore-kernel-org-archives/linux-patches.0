Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F048E39733E;
	Mon, 17 Aug 2026 14:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975376; cv=none; b=MmfEhYkiTtwLYY4AEgTy8j43p+d9j/e1nAe5upCvA2lLTa5dZj/wLKFv7aPagwblA3M3JRvC5JmlfDTFfVvjeYcNCOPNGQbCGJC4CEWi2YlD8XHaUswIReX8swShGxr8IPqZW/cCRwL9TF4BTKInySoKwOkiNBupDZFX4PFzCEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975376; c=relaxed/simple;
	bh=2CU53v4YKtcXN4r/lHfZNIuu8n8XHD5juLDEZ5zuT1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X80K+JZbXX/AUjnJcR446IHLPYIvalg3k8wZm7EWYBrZ7EE0uoA3Ui7P/ZSio3bsob+EzpYHtCV2O+E927vGjQwdEsuB51KkyG7zSOfnI9Vk32y3i1SWkv1BSD9l32NsAvo6LNAZHPrtju9+YSlHLGDNd5iUSA7jmvyoLOHnCFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6dVTwJG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6dVTwJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538931F000E9;
	Mon, 17 Aug 2026 14:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975374;
	bh=gL8EPwRdjQb0vbli4v4Fw6UaCnuDFVygFS/gwEAyNWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6dVTwJGSxPe5fwUV3nA3HsdW0cscFEg93o/aPe/4H4C32io3rTD0jwUJ8r5OeUiR
	 wqc3VNnViYAe5kHsiCggWV6NC+KrEuE6emDgNyuB7z7i/r7IKDMqnCkZqyZXphO4Dt
	 8Byranxj6aKZG9yXN8lzVRZjtYWyO2rU+hQr6fKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.18 248/250] thunderbolt: Fix bandwidth group reservation indexing
Date: Mon, 17 Aug 2026 15:33:29 +0200
Message-ID: <20260817132546.616800268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit d2ee4d47aacbd2ba456092eeec670dba35fde291 upstream.

Valid bandwidth group IDs range from 1 through MAX_GROUPS, while Group
ID 0 is reserved. tb_consumed_dp_bandwidth() uses the Group ID directly
to index its local group_reserved[] array.

The array currently has MAX_GROUPS entries, so its valid indices are 0
through MAX_GROUPS - 1. Group ID MAX_GROUPS therefore accesses one
element past the end, and the final group's reserved bandwidth is not
included when the array is summed.

Give group_reserved[] MAX_GROUPS + 1 entries so direct Group ID
indexing covers the reserved ID 0 and valid IDs 1 through MAX_GROUPS.

Fixes: 52a4490e89d7 ("thunderbolt: Reserve released DisplayPort bandwidth for a group for 10 seconds")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -609,7 +609,7 @@ static int tb_consumed_dp_bandwidth(stru
 				    int *consumed_up,
 				    int *consumed_down)
 {
-	int group_reserved[MAX_GROUPS] = {};
+	int group_reserved[MAX_GROUPS + 1] = {};
 	struct tb_cm *tcm = tb_priv(tb);
 	struct tb_tunnel *tunnel;
 	bool downstream;


