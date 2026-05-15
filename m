Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2BE305674;
	Fri, 15 May 2026 15:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860779; cv=none; b=DmSmQYj1cGyIITLY9l96opGVL5ClVy7H5FwjckaT+1p7X0JxIDCrx2mYGWwtbnWh5PwLGfv8aK/1WWuf2Rf3S+JGKgop0UuMsbrG0VRFTqsCMIYh4Kre/CNNeHeZqqCYoEFq6FP4i08oNfm4kxQzzcAwuMs/xYEEcMckUmtlgLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860779; c=relaxed/simple;
	bh=SkwpEUn7WRZDBdjmIyoZpV3ehIIaZL+9maJe7EbiaFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFD242XVtasRqQ7JbCZYtPnIsKcZa9g7l2zdaAdNODNYSd7k8dCsUwt+0SbV6HQO9EOGWe9OeI2MGfd6eBQk3juPTn+XiiReY5yR5QzZB1u21OwYE6uJv4NcIbFP4LQ2N8unIcAFxssBqJQO4eki4dmzo+NvlD4/P9cY8sdmA3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yXCl7Wn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yXCl7Wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22602C2BCB0;
	Fri, 15 May 2026 15:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860779;
	bh=SkwpEUn7WRZDBdjmIyoZpV3ehIIaZL+9maJe7EbiaFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yXCl7Wnumo1dT+K5VECbzSPV8EClbZfo2Q/+T9SWBGL/1N6zn40KaMEw6StJJv6+
	 tXpnD0LF7NtIFWVWaLzAT5Ipkwnjm0hiIHxFuwslaVpeGEPcVn1S2kKlyPoaRpwWkI
	 C742Zn+S+NLIQooMWea/5oNZmvxM2Lv5bgBiiVmA=
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
Subject: [PATCH 6.6 077/474] ipv4: icmp: validate reply type before using icmp_pointers
Date: Fri, 15 May 2026 17:43:06 +0200
Message-ID: <20260515154716.704977680@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -359,7 +360,9 @@ static int icmp_glue_bits(void *from, ch
 				      to, len);
 
 	skb->csum = csum_block_add(skb->csum, csum, odd);
-	if (icmp_pointers[icmp_param->data.icmph.type].error)
+	if (icmp_param->data.icmph.type <= NR_ICMP_TYPES &&
+	    icmp_pointers[array_index_nospec(icmp_param->data.icmph.type,
+					     NR_ICMP_TYPES + 1)].error)
 		nf_ct_attach(skb, icmp_param->skb);
 	return 0;
 }


