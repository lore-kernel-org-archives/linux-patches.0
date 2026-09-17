Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39182547075;
	Thu, 17 Sep 2026 17:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666436; cv=none; b=XJDEEsDmNG/0mDqaQJcHkkkqURWQNoRvKn7jxrghLE0rk6HMlsGf1xcUD7YaH2LFsStif1HULqbpzNUf+2GGsRjzm1NX1Eg40xDgqbVb2O8H5BlgUQkC8oLHD/pAcICXygngzT0XuiYffFwO/DxZu/9tiOA5F1UH14mBCo34ULk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666436; c=relaxed/simple;
	bh=9Q6wyOQmTccHM3KCo7SjeqCYNw4P7grcB3DCMVqbnm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjmK/FlmT/A3A9vM6eK4U1s5tXK51V1kLCMJZQnJD3Acs5vmIc2gSBs9qN0s2MfZVicLeQuSfGhpjunzYdeuPwbsqmWWiwXxdfhJckh58F8QFB5AOrmZ0PoUdseHixNCHiwaSHVIZnTyzkKR44XoDeqr7NDu0xpV2q48tmgPZps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlMEGOeE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlMEGOeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777B51F000FF;
	Thu, 17 Sep 2026 17:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666435;
	bh=oTo8iHuEYRcWvF3YqXzZNvPohE8cQg3F0owc3f+6bmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KlMEGOeEL+BBc2NvZQXEaLUK5TSJdHUY/uIP++dEpfbu26FBTA4ISCccFdyvJ1JaQ
	 b52GziJ8ntNn6YW0XJ3OvIZ3s6/2p55EKps5rePapBUAJ+KuAwneD+4dxR35VdDrjR
	 Hc8blIwXF0eMIAzfMLzGwjHyvQ9mFCQg6LdO4hhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 1037/1250] ipvs: reject invalid states in connection template sync records
Date: Thu, 17 Sep 2026 16:13:52 +0100
Message-ID: <20260917151620.185814380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

commit 74cb39735b6cd0aff4b5584158f09376fd97aadf upstream.

IPVS sync receivers validate protocol states before creating or updating a
connection. For connection templates, however, they only log states outside
the template state range and still store the value in the connection.

A template can be returned by ordinary connection lookup. TCP and SCTP then
use the invalid state as an index into their transition tables.

Reject invalid template states in both sync protocol versions before
looking up or modifying a connection. The version 1 path handles both
IPv4 and IPv6 records.

Fixes: 275411430f89 ("ipvs: add assured state for conn templates")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_sync.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1000,10 +1000,10 @@ static void ip_vs_process_message_v0(str
 					pp->name, state);
 				continue;
 			}
-		} else {
-			if (state >= IP_VS_CTPL_S_LAST)
-				IP_VS_DBG(7, "BACKUP v0, Invalid tpl state %u\n",
-					  state);
+		} else if (state >= IP_VS_CTPL_S_LAST) {
+			IP_VS_DBG(7, "BACKUP v0, Invalid tpl state %u\n",
+				  state);
+			continue;
 		}
 
 		ip_vs_conn_fill_param(ipvs, AF_INET, s->protocol,
@@ -1160,10 +1160,10 @@ static inline int ip_vs_proc_sync_conn(s
 			retc = 40;
 			goto out;
 		}
-	} else {
-		if (state >= IP_VS_CTPL_S_LAST)
-			IP_VS_DBG(7, "BACKUP, Invalid tpl state %u\n",
-				  state);
+	} else if (state >= IP_VS_CTPL_S_LAST) {
+		IP_VS_DBG(7, "BACKUP, Invalid tpl state %u\n", state);
+		retc = 40;
+		goto out;
 	}
 	if (ip_vs_conn_fill_param_sync(ipvs, af, s, &param, pe_data,
 				       pe_data_len, pe_name, pe_name_len)) {


