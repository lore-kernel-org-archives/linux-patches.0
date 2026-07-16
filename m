Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6B630AD05;
	Thu, 16 Jul 2026 14:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211197; cv=none; b=Z6GqLUKvGU7o5liWrUpS1HBJiwf8SJ4nJVBVwBA7xbZ8SUCJlELreoh8b5lP3bCCE2tJdJruXNkB1VRTQY7J/wuLf93bnBtJkfsCgPp3Vac/wB0pqv3Zdjm6fNUVyaskzXdLd5jmJvx7F2hDOGsDfKz2DQ6d5GEvpsTfRP8Ouzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211197; c=relaxed/simple;
	bh=cq2WqGInHLDCB/oITHzXBM1bs2LaxauQUSa4LqrKraU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiKNnmaARoBqTpHGet/rvrdzv4s5O2BgGy+jiGTVre69Dkg75h61Mxg1ZI1dUYM0+Yy/J5NtffdUU49kIPPV5l+n7Wia7KDYMbtu9k3SpmmpohQm/3T/ppf5q0jl++w7Xt8xkYxoVoakYd81StvKvYZJe18dprG+oRBLUyApv/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBeY0yAS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBeY0yAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E20A1F00A3A;
	Thu, 16 Jul 2026 14:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211196;
	bh=dT9aAPrecMY1vhztMFU6fL+59M3B7cHgqHOs3SZsosY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mBeY0yASPV6PFGhr/Ok4EzTotGvTDec6jRI2PB3MOApY+iRaklw/JdBk/erN4nkPD
	 aIac21MWuMOX0/1vMZSfV1G5zuBE/s07GD3+sM2Vl8XZz7+9LlLacMRwvW+IOS/UIO
	 fN6zLPuV85vmRJSRa3KJMMKOMd6Mx5FX0mHJz3p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Md Haris Iqbal <haris.iqbal@linux.dev>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 337/480] block: partitions: fix of_node refcount leak in of_partition()
Date: Thu, 16 Jul 2026 15:31:24 +0200
Message-ID: <20260716133052.102993207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 148cd4873115feb266c002d4d4618ea7f14342d9 upstream.

of_partition() calls of_node_get() on the parent device node at the
beginning of the function, storing the reference in 'partitions_np'.
This reference is leaked in two paths:

1. The compatibility check at the top of the function returns 0
   without releasing partitions_np when the node exists but is not
   "fixed-partitions" compatible.

2. The function returns 1 at the end after successfully processing
   all partitions without releasing partitions_np.

Fix both leaks by adding of_node_put(partitions_np) on each path.

Fixes: 2e3a191e89f9 ("block: add support for partition table defined in OF")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Md Haris Iqbal <haris.iqbal@linux.dev>
Link: https://patch.msgid.link/20260526102124.2283846-1-vulab@iscas.ac.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/partitions/of.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/block/partitions/of.c
+++ b/block/partitions/of.c
@@ -76,8 +76,10 @@ int of_partition(struct parsed_partition
 	struct device_node *partitions_np = of_node_get(ddev->of_node);
 
 	if (!partitions_np ||
-	    !of_device_is_compatible(partitions_np, "fixed-partitions"))
+	    !of_device_is_compatible(partitions_np, "fixed-partitions")) {
+		of_node_put(partitions_np);
 		return 0;
+	}
 
 	slot = 1;
 	/* Validate parition offset and size */
@@ -106,5 +108,6 @@ int of_partition(struct parsed_partition
 
 	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 
+	of_node_put(partitions_np);
 	return 1;
 }


