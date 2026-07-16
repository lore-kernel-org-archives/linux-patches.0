Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1493319601;
	Thu, 16 Jul 2026 14:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210522; cv=none; b=bRRDwY26KmMnUiRvTmI1iDHZyBRUW1eNmUDoWTz4gAf4iEgr5wkZygXVDfTlb7SB4ns68QcoyEjmKYeuSrB0dPBS+ZNuB4dKsNi91VCSR91fGVwX7UFvMsZ2k4qGQq/D/WU59YpsOnZAXfHJwWK8F7GwdWpDdjReRTQsKuueAaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210522; c=relaxed/simple;
	bh=S/sIPI/1hHQ+KECDgrN1ygBvbncDz/NgU1G6WdwyV6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DaKgHdosdxMm7zApnik0ayhlNAntZ630EtTI71J/A3VSAStBOP0m4KjDT1gSYgsAWiBYiiQB6oMCxwgR1INmrCW6sLcgw3qFYfEmyVOzr1Pt9XHjXryxvLRmRHw40Tc1OHVnShWlgij1RXzhvO5b55YtMpqBvrcWP9jW8BTqwuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NM58m7v5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NM58m7v5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0951F00A3A;
	Thu, 16 Jul 2026 14:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210521;
	bh=drnXFybD0q/cYUakWmi3iE/276Bo94d5kjuldXnZHh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NM58m7v5g0YkuR9OeB/FBmcNkoqH3i6Pyr+AHiSr85hy9zTIMID9lkMNjiXZcrj91
	 xZ5MfXl3C/uQFf8hpbHYqgvLfQZxQJIGlZmUnZDl36HEY2ebb+grI+oGbnl42jAbvt
	 0DZZrhL0dz/xs/7P6e5LOs33Ky/fQr9wh7Obzdgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 078/480] iio: light: gp2ap002: fix runtime PM leak on read error
Date: Thu, 16 Jul 2026 15:27:05 +0200
Message-ID: <20260716133046.400265641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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


