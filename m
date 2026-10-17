Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAF938654F;
	Sat, 17 Oct 2026 16:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254172; cv=none; b=ZbFi5FSKq/W9tOhNQZSjixq/gqpkJKFyEfbPMtkYK9kziOHv8fgos4dp8lOSgbhV3bnuvl/aOjuieSXMEDkYlYMi17MHEUlv1ljyLh79DG9Q/5q+uwY+eYAlCahuWs24fbiKTBuTFpUJ2waT9up6lSSggJx5TRqxvL8K13JY+1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254172; c=relaxed/simple;
	bh=RVDXm+23QhajgQcS++d9Sylhb5ZsBTRdEVtoU/HSkw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhMDpbWwJF/aLtpwDCvdR/p5yrMmbNxUCYg0EFyvcLJOdZCFTswI+If47G+ryArj9a3/rfuI95h7SPdXDVt9Xqm2srZxiTSfvLb98mDtX8qk6Uc29fHItdto6pvGVGMpVwf4NzFpIoqev3Ikn0shvWEHNKxkeVS5asHgluTvAq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lr3xSOKs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lr3xSOKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06B41F000C4;
	Sat, 17 Oct 2026 16:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254171;
	bh=Jw/7cDiJ/oF36WhI+lir0qY2B+mcPWcMS4WsRbBbp0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lr3xSOKsLTCE3COzgzQ7mDqUqIj08oxCZ+2RJPEwiTAyL06ec3UnG6JCWo0dvQnI3
	 gh8g5ae6ZcG0hcZ81S0n2R+c7yJIF6tb/q+84jg1W3hmpj7W6dd36NYPjELruQx5cD
	 91tjlGhoVKHeAlYKh/mfFGbXUrG1t7xahz9n90hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 359/869] netfilter: x_tables: allow initial table replace without emitting audit log message
Date: Sat, 17 Oct 2026 17:53:20 +0200
Message-ID: <20261017160046.310476558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index efe7b7d71e7f7..5c7dcb64cf0f9 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1404,11 +1404,9 @@ struct xt_counters *xt_counters_alloc(unsigned int counters)
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
@@ -1463,10 +1461,23 @@ xt_replace_table(struct xt_table *table,
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



