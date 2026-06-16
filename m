Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6349A364024;
	Tue, 16 Jun 2026 15:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624905; cv=none; b=d+oXvNnxxsZB3n3l5bKIbJ7mArofrTrhIQis9X+KwahTbkSkiL/8JPNmkttCYFEu1sLvTQV8nxlUGtwjbZb5FhfYe518sXDUkwLOeCql+gxlF2g5xqOzQPS7H5RQqGULXgo0efC+cQbUcyObaEetPTTNwfrYw0d0PepMjraRR4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624905; c=relaxed/simple;
	bh=pl8IQd2jdpZsvpzEI4vbDDtGSv9P7mkskH3/nq9Db0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxWYmSAyJy2dvt8wG+xszYBbJ8enbXNOoLWwmYq20vj9+GQ8V2G7SVDbdwM+M/wIHR2zYVgYwCxsVkTMS/I7DbDKcu2F8uv6kp06cUWUTAFMk4wABFWNxx2zb2/ykrBfFJp5+t3STfB1eMqaFRsH1XfNeOyBWctl0XPQT4UMTT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2oJgk0i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2oJgk0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B4E1F000E9;
	Tue, 16 Jun 2026 15:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624904;
	bh=DNXXNweTyflMGnczeEb8XYJY2NZp5XbpepzUCL+tYGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I2oJgk0insBBiYZM9eTsQ1p6aVNTuBGaJyOckXEu8NBvXShDn3LHyYhldSfrX2uEu
	 O/L94Pi4bSnsSfSu9m4IIkcq8+sdLYVLTR+V8NG1/i9gZM1byDgPQwrPnMBNhrzXV/
	 qOL6ND9MSc+iWNscIatKz4E8GNKc2HXsiX0rZkBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robertus Diawan Chris <robertusdchris@gmail.com>,
	Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 016/325] tee: qcomtee: add missing va_end in early return qcomtee_object_user_init()
Date: Tue, 16 Jun 2026 20:26:52 +0530
Message-ID: <20260616145058.609905017@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
index ecd04403591cf9..10717434275b1b 100644
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



