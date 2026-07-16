Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5BF27732;
	Thu, 16 Jul 2026 14:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211738; cv=none; b=qTZP9ztjXhk+FmP+3vtLvJv0FkcqcN5Aalda5h9rrGG7nc7V4Msb1tHhKwXFpQmOijMtEEP/RFRjxJ3oN+Fp5eQuD3GcIC6Vus/Xt9RneUfa85Sonf5L2fpCegkgii0+HsQaRQzbpLiCJSGX7L3kXaqjYWQVyIaDfiQb86AnY8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211738; c=relaxed/simple;
	bh=rTastxhJf6dnSeISMGPdgg15du3D7qsbkZX6yB7rKLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTjwXl1aYQxXzQjLRm0Melv5+KVeV8qGPIooINNbRCQdOYesGhKsJDTuWjN37QN/IFp5m/srdi2IqTHpS9Ia904SLi658WAdIn72QAAcgnAz+geQZ0EClBTE+IKNWZV9Bv+e7W73fSmL/LYY/gwJr9QcQbHMDeNj0RfRJUv7gCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMI/0bKc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMI/0bKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D398C1F000E9;
	Thu, 16 Jul 2026 14:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211737;
	bh=G7ManZKfHST6Ho8nFJBe0oPp0rC6FAPhLYmFdVIhJmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rMI/0bKcVl/Obc7fF6WXm3DmegKy50cj7230Ek9R5+0ev4+sADfrduYjThMPItulz
	 nBtz5uaqWXypEWTncuxTWreY+9KBGRm/oxStp7l04bZ1jYj7mkOvB2OwwsT2cmkBW5
	 HM1fYLSfbzowujN9qpKpIppk3gkZsr5nAyRt0SdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 062/349] iio: light: gp2ap002: fix runtime PM leak on read error
Date: Thu, 16 Jul 2026 15:29:56 +0200
Message-ID: <20260716133034.714717817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biren Pandya <birenpandya@gmail.com>

commit 38b72267b7e22768a1f26d9935de4e1752a1dc85 upstream.

gp2ap002_read_raw() calls pm_runtime_get_sync() before reading the
lux value, but if gp2ap002_get_lux() fails, it returns directly. This
skips the pm_runtime_put_autosuspend() call at the "out" label,
permanently leaking a runtime PM reference and preventing the device
from autosuspending.

Replace the direct return with a "goto out" to ensure the reference
is properly dropped on the error path.

Fixes: f6dbf83c17cb ("iio: light: gp2ap002: Take runtime PM reference on light read")
Signed-off-by: Biren Pandya <birenpandya@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/gp2ap002.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/gp2ap002.c
+++ b/drivers/iio/light/gp2ap002.c
@@ -258,7 +258,7 @@ static int gp2ap002_read_raw(struct iio_
 		case IIO_LIGHT:
 			ret = gp2ap002_get_lux(gp2ap002);
 			if (ret < 0)
-				return ret;
+				goto out;
 			*val = ret;
 			ret = IIO_VAL_INT;
 			goto out;


