Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9C125178C;
	Tue, 29 Apr 2025 17:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948677; cv=none; b=V8BVPyrSmdGLm7loX45XFozysfF/KoHa1F3OdWUYPBZq33aeZ7LVwdIa2QNts4n+kztYqppjb6w1mzt3JjbbknzXw2mGDMeL/1G0xonbuSA/liagIcZl/E2Sh4pDodX4sR+PlSvyi6z1GsT1+bHLpGpWyJB75dKH6gLDAectBBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948677; c=relaxed/simple;
	bh=C5aY2Z0kGiqx0ixSDaC1iYJuOU0/Ty9oBA+6tDcPbrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8DJpVMDF6/Ef1zgqw2xln+dttxw+H+VeTSYqzjKUYsh/W5wbrNy5Lfu/UP4Sp0hbW/0xdp95DBkHEH02pK9HesJpJJm+eS91Bsu0yVWv4O8m4ojsaoilOxCaHlu9G4tep03Bb0aebkK/ZfQp3zGnJ1dU1XQIbyTm9w7bKRW42E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTArCkvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTArCkvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B53C4CEF0;
	Tue, 29 Apr 2025 17:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948676;
	bh=C5aY2Z0kGiqx0ixSDaC1iYJuOU0/Ty9oBA+6tDcPbrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTArCkvXC3ZTQ3JKY9iGTK54zHe+lJW731jm7EdvTdUy6dDLOl0L3quYwhWqmv19w
	 iDp4OQpJ/eUFLs3gilo8GaTAEP+O7A6XVI2ERcmGfs0GfZ3m8jJo1aQ4vF/FbJW6tA
	 W+8PVCtFRQSexdnwtdIkR4AfSqQ2j33YVCn/zigI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 078/373] mtd: Add check for devm_kcalloc()
Date: Tue, 29 Apr 2025 18:39:15 +0200
Message-ID: <20250429161126.362581300@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

commit 2aee30bb10d7bad0a60255059c9ce1b84cf0130e upstream.

Add a check for devm_kcalloc() to ensure successful allocation.

Fixes: 78c08247b9d3 ("mtd: Support kmsg dumper based on pstore/blk")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdpstore.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/mtdpstore.c
+++ b/drivers/mtd/mtdpstore.c
@@ -423,6 +423,9 @@ static void mtdpstore_notify_add(struct
 	longcnt = BITS_TO_LONGS(div_u64(mtd->size, mtd->erasesize));
 	cxt->badmap = kcalloc(longcnt, sizeof(long), GFP_KERNEL);
 
+	if (!cxt->rmmap || !cxt->usedmap || !cxt->badmap)
+		return;
+
 	/* just support dmesg right now */
 	cxt->dev.flags = PSTORE_FLAGS_DMESG;
 	cxt->dev.zone.read = mtdpstore_read;


