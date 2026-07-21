Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362D81D7E5C;
	Tue, 21 Jul 2026 20:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665001; cv=none; b=Lnb2rqKxlwZ0MzUd8yrHwIIznfG375aLqkbkLADEzgkWhXcILL0arlVXCn9Y2ix2FQX9RirnaEiQVOJVngY7WAUc5KCwG1RJ+Dq80Fzybwv3gf8mPwQMpDGxmduWgNgQCnCFmyJvPBKKxU3w26D61vObj9vAuq+5rj6eIc+jxXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665001; c=relaxed/simple;
	bh=bscuul+y3+Vabk0gWoMSTXN4eBLdmy0GNsIiSKPWBNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjA6UYvsAlzKHhMlKlKLgxyA0OK+j9KyxferKMsW821wtWIvUkhjXtFim9UpxrANcNZ0KyjfEgEncdvvBL9x+a2W3RceVu7FR8zDhYeafhlHRwCk+KdikpOYDHvS5lGWC490G7VoCW4XNw4s7VLYHQ9paS+vGUIbJqdgTqrf+NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DirkwsDP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DirkwsDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAB11F00A3A;
	Tue, 21 Jul 2026 20:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665000;
	bh=5qnpsd6d88P9YybfqaEimQfBBAC2YVtCSDK+2GrI39k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DirkwsDPqQhW9FcmfMdTxo74kbA4jdQU/+a2Gp/hcApa4dFshbUzcwpFkjx9cMbOo
	 vTWkukuKkL3A5MR2ftkAn1xPSrOTQc29RiFo5y79ONUV7HN42gWRKCUIy7uuUxNh1m
	 i9DXEZwEGsyu2rDlZg1PavC9vcIvUgcONwdHAOi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 0096/1266] iio: light: gp2ap002: fix runtime PM leak on read error
Date: Tue, 21 Jul 2026 17:08:53 +0200
Message-ID: <20260721152443.952548011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


