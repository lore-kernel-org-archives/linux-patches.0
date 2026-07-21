Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6966E37473A;
	Tue, 21 Jul 2026 21:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670946; cv=none; b=NPA2LfGlCdvX5W0sRJ9QK1Yc8G5SE4pscjNTyEe7Hrl11voTurQVNrd1FlugK/9/vs8MDPJH6jI0Rsp/qBfRDLDydw2Z42MkD29ZNUf1sThohUNenwNNUv2i2eaZ+57BiecygxRx+Idxbdqns6qaXuka41hrICX9CXXY8qGWwF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670946; c=relaxed/simple;
	bh=jOd/NPDAWctS0EMG1hqt6szNIgt35g1OgRZQ3vIoWJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlA3ZYhUL0XBk4uIJ/DMiXnAjWMkFuW7ea/H/B/FwAbs4WcQmSoFccy4yrEVFDR+CLOpg0Qju+IdM+G0RFhfR69LQ3TG4I3mQ0Ap4wwJNjagjNohDeEujCGsw52DXgUD9wzd5yI9QIZtdwkFKJ7fasN0+yur3WDj5wAH0UXzcQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwVoi3xn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwVoi3xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF351F000E9;
	Tue, 21 Jul 2026 21:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670945;
	bh=iHJkucmejOgfQFFwu+vrs2y64vTI2f76a7pjOfR3cUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwVoi3xn+Y+GTOXwaemGP+mHeSXgbwybalFQMIzojKJt3qJyP3Rujs+y+LCam0BRs
	 Em/YKyBAsL2+RIHo+xLHkwVrjSXDvCAjx4v+gEi3tbOsG0DxQd1WQZbNi6a4cSNkge
	 10NG205ZqOtdzBqL9VACRbSRdjh+3V8v9KRwggaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.15 060/843] iio: light: gp2ap002: fix runtime PM leak on read error
Date: Tue, 21 Jul 2026 17:14:55 +0200
Message-ID: <20260721152407.337158802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


