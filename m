Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6236F349CCF;
	Sat, 30 May 2026 17:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163324; cv=none; b=dEeJy96xpvAR8vtGYIIPYZrMqh3tot0Kxar/Cmn/1P+GHsd2P4pB+UuHg/WfhXHyZuB0UEanyeQl0zlk2yXymV/2vrh2XRcPHIG3M3jj9sKtCDiSRlm3a6U7UFu5Rp6Rl0PbXJLS2BUbDmJF73nmoY5c8yyUFryc29rRo69wW3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163324; c=relaxed/simple;
	bh=ltiVSEG5CJ47iMI0VdGSCYERmib190fBtxWi2pjtr+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R080rffYDb/dQHoj73IBQr68eV7M8tKUO82yG/c/akYR4hz980yb+vmbr1o043wJKFIs8qhmxxiXTOSlPof8G9hPJcm/CW66e4fgL37n1SxEy/2CDvOPFBw3qPJalhO+Gqe70F6FvjtmGg9sOzAdh2/BYj+sTmV1ecBsyTlo4JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGjOj8l6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGjOj8l6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B931F00893;
	Sat, 30 May 2026 17:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163323;
	bh=LQLKOssmSNm5t8vdVePpxanc0xe5WD6m/RewBXYx1RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RGjOj8l6rQlZHdL1yAEjpIf4rnMi7foBP/K/6Nzh0Ncc1vy3Ks5y7Ejyb2izCMokq
	 vEi8o/2v+g4Iyke9uu54mvJr3/IEIj01gt6CtoSRdrit863b+6a0HJ/h8X5AOdDynA
	 fmIEXrpzWpU3XaKTWiMjt3drjjPaOt0mZUyc2AP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ruide Cao <caoruide123@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 223/776] ipv4: icmp: validate reply type before using icmp_pointers
Date: Sat, 30 May 2026 17:58:57 +0200
Message-ID: <20260530160246.285993769@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruide Cao <caoruide123@gmail.com>

commit 67bf002a2d7387a6312138210d0bd06e3cf4879b upstream.

Extended echo replies use ICMP_EXT_ECHOREPLY as the outbound reply type.
That value is outside the range covered by icmp_pointers[], which only
describes the traditional ICMP types up to NR_ICMP_TYPES.

Avoid consulting icmp_pointers[] for reply types outside that range, and
use array_index_nospec() for the remaining in-range lookup. Normal ICMP
replies keep their existing behavior unchanged.

Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Ruide Cao <caoruide123@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/0dace90c01a5978e829ca741ef684dbd7304ce62.1776628519.git.caoruide123@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/icmp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -64,6 +64,7 @@
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/fcntl.h>
+#include <linux/nospec.h>
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/inet.h>
@@ -361,7 +362,9 @@ static int icmp_glue_bits(void *from, ch
 				      to, len);
 
 	skb->csum = csum_block_add(skb->csum, csum, odd);
-	if (icmp_pointers[icmp_param->data.icmph.type].error)
+	if (icmp_param->data.icmph.type <= NR_ICMP_TYPES &&
+	    icmp_pointers[array_index_nospec(icmp_param->data.icmph.type,
+					     NR_ICMP_TYPES + 1)].error)
 		nf_ct_attach(skb, icmp_param->skb);
 	return 0;
 }


