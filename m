Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3052C1494C5;
	Thu, 15 Aug 2024 13:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729827; cv=none; b=sw6nd8DwwIhkqlTrrnMVLU6mdy8y+VWTx2L2M/fjZBo6C7ywwjwMHO+2cM0nrH3zGw2nPn9WQPfc///iNo5MXgfVKnmVimrkEf+ZwlOSXSaukYKKqMxrLHDWTCQtMxb5MzJQPxRmjbEiR8KiIXy+BoX5rxXAUdHDIUzgXLNYsho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729827; c=relaxed/simple;
	bh=aFK+kwT8waW1+5qvRiA1Xd5i56FLKCiCVmPfJyfRhWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGSYJ1RuBLXQ/oECK7Pxt3jL9/LFGRpuBrBZ5XzkJGB6GFsQ+4nXCV4KldF61+LsiQqz3JooiXLDz26CyZzE0qOdhviw/jzZDn56pWfGQ4SQVy+NyCnheeAU7UEMVJ27h3ro2drl7zvoXMnZ+PDyr5D6OpXVYV2R/DVuNz+z4Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/m0icTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/m0icTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2A1C32786;
	Thu, 15 Aug 2024 13:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729827;
	bh=aFK+kwT8waW1+5qvRiA1Xd5i56FLKCiCVmPfJyfRhWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/m0icTmztDj0qzyu6hT7HtO+DTcRck+Fo/1SMPR1sE7QQ416yCww2a7s2hMlXXl4
	 PnnpWOKEJGpK+URYQqQrwY5rcWPDVWiZ2LCo/Xut+o3k2XSB7MAZE0kYdezUwjGEAx
	 dHgY7oB3hcefxJsvfHbVsdojN/KZvRtnq3wLfS1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 5.15 219/484] devres: Fix devm_krealloc() wasting memory
Date: Thu, 15 Aug 2024 15:21:17 +0200
Message-ID: <20240815131949.871350017@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit c884e3249f753dcef7a2b2023541ac1dc46b318e upstream.

Driver API devm_krealloc() calls alloc_dr() with wrong argument
@total_new_size, so causes more memory to be allocated than required
fix this memory waste by using @new_size as the argument for alloc_dr().

Fixes: f82485722e5d ("devres: provide devm_krealloc()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/1719931914-19035-2-git-send-email-quic_zijuhu@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/devres.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -890,9 +890,12 @@ void *devm_krealloc(struct device *dev,
 	/*
 	 * Otherwise: allocate new, larger chunk. We need to allocate before
 	 * taking the lock as most probably the caller uses GFP_KERNEL.
+	 * alloc_dr() will call check_dr_size() to reserve extra memory
+	 * for struct devres automatically, so size @new_size user request
+	 * is delivered to it directly as devm_kmalloc() does.
 	 */
 	new_dr = alloc_dr(devm_kmalloc_release,
-			  total_new_size, gfp, dev_to_node(dev));
+			  new_size, gfp, dev_to_node(dev));
 	if (!new_dr)
 		return NULL;
 


