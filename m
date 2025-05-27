Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AC227D784;
	Tue, 27 May 2025 17:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366747; cv=none; b=uw++dq2+ui/e417ev7vnK3u7UYVD5nnWgftQwsYxIT1Mm0Q1Vi4H+DpHzrMND6mIoecEQrwhVw8L9l0v6l7g1DaMHPAQf+CPb2173OHD3NacUSQdrzYpYq2eSw9LJUo3hXF7QMrQ8LmFyOah5+g0yIW77Cc8QYvKrn+DrrgyLlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366747; c=relaxed/simple;
	bh=vGCz+FmqiNK7qK+eLGTazZeFaPAag0QR0BUTIjuMG6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JED0xTSEZeWqEtf1oC+WIQQXpRYHCq5YhCogt0BamI4OPHbK1d5BVd/XfITnlh69o2Zg1her2JVqG/rjFpFEBCyhF0LkOiG2sT/pp8H8D97K/2Q0rccr+jqTwHMr/l3DP2IqHby8DuAafif5wuzPfydUk7x0h1DtZmYd1d6AIFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPI73VJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPI73VJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C8DC4CEE9;
	Tue, 27 May 2025 17:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366747;
	bh=vGCz+FmqiNK7qK+eLGTazZeFaPAag0QR0BUTIjuMG6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPI73VJ6PCIpawBEEERgJGEcXm6j5UlfNM64aQ/8oQiQ40ObxUBBTZhmS1rPzByuL
	 sQbpefeIC8Z+WYfqAB/BOenLGQPtj30SAhqwzxmpkirL9ISGXFh/365zdv0pPiQiVa
	 Rmq2WHPAIblgpQS7BV0tmp0y3i99N0AgDKxPYOAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Brendan Jackman <jackmanb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 168/783] objtool: Fix error handling inconsistencies in check()
Date: Tue, 27 May 2025 18:19:25 +0200
Message-ID: <20250527162520.011372654@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit b745962cb97569aad026806bb0740663cf813147 ]

Make sure all fatal errors are funneled through the 'out' label with a
negative ret.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Brendan Jackman <jackmanb@google.com>
Link: https://lore.kernel.org/r/0f49d6a27a080b4012e84e6df1e23097f44cc082.1741975349.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 522ae26f581be..70f5b3fa587c5 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4633,8 +4633,10 @@ int check(struct objtool_file *file)
 	init_cfi_state(&force_undefined_cfi);
 	force_undefined_cfi.force_undefined = true;
 
-	if (!cfi_hash_alloc(1UL << (file->elf->symbol_bits - 3)))
+	if (!cfi_hash_alloc(1UL << (file->elf->symbol_bits - 3))) {
+		ret = -1;
 		goto out;
+	}
 
 	cfi_hash_add(&init_cfi);
 	cfi_hash_add(&func_cfi);
@@ -4651,7 +4653,7 @@ int check(struct objtool_file *file)
 	if (opts.retpoline) {
 		ret = validate_retpoline(file);
 		if (ret < 0)
-			return ret;
+			goto out;
 		warnings += ret;
 	}
 
@@ -4687,7 +4689,7 @@ int check(struct objtool_file *file)
 		 */
 		ret = validate_unrets(file);
 		if (ret < 0)
-			return ret;
+			goto out;
 		warnings += ret;
 	}
 
@@ -4750,7 +4752,7 @@ int check(struct objtool_file *file)
 	if (opts.prefix) {
 		ret = add_prefix_symbols(file);
 		if (ret < 0)
-			return ret;
+			goto out;
 		warnings += ret;
 	}
 
-- 
2.39.5



