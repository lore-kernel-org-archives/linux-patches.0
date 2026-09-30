Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0E04F472F;
	Wed, 30 Sep 2026 15:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783314; cv=none; b=kx5Y1aD+DcMLlj2IbQd2W1StuXNNmMxkWlf8ELcVoKE2er096u9NUI1T8Tnot9/GcsFWiEvp9sNPbKP/unsTFIv23tF3JJhdjh6+MTpBMOM7oVBzT8vbd/7bK6Thk09baFgVww/ix6yVAL6SfBUbjrSZmgBb0bvzcPa/CUCyyNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783314; c=relaxed/simple;
	bh=UDAvJ7ibrYrc+t5U7+yHC6UzAKVXTVXoI4OLbTMoGPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nS62A2Abpyt0XGue6Gg2gEc6XO3KPfymNtTLJV9iY4bAJf2mY5BtB4wNJ0CkQrfr0UmR7hVV/zR6rqS0CjuN5Csge/BR/crVffeKdgyui2nMSj/bydVfRAplsmn4CQStJhUaPsxkpBUvQW4e2HGoWl/OJCdisuUNgd8UNk/oPZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BanBHLBE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BanBHLBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CBD1F000FF;
	Wed, 30 Sep 2026 15:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783310;
	bh=d+vdJDUE/VTZcy/XWHAF1xlRqBhMTAwpvP+64ocksMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BanBHLBEslPF1WeS59SXGlhxfwxejS1OsevNqj6JgA2GiIYc/QciN0nNiB0pLzkS1
	 7LAnVR/Lof1Y+5DIwkJVOMzhDMkxQ6Eyr/wt8EzGUAjBXnlJ/4Sg/eESCIyGbb/CCJ
	 0kHxWaF+dCfW73wrftIEltXN3s3pNubENFRAO2cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 309/595] ipvs: reject invalid states in connection template sync records
Date: Wed, 30 Sep 2026 17:23:22 +0200
Message-ID: <20260930152354.333143967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


