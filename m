Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEA842EEBB;
	Tue, 16 Jun 2026 15:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622828; cv=none; b=ZmBMkekn7XQdBl2HRvp4hnPtWpHR4Wy1E1ofL26oHLv7Ea6+pm9+xhq1vh2F88nIY2fMPDRPPILPXfwRxyqhdnNtAH3VN3fZLIzHB6KgNm/F5p+EtOhKYWqMw2dxpqBpZN4G0pLJYoU1vZ5n4sOi5mGeX11VfRbsok6MBDFOhuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622828; c=relaxed/simple;
	bh=80s/HkZm82zk4EO/J7RQU+kw606rbC5agg0Dl0sM5No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Noi38Mv0xDJuC2rToRdKHgZABE21pY6R4TOlIqKhQAySSVHoyUdwXV3Tbdauqfl6b7RAWqESzoTPkGMD0PPTZV0QiFTLSkYqXRlLZt8JcNRBTzF7W2RnD7fQaxgHgaL33/zJCN59ACFwHGcViPhvdqx/OncvxENN20atjTIDpmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBDpTgjV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBDpTgjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A1A1F000E9;
	Tue, 16 Jun 2026 15:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622826;
	bh=KDYEn3vMR/FR+gtTinRmiUoxkceYNvP4BkyIG3S+Rpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBDpTgjVYKg7XUdSOyw7LFapsKWW0975lMm+hUexesSVB76bqF9XzGwIjlME10PTW
	 u02ueeuaKBF+n29syVLDPVAh4QGpYBOhnQXmXata98IZlaoBpql4nG9YZTgeo8ldF+
	 JBloorZ0mJxA8gkUomGQJv1Jzf+W6yMX31EnQnXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robertus Diawan Chris <robertusdchris@gmail.com>,
	Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 013/378] tee: qcomtee: add missing va_end in early return qcomtee_object_user_init()
Date: Tue, 16 Jun 2026 20:24:04 +0530
Message-ID: <20260616145110.499431827@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robertus Diawan Chris <robertusdchris@gmail.com>

[ Upstream commit 471c18323dfdfe7844e193b896a9267ae23a1026 ]

qcomtee_object_user_init() is a variadic function and when the function
return because there's no dispatch callback in QCOMTEE_OBJECT_TYPE_CB
case, there's no va_end to cleanup "ap" object initialized by va_start
and that can cause undefined behavior. So make sure to use va_end before
returning the error code when there's no dispatch callback.

This is reported by Coverity Scan as "Missing varargs init or cleanup".

Fixes: d6e290837e50 ("tee: add Qualcomm TEE driver")
Signed-off-by: Robertus Diawan Chris <robertusdchris@gmail.com>
Reviewed-by: Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/qcomtee/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tee/qcomtee/core.c b/drivers/tee/qcomtee/core.c
index b1cb50e434f00a..60fe3b5776e36d 100644
--- a/drivers/tee/qcomtee/core.c
+++ b/drivers/tee/qcomtee/core.c
@@ -306,8 +306,10 @@ int qcomtee_object_user_init(struct qcomtee_object *object,
 		break;
 	case QCOMTEE_OBJECT_TYPE_CB:
 		object->ops = ops;
-		if (!object->ops->dispatch)
-			return -EINVAL;
+		if (!object->ops->dispatch) {
+			ret = -EINVAL;
+			break;
+		}
 
 		/* If failed, "no-name". */
 		object->name = kvasprintf_const(GFP_KERNEL, fmt, ap);
-- 
2.53.0



