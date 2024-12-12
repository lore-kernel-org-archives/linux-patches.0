Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D1222966A;
	Thu, 12 Dec 2024 16:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020729; cv=none; b=iEgVuTBCDwt24XTcrkCm/xBsmyvHqe9sfYcUP73btLHO1IXP4//Kf9o8XsTOFmUjKCDaXkXn0v2tdwV9miCBP1zzjbqFSXreCKuMZadm5QvEWV/2ZEkkKNCLN5PSBqx/zaflrSXmkzMrqv9GB53sf4TFMsVOPy5o0o9OTtOaC6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020729; c=relaxed/simple;
	bh=I97xc/X5M7FEUdzuj389D2N0z0PDtcsV7INrjl3i2UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzHUUCjWda04++vz9XucCZrvEYK1kinyvijwx1rRfW6AOrgSAmJEHY3ze4xKNZkE10vAq/ToGMMdF5j3TLXKkrWmkKrAqhy0WMwRjbYAJx8IAluo4HqtDUT3sGUrwQaIIfCJTEc05Nq6FTghOKvbK47TxoGfnS4j4VMVdBz32Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwzCcOcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwzCcOcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11230C4CED0;
	Thu, 12 Dec 2024 16:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020729;
	bh=I97xc/X5M7FEUdzuj389D2N0z0PDtcsV7INrjl3i2UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwzCcOcwocXoND1d3HvyYfhYNagLLmSTZ7NXiwleOqutgzWPUq1mtChLctd0wQctb
	 62BOiy0aIys8fzGRtkTcCg5L7FB9g8+UTP2rGOe7N5Kr7shCBYAKv3kgqsQu/+lch+
	 VvKQo5DQXM9vrC5k4oraQmOCj4Z43AuNUsJ0jOI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 544/772] ethtool: Fix wrong mod state in case of verbose and no_mask bitset
Date: Thu, 12 Dec 2024 15:58:09 +0100
Message-ID: <20241212144412.445282332@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit 910c4788d6155b2202ec88273376cd7ecdc24f0a ]

A bitset without mask in a _SET request means we want exactly the bits in
the bitset to be set. This works correctly for compact format but when
verbose format is parsed, ethnl_update_bitset32_verbose() only sets the
bits present in the request bitset but does not clear the rest. The commit
6699170376ab ("ethtool: fix application of verbose no_mask bitset") fixes
this issue by clearing the whole target bitmap before we start iterating.
The solution proposed brought an issue with the behavior of the mod
variable. As the bitset is always cleared the old value will always
differ to the new value.

Fix it by adding a new function to compare bitmaps and a temporary variable
which save the state of the old bitmap.

Fixes: 6699170376ab ("ethtool: fix application of verbose no_mask bitset")
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20241202153358.1142095-1-kory.maincent@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/bitset.c | 48 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/bitset.c b/net/ethtool/bitset.c
index 0515d6604b3b9..f0883357d12e5 100644
--- a/net/ethtool/bitset.c
+++ b/net/ethtool/bitset.c
@@ -425,12 +425,32 @@ static int ethnl_parse_bit(unsigned int *index, bool *val, unsigned int nbits,
 	return 0;
 }
 
+/**
+ * ethnl_bitmap32_equal() - Compare two bitmaps
+ * @map1:  first bitmap
+ * @map2:  second bitmap
+ * @nbits: bit size to compare
+ *
+ * Return: true if first @nbits are equal, false if not
+ */
+static bool ethnl_bitmap32_equal(const u32 *map1, const u32 *map2,
+				 unsigned int nbits)
+{
+	if (memcmp(map1, map2, nbits / 32 * sizeof(u32)))
+		return false;
+	if (nbits % 32 == 0)
+		return true;
+	return !((map1[nbits / 32] ^ map2[nbits / 32]) &
+		 ethnl_lower_bits(nbits % 32));
+}
+
 static int
 ethnl_update_bitset32_verbose(u32 *bitmap, unsigned int nbits,
 			      const struct nlattr *attr, struct nlattr **tb,
 			      ethnl_string_array_t names,
 			      struct netlink_ext_ack *extack, bool *mod)
 {
+	u32 *saved_bitmap = NULL;
 	struct nlattr *bit_attr;
 	bool no_mask;
 	int rem;
@@ -448,8 +468,20 @@ ethnl_update_bitset32_verbose(u32 *bitmap, unsigned int nbits,
 	}
 
 	no_mask = tb[ETHTOOL_A_BITSET_NOMASK];
-	if (no_mask)
-		ethnl_bitmap32_clear(bitmap, 0, nbits, mod);
+	if (no_mask) {
+		unsigned int nwords = DIV_ROUND_UP(nbits, 32);
+		unsigned int nbytes = nwords * sizeof(u32);
+		bool dummy;
+
+		/* The bitmap size is only the size of the map part without
+		 * its mask part.
+		 */
+		saved_bitmap = kcalloc(nwords, sizeof(u32), GFP_KERNEL);
+		if (!saved_bitmap)
+			return -ENOMEM;
+		memcpy(saved_bitmap, bitmap, nbytes);
+		ethnl_bitmap32_clear(bitmap, 0, nbits, &dummy);
+	}
 
 	nla_for_each_nested(bit_attr, tb[ETHTOOL_A_BITSET_BITS], rem) {
 		bool old_val, new_val;
@@ -458,22 +490,30 @@ ethnl_update_bitset32_verbose(u32 *bitmap, unsigned int nbits,
 		if (nla_type(bit_attr) != ETHTOOL_A_BITSET_BITS_BIT) {
 			NL_SET_ERR_MSG_ATTR(extack, bit_attr,
 					    "only ETHTOOL_A_BITSET_BITS_BIT allowed in ETHTOOL_A_BITSET_BITS");
+			kfree(saved_bitmap);
 			return -EINVAL;
 		}
 		ret = ethnl_parse_bit(&idx, &new_val, nbits, bit_attr, no_mask,
 				      names, extack);
-		if (ret < 0)
+		if (ret < 0) {
+			kfree(saved_bitmap);
 			return ret;
+		}
 		old_val = bitmap[idx / 32] & ((u32)1 << (idx % 32));
 		if (new_val != old_val) {
 			if (new_val)
 				bitmap[idx / 32] |= ((u32)1 << (idx % 32));
 			else
 				bitmap[idx / 32] &= ~((u32)1 << (idx % 32));
-			*mod = true;
+			if (!no_mask)
+				*mod = true;
 		}
 	}
 
+	if (no_mask && !ethnl_bitmap32_equal(saved_bitmap, bitmap, nbits))
+		*mod = true;
+
+	kfree(saved_bitmap);
 	return 0;
 }
 
-- 
2.43.0



