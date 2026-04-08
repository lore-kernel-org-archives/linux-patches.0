Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84103331A44;
	Wed,  8 Apr 2026 18:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673436; cv=none; b=ebHEgmTAxjJlhkO2C6hqWuA46TCtsHkr8abCgKMJDTqeniqb0mH/etncMZ34D8JtDqZxS8iXNRTk5rBYhUKH6RGkj6fjrJFx78eN4x8BSAaz3UFrJjngmBag9nOxsSohdun2MHdfR3p5c86g86GkTodOM+Ep5tqEDux2OKvAzlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673436; c=relaxed/simple;
	bh=TloRW3vMGEQniJyPC+qRmm2C0/OsiGsGt5BZpNfhhUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nThLNgpVqEVuWU8De7GnzUpR29yE0vuxvg7lgw7ZBUlE/3lpwvoAvq0HCpROTvJeVS41RjqjYtpjtIyxqyAj3Y7YCZL8RNssQoUrc2GtM927aaqTM2x+jOlDlLQ5yLAtPXcmPRaEWLCl2Zdl7JnPWLpyq4jjOStbnREKzNTt0DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jNJTRpKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNJTRpKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F62C19421;
	Wed,  8 Apr 2026 18:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673436;
	bh=TloRW3vMGEQniJyPC+qRmm2C0/OsiGsGt5BZpNfhhUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNJTRpKytcxFE3hcrbHe9aAXuFuqHXEz+mmAs6tKhyDXHsMF+u9BSMpa+kINzsxdo
	 Y0ttLOjjpYBCE+vqdQFv1HOP8G/Zv8P8+VI91CM6H7+JT9wj4UpltKzCGI1Yax/uao
	 7qwdz+Jk8A8j6HzkPCdhKDPSNyPg5QXkMjvEl0AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Ao Zhou <n05ec@lzu.edu.cn>,
	Yuan Tan <tanyuan98@outlook.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 232/277] vxlan: validate ND option lengths in vxlan_na_create
Date: Wed,  8 Apr 2026 20:03:37 +0200
Message-ID: <20260408175942.519887879@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Yang Yang <n05ec@lzu.edu.cn>

commit afa9a05e6c4971bd5586f1b304e14d61fb3d9385 upstream.

vxlan_na_create() walks ND options according to option-provided
lengths. A malformed option can make the parser advance beyond the
computed option span or use a too-short source LLADDR option payload.

Validate option lengths against the remaining NS option area before
advancing, and only read source LLADDR when the option is large enough
for an Ethernet address.

Fixes: 4b29dba9c085 ("vxlan: fix nonfunctional neigh_reduce()")
Cc: stable@vger.kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Tested-by: Ao Zhou <n05ec@lzu.edu.cn>
Co-developed-by: Yuan Tan <tanyuan98@outlook.com>
Signed-off-by: Yuan Tan <tanyuan98@outlook.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yang Yang <n05ec@lzu.edu.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260326034441.2037420-4-n05ec@lzu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1965,12 +1965,14 @@ static struct sk_buff *vxlan_na_create(s
 	ns_olen = request->len - skb_network_offset(request) -
 		sizeof(struct ipv6hdr) - sizeof(*ns);
 	for (i = 0; i < ns_olen-1; i += (ns->opt[i+1]<<3)) {
-		if (!ns->opt[i + 1]) {
+		if (!ns->opt[i + 1] || i + (ns->opt[i + 1] << 3) > ns_olen) {
 			kfree_skb(reply);
 			return NULL;
 		}
 		if (ns->opt[i] == ND_OPT_SOURCE_LL_ADDR) {
-			daddr = ns->opt + i + sizeof(struct nd_opt_hdr);
+			if ((ns->opt[i + 1] << 3) >=
+			    sizeof(struct nd_opt_hdr) + ETH_ALEN)
+				daddr = ns->opt + i + sizeof(struct nd_opt_hdr);
 			break;
 		}
 	}


