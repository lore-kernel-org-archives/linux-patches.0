Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0AB2D7380;
	Tue, 13 Oct 2026 12:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893500; cv=none; b=UlmTI7zffj+ZOQgj7EmazBrlE+ozFY1e/BHGpyLR9qDVwAB6QuuolTxTflrw0vUMOBoak/RyEKMxYgY6b1qyKMwWRHNZ98L2XaTEeXKl1E1Yi3bAIUnmPzu5BHSge1Kc48H2BJuBz+Tgw6XEsxPJ2czkP+QIdYmiHuqAWIG5/1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893500; c=relaxed/simple;
	bh=ovSLkQTyryaG8jGP//ZX3p1DdAvLKa9f9F/BvwzRHm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKICfpLRYaaDedbIcjflCie8x10TNFdjCjRV20UGlv2RPISv89t+BgT+aj8XRP2QQ1xwRlZrU9ihcsYWObyH1pxTP0dxDlQDmxYZojz7VRDkNapD6SiUdjesgNMsxj6Ch3HdCnCu7eaIuJOk38SiJXUBWawRsbxlRierGxBa6gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HC2Gh3Q7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HC2Gh3Q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9FF1F000FF;
	Tue, 13 Oct 2026 12:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893498;
	bh=I/Of50uzORuBo8L77HOPx6Wd4vjP4P1T/w6bz9563+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HC2Gh3Q7nVC/QpmKl1mASTCMiP43ueYLY3On7drZOZXNof2uu+DEfUE7tSGhMSyPj
	 dYRk9KZGbq+sHNXjJ/8NyoU42OAUcUEkD7B/+zyhGNbKApg+wkWSXGIkvVRdveMoqr
	 q+akNxvqvGyMoVYZq8U1hqbTXqCMrrdEBEQqRE+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 244/621] netfilter: x_tables: allow initial table replace without emitting audit log message
Date: Tue, 13 Oct 2026 13:33:59 +0200
Message-ID: <20261013112926.650221546@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 8e72510db9fa2d41f2b06d5c01fe9020e076fee4 ]

At the moment we emit the audit log a bit too early, which makes it
necessary to also emit an unregister log in case we have to unwind
errors after possible hook register failure.

Followup patch will be slightly simpler if we can delay the
register message until after the hooks have been wired up.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: b62eb8dcf2c4 ("netfilter: x_tables: allocate hook ops while under mutex")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/x_tables.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 76fd0999db4a8..492b1086157b2 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1408,11 +1408,9 @@ struct xt_counters *xt_counters_alloc(unsigned int counters)
 }
 EXPORT_SYMBOL(xt_counters_alloc);
 
-struct xt_table_info *
-xt_replace_table(struct xt_table *table,
-	      unsigned int num_counters,
-	      struct xt_table_info *newinfo,
-	      int *error)
+static struct xt_table_info *
+do_replace_table(struct xt_table *table, unsigned int num_counters,
+		 struct xt_table_info *newinfo, int *error)
 {
 	struct xt_table_info *private;
 	unsigned int cpu;
@@ -1467,10 +1465,23 @@ xt_replace_table(struct xt_table *table,
 		}
 	}
 
-	audit_log_nfcfg(table->name, table->af, private->number,
-			!private->number ? AUDIT_XT_OP_REGISTER :
-					   AUDIT_XT_OP_REPLACE,
-			GFP_KERNEL);
+	return private;
+}
+
+struct xt_table_info *
+xt_replace_table(struct xt_table *table, unsigned int num_counters,
+		 struct xt_table_info *newinfo,
+		 int *error)
+{
+	struct xt_table_info *private;
+
+	private = do_replace_table(table, num_counters, newinfo, error);
+	if (private)
+		audit_log_nfcfg(table->name, table->af, private->number,
+				!private->number ? AUDIT_XT_OP_REGISTER :
+				AUDIT_XT_OP_REPLACE,
+				GFP_KERNEL);
+
 	return private;
 }
 EXPORT_SYMBOL_GPL(xt_replace_table);
-- 
2.53.0



