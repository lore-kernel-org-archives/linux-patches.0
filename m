Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F69647AF5F;
	Sat, 12 Sep 2026 12:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217102; cv=none; b=TKyU86SMbt8HLSsabGDJaky5F3/2NFeOKphntK+ZgqFkE7SIzae6Ivpk/yTraUPe/GUANjteVnc+adCVlQcdzyf5zLCQrH3xwwysEjmfbmB6ZD9kuIuOd73YtukosPDwj+W3NfzXBK7DLdaK3i70FlGQgwzK9hnO1u/BlabI8Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217102; c=relaxed/simple;
	bh=X/wkEn2QlbsVulDr5p/dYAl+d5Z4oqtW+ehTxTCRckQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgL1lRzBobOG5YGvx3mBzGFzH/tusa8lCmbptZaQ6S6PFXDWUVj8he34mZ+kmZWdA3604puPgepA+qCwyx3+xts6iKR8cNDlxQQgGIOP/fcgxssC5mBF02jM1E1nr7kDeRiARVYU9v8r6/3JQXNCv6D8yRhR1zK2vImjHYR3NQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUBbn6rd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUBbn6rd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D161F1F000FF;
	Sat, 12 Sep 2026 12:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217100;
	bh=FGqFOKaKjsBl8bQkaUjOEC+hJgqeRJqaWxCW3dfvfEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUBbn6rd5OqVNJEHMCL/DCZ0ZnkBZgFQ2XzY32c4JS+BOKm7fFlsN/oQXiKwU5gd5
	 ERRpYA2asqgHolWCd66Et+cx2sekJxWRkDOfKqX0w9WoQ8OU6kwB5t5O99BLOKcCja
	 Y5VAdqn9WAvoAlNPeDW+D+IR9ew4Sb3DTf7XMLxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0871/1376] iio: light: isl29028: return zero in write_raw() on success
Date: Sat, 12 Sep 2026 08:54:57 +0200
Message-ID: <20260912065626.970140246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Sang-Heon Jeon <ekffu200098@gmail.com>

[ Upstream commit 55b75622829779223b9e32aa9600a8651d3e2df4 ]

isl29028_write_raw() returns the value of pm_runtime_put_autosuspend(),
which is 1 if the device is already runtime suspended.

In that case write() on the sysfs attribute returns 1 instead of the
number of bytes written. Make isl29028_write_raw() always return zero
on success.

Fixes: 2db5054ac28d ("staging: iio: isl29028: add runtime power management support")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/isl29028.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/isl29028.c b/drivers/iio/light/isl29028.c
index 95bfb3ffa519a..a23b2af287d5e 100644
--- a/drivers/iio/light/isl29028.c
+++ b/drivers/iio/light/isl29028.c
@@ -414,7 +414,7 @@ static int isl29028_write_raw(struct iio_dev *indio_dev,
 	if (ret < 0)
 		return ret;
 
-	return ret;
+	return 0;
 }
 
 static int isl29028_read_raw(struct iio_dev *indio_dev,
-- 
2.53.0



