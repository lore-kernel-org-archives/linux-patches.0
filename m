Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E293D3334;
	Mon,  4 May 2026 14:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903966; cv=none; b=i22WL5fNHZourzGWWTwjDt9TMPXnIZut5dFBJwvwF3mpk6aRgA560UVGK/2QbEPv1V0b5K8oDI9H6psoYR8L0zSE959qxy89VA6AjXoa05T1jkASv9idRlg2zL5vBA98IS3bIdymZ9+66xXJpdClCgXrZmf148z5GuWqDXg+5SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903966; c=relaxed/simple;
	bh=HTmxVLIwnODIYzgpzd+Gu3DL2AECVSskSsNzQndp64g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbRoYvCWfJggi3otqcyUrTa3mHrjUBerKndhdxPJUjJzILUKcgXnra4RJTmvm+laUdGHjzCSB/893vOVCfHZMM8VKomFdLxL/YERFp/kwjMGCfyiQRjtdtG9q336JRJ7ZcKnpw97eNkFd5mGN+PIUVJtgImZ84vWg8TP2McscF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UqXwt7+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UqXwt7+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E989C2BCB8;
	Mon,  4 May 2026 14:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903966;
	bh=HTmxVLIwnODIYzgpzd+Gu3DL2AECVSskSsNzQndp64g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UqXwt7+ouQd5TrqyUNBrcAzvvaPUAV85dYrzX8ZttR3WjLpvtoTKay6kOR9iJqGWH
	 tegfkJwN4EQsS2M0Sd5F1IT5JuqtLQXFbRkRz/x4GJLWJ0+W756YVl/WCy5t9UpVbo
	 M5opZQ9CKTF2jIQe/mViNlgIncC/JbcjqVB92+bI=
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
Subject: [PATCH 6.18 132/275] ipv4: icmp: validate reply type before using icmp_pointers
Date: Mon,  4 May 2026 15:51:12 +0200
Message-ID: <20260504135147.805067146@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
@@ -362,7 +363,9 @@ static int icmp_glue_bits(void *from, ch
 				      to, len);
 
 	skb->csum = csum_block_add(skb->csum, csum, odd);
-	if (icmp_pointers[icmp_param->data.icmph.type].error)
+	if (icmp_param->data.icmph.type <= NR_ICMP_TYPES &&
+	    icmp_pointers[array_index_nospec(icmp_param->data.icmph.type,
+					     NR_ICMP_TYPES + 1)].error)
 		nf_ct_attach(skb, icmp_param->skb);
 	return 0;
 }


