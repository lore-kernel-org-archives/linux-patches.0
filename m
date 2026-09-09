Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A447576EBA;
	Wed,  9 Sep 2026 14:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964311; cv=none; b=ZNa1m1LnFrMf0I2P95HFZfXy9PUsU1wrQKpISzflwaFwaxbqFrlII+S0OZllog+Aow7Vcl8o72BnZ2JWFFyQzk2Bud8wI0T52YnMMsgQSxr0hPQIqzDqLum03fKYNHPsbnmuT9rjeuVYsBKdE+7HeMHRmn+gHN9u9dPCFm1myuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964311; c=relaxed/simple;
	bh=U3cykv88BFoOxTahAvpy5vopxOQTMYjjXIOhZZEKnBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGWljhGb+SZ0C5rSJzqrn0Et8DZAONlyYBGwj8dXeZr+BjTdVTqvbFXvoA4ohzesQmYtyKUj1vJEvZu2siGMbGoGGLqG8VduX2S2umw6t3Td402T8fXqYPCFYhNhjBaicycBzG2ZjAJFLzZSF6iUY/rtZsS9xruzsrcZwSjjdWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cM2YATkq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cM2YATkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6F21F00A3A;
	Wed,  9 Sep 2026 14:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964310;
	bh=RbSrHfzz7qJivLo7SqzEe67LhzHmAEQ3bN7MtQydRg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cM2YATkq8t0yzJqhKW6eeAUA1mSsBgykQ3+IhgmDa++cmdKnC9iFA8RRivfdDoDK3
	 FZyg2lbHlnbR99Jc7KGfzvI6Ccf29690467fumItOP294HhcVfL0calx5oxv11NEgp
	 mTi7qtW23LgjZvoxGl8g0g8nlPICEV3cvWHXoI2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Barzilai <amit.barzilai22@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 6.18 379/583] drm/ssd130x: fix column and row end address in partial updates in ssd133x
Date: Wed,  9 Sep 2026 15:41:04 +0200
Message-ID: <20260909134251.147189532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Amit Barzilai <amit.barzilai22@gmail.com>

commit b7fcb70162acd7f15ed20bc64a14c150db34256f upstream.

On partial screen updates, SSD133X controllers expect to get the
rectangle addresses as arguments of the "Set Column Address" and "Set
Row Address" commands. Each command expects the start address and end
address of the row/column in absolute format, however the end
addresses were being sent in a relative format (relative to the start
address).

The relative end addresses work only when the start address is 0. In
those situations, there is no value difference between relative and
absolute addresses.

Fixes: b4299c936d8fd ("drm/ssd130x: Add support for the SSD133x OLED controller family")
Cc: stable@vger.kernel.org
Signed-off-by: Amit Barzilai <amit.barzilai22@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patch.msgid.link/20260622122604.32500-4-amit.barzilai22@gmail.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/solomon/ssd130x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -915,12 +915,12 @@ static int ssd133x_update_rect(struct ss
 	 */
 
 	/* Set column start and end */
-	ret = ssd130x_write_cmd(ssd130x, 3, SSD133X_SET_COL_RANGE, x, columns - 1);
+	ret = ssd130x_write_cmd(ssd130x, 3, SSD133X_SET_COL_RANGE, x, x + columns - 1);
 	if (ret < 0)
 		return ret;
 
 	/* Set row start and end */
-	ret = ssd130x_write_cmd(ssd130x, 3, SSD133X_SET_ROW_RANGE, y, rows - 1);
+	ret = ssd130x_write_cmd(ssd130x, 3, SSD133X_SET_ROW_RANGE, y, y + rows - 1);
 	if (ret < 0)
 		return ret;
 


