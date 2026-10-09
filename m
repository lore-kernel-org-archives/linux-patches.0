Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6616D4E80D1;
	Fri,  9 Oct 2026 14:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557016; cv=none; b=fXnfgsy+xuecIBGtfSpE2B4GTX/pdbGCAPiA9udubEX+opCbGRcJahzjPLjWIRY1yeLx1nQtYs+tfhiA5n7gJzdkl0+uETr+B5pQmqBgyDzy63vO3dJ6SvQ3ZNoUNcMXmBpYTuW91FYT+GkfY/lhzLKZpifwqDdI2tBSNzzyQPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557016; c=relaxed/simple;
	bh=2YHAQsypNy4c2c+9Qm/4ruDRLni7mEoJw+WFK8ffyi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIINow92IGCm833peQ4+/KyhRL57e1HV49q7iAQRcPhaWiyqTVJ5gBWePrtpWBRZXivgMVAdvQBjEwXAX8D3Araa7s2/1D69vr9l2PxWrJkNVLqN7UDBP7FD/tTjQjB2AQa3s47ISg/hnCX+ek8zr+v9UdXOEeG7maFoBCypEWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+103Rdq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+103Rdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6081F000FF;
	Fri,  9 Oct 2026 14:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557015;
	bh=cd6TowOTUx5q77519yE5gz0FUYqu4S4fmg5RzOWRoiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+103Rdqj1I4PROMNk6gku4Mk+SZxufvPIJVpa7OtI5QN02p4NZ6vrN7mWOX36+AO
	 MC51k8a9/h5KjorJZdgqAuYlfhAkXP4r8MTIualDWnYE8FCa3sFrZALsgO6pqFihcN
	 5cTtGo51F0zjPmkqfoeFQAG9tK7YKltuANW4WH2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 333/403] iio: proximity: isl29501: Fix return type of isl29501_register_write
Date: Fri,  9 Oct 2026 16:11:34 +0200
Message-ID: <20261009141000.034088429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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


