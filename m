Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2346E423EA3;
	Thu, 16 Jul 2026 13:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209874; cv=none; b=CmRnHR5Yl5soEN3vsUylQs8akvvUUlhdia0PkvK0G+L+3VR+CQvxIvDOiLZBzI6687C6VkeAazkul3KZqa8EYzV5KJBsosaxMh6Vos9WS9I2zwf2Efx0OpFPfcZTsp4PfkLQzaTmeh3wKDTEBFA1EFQBjh7vdouKtAVrWajTyC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209874; c=relaxed/simple;
	bh=udLRSSqkldrhpBBOZVF7VdA86E8Pct1O8hfMWgwd1tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFsImJBHkYyZPH354/3k2s1HnO6Ymw8aJt7DYPRdA1Gm+TwlAb8yU3Mfkm5TfVT/HC/fjeqPLwrRxKsQYzUhizQMaG5dwm5b5xrFepyGkoQVSnpaysC44Xr7E9UIKwG0JxLyZ0x3sN8SkxyzHmeTtT2S6pHBW7QJP7fODU0hggk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ckQourh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ckQourh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F081F000E9;
	Thu, 16 Jul 2026 13:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209873;
	bh=UtqsXDlVWIFkTUWaQdy0HUVOZ8yy8VQsPbkHNf4I5+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ckQourhZl7uwOXvtYeO1g7KbZQJBs/fR1uoBnSN4gP3SI0LXlH0W6zghKy7ZqOx/
	 zd8KC+aoF7BUNIDl/5jYaiToZZgKCOh5CYdozZK0Faav+6oK0B7R4QhI/BXkiFvbTZ
	 WPhHsmSeaBDZ0x7hUyFZ/Ay5G4QV7vNlS3YYjuQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Md Haris Iqbal <haris.iqbal@linux.dev>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 349/518] block: partitions: fix of_node refcount leak in of_partition()
Date: Thu, 16 Jul 2026 15:30:17 +0200
Message-ID: <20260716133055.458473652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -74,8 +74,10 @@ int of_partition(struct parsed_partition
 	struct device_node *partitions_np = of_node_get(ddev->of_node);
 
 	if (!partitions_np ||
-	    !of_device_is_compatible(partitions_np, "fixed-partitions"))
+	    !of_device_is_compatible(partitions_np, "fixed-partitions")) {
+		of_node_put(partitions_np);
 		return 0;
+	}
 
 	slot = 1;
 	/* Validate parition offset and size */
@@ -104,5 +106,6 @@ int of_partition(struct parsed_partition
 
 	seq_buf_puts(&state->pp_buf, "\n");
 
+	of_node_put(partitions_np);
 	return 1;
 }


