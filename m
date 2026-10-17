Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B47B255E43;
	Sat, 17 Oct 2026 17:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256914; cv=none; b=pBXK59dURxIudSYQ+GvRMMGqdbTLSAKLPOR3qknZMcZg12uXVFPwaf+gLR4x1a6V9SPAcAvgDMUGKQkozGxJ5XnyASK++E80AJZoxnSdcHvSGnIoYTpIj9sY0JsSnNrzlAZTWybwPMl65DdM+VrqQujISq2avgGyHFn0hCCr840=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256914; c=relaxed/simple;
	bh=6xYPXs21jwGmH5alC33g0sTDUezK8pQRP3NvzDcdtoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNFXNq2POEuYH/gihXQBHZXx3MjXfHkw4qnkVYNWYgUC64vmNFXL6sYgSIuwa0Bqltv5s1l+Rr2hp/Tk66GmCylxM9Y7JlwoRPmomgXC2qPIcbJcCfe5CaKRHZ7Uhxhofzn6W/dfIUAaf3i7EziecRQQjE3FcA0w4F25Wmu2oss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGNx7TOO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGNx7TOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99D71F000C4;
	Sat, 17 Oct 2026 17:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256913;
	bh=ATs3//tHNaCe9FGZsn7aiCPiobQxZoqbFYkmheeok5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OGNx7TOOjkg410XKI/sMib25+S8DxIHhwq+zdJtlz+o6WCtLGR6TofyVZxKMVfHuJ
	 fxnqEJioft05eQ1el8SWoXKeqS2zNsQNaxI3AcwU5mQ+TAHMKyK5zkS0gbd/hiG28f
	 iV0PeNBokJ4bKjQJe1rwuDNs+qeVGexn877VCh7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0349/1674] iio: proximity: isl29501: Fix return type of isl29501_register_write
Date: Sat, 17 Oct 2026 17:43:41 +0200
Message-ID: <20261017160440.083961285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Salah Triki <salah.triki@gmail.com>

commit e8dd273d199f5bbe295a8e3d8b777c5505b6b2e1 upstream.

isl29501_register_write() was returning a u32 instead of an int.
Since the function returns negative error codes (such as -ERANGE or
return values from i2c_smbus_write_byte_data()), returning an unsigned
integer type prevents callers from correctly checking for negative error
conditions.

Fix this by changing the function return type from u32 to int.

This was found through manual code review.

Fixes: 1c28799257bc ("iio: light: isl29501: Add support for the ISL29501 ToF sensor.")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/isl29501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/proximity/isl29501.c
+++ b/drivers/iio/proximity/isl29501.c
@@ -227,7 +227,7 @@ err:
 	return ret;
 }
 
-static u32 isl29501_register_write(struct isl29501_private *isl29501,
+static int isl29501_register_write(struct isl29501_private *isl29501,
 				   enum isl29501_register_name name,
 				   u32 value)
 {


