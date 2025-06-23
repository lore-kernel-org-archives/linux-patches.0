Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F2B70838;
	Mon, 23 Jun 2025 21:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713089; cv=none; b=ujX6bx5YpSh5F7yhtRltvmkCg+vQcrPhbizSjbSv3iMgzWQG2IJO1kFVDJAVGfeEjbwIT+DZNJOvmaaVOCF78KzQTVvPpScvwNWr/kHkKsC1aGpgy1RigG+3T/EG309c8wFn1wd2Xwq16x1hNBC1jeoA5uZNNKAUwB/9zkk5vfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713089; c=relaxed/simple;
	bh=qI+T6HAE3rQUQswgEb+dZVGTncuC/qyNUoIt4cSOYUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYMiprPdfr6sDFwD2FM1M7fERn7Hq5x1hE01BvXJnDtkG5ope+HXiVzHq88ZZ1iIHYJDdESiNOm+u4441bUcE3Gd2Xm1wLhFj1+gXUuU85rANoXtC70jupswIWjkMWRRuAmARxycEY/qa9KrK/QZLrB5w1wX4VqzKmXM3v+gr8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxVxonSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxVxonSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D7FC4CEEA;
	Mon, 23 Jun 2025 21:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713089;
	bh=qI+T6HAE3rQUQswgEb+dZVGTncuC/qyNUoIt4cSOYUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxVxonSwdjLZHwWEXst8wQ+c7eteDxqADSDWBDIxbVg1ui2/tfw9TvuFXJ6satF2p
	 FEkHS0nDpmsqkxIDnDrn/JJE9FuRZatjFh0mfQwDsVHLoUSmhKf0TbdyrigPLH5TD6
	 PhGsxoKR5Ab/JzQCnJcIvwGq2DzAN2RcWtK7568k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 045/414] media: i2c: ds90ub913: Fix returned fmt from .set_fmt()
Date: Mon, 23 Jun 2025 15:03:02 +0200
Message-ID: <20250623130643.165718409@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit ef205273132bdc9bcfa1540eef8105475a453300 upstream.

When setting the sink pad's stream format, set_fmt accidentally changes
the returned format's code to 'outcode', while the purpose is to only
use the 'outcode' for the propagated source stream format.

Fixes: c158d0d4ff15 ("media: i2c: add DS90UB913 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ds90ub913.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/ds90ub913.c
+++ b/drivers/media/i2c/ds90ub913.c
@@ -450,10 +450,10 @@ static int ub913_set_fmt(struct v4l2_sub
 	if (!fmt)
 		return -EINVAL;
 
-	format->format.code = finfo->outcode;
-
 	*fmt = format->format;
 
+	fmt->code = finfo->outcode;
+
 	return 0;
 }
 


