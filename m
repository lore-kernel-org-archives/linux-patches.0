Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E51347FF8;
	Fri, 21 Nov 2025 13:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733361; cv=none; b=tXbRuhRTfMWT8Sob14Ss0XZoGiz9PqZKj0rUcWShFj3ev6QTg9ekfIBtehApIomBwBbrI9+ZI+eV5Rce5zJMa+0D8ZWDjZdJCCoO3brI8RJRX+M70JU9WW/8uQH/oL/Iy8Fg22gr9xLtViIIYuM1io09GhmuyKhlplWomUH0mKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733361; c=relaxed/simple;
	bh=wfAZVjRTAFSTEsa4t7QB9IWD5Q0vkVa1kdSwkv5t7gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iegj6BBgs/ZUHl6BlQYvNb7cIStgiJYPzzN5/ku+RKq4TYNrn1WO1LQY3+2s1RntA2OGhQ2yczljZyR/vKI3TQ26NTz9A9Q/xLXgp+RCWcfjn+wtaV9pfXl6HaAEW99QK1LLzV841Ri7mQ+hGFhjhN624rPdEfE7l4yYM7xWGko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fyi1K7EF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fyi1K7EF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0B2C4CEF1;
	Fri, 21 Nov 2025 13:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733361;
	bh=wfAZVjRTAFSTEsa4t7QB9IWD5Q0vkVa1kdSwkv5t7gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fyi1K7EFnBFD2rJ/qTdnr+WeDIwPPXDZTyLWGSPks5onrOsi7rFR7NxXXhnzZgzAj
	 eiiZQBeb3UDp4FwPigY/rkKyDybKQwVoO3QJvqn+HDVFztfAmWtvPYfjiNaSS+qYN2
	 6mkhBB4sfFWTwEscaR1qu8t3U2aHkcFGO0svXngk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 442/529] acpi: Break out nesting for hmat_parse_locality()
Date: Fri, 21 Nov 2025 14:12:21 +0100
Message-ID: <20251121130246.739361300@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 79205651120620c2683f90c25ef3d2ac8e454026 ]

Refactor hmat_parse_locality() to break up the deep nesting of the
function.

Suggested-by: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/170319617537.2212653.10625501075519862509.stgit@djiang5-mobl3
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 214291cbaace ("acpi/hmat: Fix lockdep warning for hmem_register_resource()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa/hmat.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index 21722cbec324d..4cae2e84251a2 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -322,11 +322,28 @@ static __init void hmat_add_locality(struct acpi_hmat_locality *hmat_loc)
 	}
 }
 
+static __init void hmat_update_target(unsigned int tgt_pxm, unsigned int init_pxm,
+				      u8 mem_hier, u8 type, u32 value)
+{
+	struct memory_target *target = find_mem_target(tgt_pxm);
+
+	if (mem_hier != ACPI_HMAT_MEMORY)
+		return;
+
+	if (target && target->processor_pxm == init_pxm) {
+		hmat_update_target_access(target, type, value,
+					  NODE_ACCESS_CLASS_0);
+		/* If the node has a CPU, update access 1 */
+		if (node_state(pxm_to_node(init_pxm), N_CPU))
+			hmat_update_target_access(target, type, value,
+						  NODE_ACCESS_CLASS_1);
+	}
+}
+
 static __init int hmat_parse_locality(union acpi_subtable_headers *header,
 				      const unsigned long end)
 {
 	struct acpi_hmat_locality *hmat_loc = (void *)header;
-	struct memory_target *target;
 	unsigned int init, targ, total_size, ipds, tpds;
 	u32 *inits, *targs, value;
 	u16 *entries;
@@ -367,17 +384,8 @@ static __init int hmat_parse_locality(union acpi_subtable_headers *header,
 				inits[init], targs[targ], value,
 				hmat_data_type_suffix(type));
 
-			if (mem_hier == ACPI_HMAT_MEMORY) {
-				target = find_mem_target(targs[targ]);
-				if (target && target->processor_pxm == inits[init]) {
-					hmat_update_target_access(target, type, value,
-								  NODE_ACCESS_CLASS_0);
-					/* If the node has a CPU, update access 1 */
-					if (node_state(pxm_to_node(inits[init]), N_CPU))
-						hmat_update_target_access(target, type, value,
-									  NODE_ACCESS_CLASS_1);
-				}
-			}
+			hmat_update_target(targs[targ], inits[init],
+					   mem_hier, type, value);
 		}
 	}
 
-- 
2.51.0



