Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B002248A5;
	Mon, 13 Oct 2025 14:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366882; cv=none; b=j4LRl7L/ncFvc7N7uthTtKg2E4+aYJCw3rVBYT5/LQUzkiKh4PyS2ngrQeFlCvfFdKBFLiJ12QjgnG9zpEgNL9QYBtmECyKwFwFnJ48kQVw4kQKGqMu7wDbUBzt3yevkaqLozn3BjIaloisgMlQaRzULL+PXdW+f/FfgHkid08E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366882; c=relaxed/simple;
	bh=+Ajfpe6KLtdO+Sk0ycGZX3Fp41+iPghzmLy/5fv34Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9/xSxiW3Qo2tnM6y9Pb/Nbg8UDiNE2clSJOR08CgxS6Aqx+8sevGMRzKgm6cYukWT7uBNh8pFSYMdXTC0BgJQC3IFh8SfTH9exlLwBSvu7oRoZm+JAQqTti7XglLC0ilMq0uJVEJ2j+fbPW21eGGeiLwU/YH/Fcva3ITuiOECk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yP2lYGpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yP2lYGpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA8DC4CEE7;
	Mon, 13 Oct 2025 14:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366882;
	bh=+Ajfpe6KLtdO+Sk0ycGZX3Fp41+iPghzmLy/5fv34Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yP2lYGpjBO01wIBWL2dHYWpHul2AVWbsEGfDUsQJv3GyJH+UgfaXuYrceQ6wtgTNu
	 7kxWoaicKoj1Fx2XA4oSFh6mLHR/Kw5X5dZD7zNuy/O/oxF6tOYydg+MIpi9lFDKkw
	 U136+ZFvPrEWfRhK2ncK1Fkk2pXbsf6H43baumGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Pierre Gondois <pierre.gondois@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Wen Yang <wen.yang@linux.dev>
Subject: [PATCH 6.1 005/196] cacheinfo: Check cache-unified property to count cache leaves
Date: Mon, 13 Oct 2025 16:42:58 +0200
Message-ID: <20251013144314.754511334@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre Gondois <pierre.gondois@arm.com>

commit de0df442ee49cb1f6ee58f3fec5dcb5e5eb70aab upstream.

The DeviceTree Specification v0.3 specifies that the cache node
'[d-|i-|]cache-size' property is required. The 'cache-unified'
property is specifies whether the cache level is separate
or unified.

If the cache-size property is missing, no cache leaves is accounted.
This can lead to a 'BUG: KASAN: slab-out-of-bounds' [1] bug.

Check 'cache-unified' property and always account for at least
one cache leaf when parsing the device tree.

[1] https://lore.kernel.org/all/0f19cb3f-d6cf-4032-66d2-dedc9d09a0e3@linaro.org/

Reported-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Tested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230104183033.755668-4-pierre.gondois@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/cacheinfo.c |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -224,12 +224,9 @@ static int cache_setup_of_node(unsigned
 	return 0;
 }
 
-int init_of_cache_level(unsigned int cpu)
+static int of_count_cache_leaves(struct device_node *np)
 {
-	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
-	struct device_node *np = of_cpu_device_node_get(cpu);
-	struct device_node *prev = NULL;
-	unsigned int levels = 0, leaves = 0, level;
+	unsigned int leaves = 0;
 
 	if (of_property_read_bool(np, "cache-size"))
 		++leaves;
@@ -237,6 +234,28 @@ int init_of_cache_level(unsigned int cpu
 		++leaves;
 	if (of_property_read_bool(np, "d-cache-size"))
 		++leaves;
+
+	if (!leaves) {
+		/* The '[i-|d-|]cache-size' property is required, but
+		 * if absent, fallback on the 'cache-unified' property.
+		 */
+		if (of_property_read_bool(np, "cache-unified"))
+			return 1;
+		else
+			return 2;
+	}
+
+	return leaves;
+}
+
+int init_of_cache_level(unsigned int cpu)
+{
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	struct device_node *np = of_cpu_device_node_get(cpu);
+	struct device_node *prev = NULL;
+	unsigned int levels = 0, leaves, level;
+
+	leaves = of_count_cache_leaves(np);
 	if (leaves > 0)
 		levels = 1;
 
@@ -250,12 +269,8 @@ int init_of_cache_level(unsigned int cpu
 			goto err_out;
 		if (level <= levels)
 			goto err_out;
-		if (of_property_read_bool(np, "cache-size"))
-			++leaves;
-		if (of_property_read_bool(np, "i-cache-size"))
-			++leaves;
-		if (of_property_read_bool(np, "d-cache-size"))
-			++leaves;
+
+		leaves += of_count_cache_leaves(np);
 		levels = level;
 	}
 


