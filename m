Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C1935C6A0;
	Tue, 21 Jul 2026 21:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668146; cv=none; b=au2yuzJfecbjRoenlLEx2bc2lqDkAAoRVwj58i8rgG/nEXljqzRWeBI8EAJVz570OZGqLV3pKWcMr32WBC8VNo0M2ZdX/YH0pt4Rg400zMM94asUjm8po/jI6Ud06Es3MKSKxSAXCjcclHgsWLP3bpIdRYRbZLlmoJG/rkalTzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668146; c=relaxed/simple;
	bh=o4fSAzBVMst5BWdp/sd7blAZDetdNw2KC6fY3YBJZn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsLdBzA/r37RTZnXi/L82/yk4w0RV1SQiURQ2wvzSWw89IMLza82zCZb7M5M16mkz23ARwFaz+ixtjUbqZmPrbELPVVtNNeC56bibj/BwyJRFCf2g9EmzzXwAkJU60z2Nqlef8gzBkaAddy1GW82oytWvivT/Ng6HTF0/TSPhnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uutsqZHf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uutsqZHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6973A1F000E9;
	Tue, 21 Jul 2026 21:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668144;
	bh=ZSzn/7UOU8VLCdo28Cr7WtQWibnYyWBGc7QnELs1Yto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uutsqZHflWZ3XBgbmahkt60sc+ocib4XfRmSRxJB6XdKNRC5lmL7Rdw7IaP2LQGwG
	 T9/cMKWIgLP0hn7b8VbcZFWlDGxcOAcSti9MiXVFdMeufFVIN5wAgwFcfZD0sX20gU
	 W3ybiMuhUObI08DvifJQTg6tylE5AZKrntcabVQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 0066/1067] iio: light: gp2ap002: fix runtime PM leak on read error
Date: Tue, 21 Jul 2026 17:11:07 +0200
Message-ID: <20260721152426.046247658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


