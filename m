Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166DC345749;
	Sat, 12 Sep 2026 14:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224624; cv=none; b=OKiFhS/Sf7BUpzDICpWDU9OXVEVOB2sLLoWmKyxr2RXHRj8Ik3wYGvdvQJFKbddbdQ51sJ1zaMcNiwJXM8kOw7WcGHggc87d4Ipx1Ov8i8m+kdbC/fAzQOBOCOKJtrqtz3JVyilXy410jU+IZliDmH38E7JZrwxuKjOvY5wnDW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224624; c=relaxed/simple;
	bh=GdXtrV/EqNUqqZVcPwux9Jm0Qp3AWlQBltY49KOhG/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qy9eo7gMBA4cew2UnDSQ9h+QPwSYq6VRf+JgXlRCd7jicw4RwKN6SsDEzNfr/zOjYV3FrBVA04Gj34gcXAOXroRSzQHiOgxINYhYjAr5rDzjzKercg/mlioYEAoQb1l3LfARc1f5UFq6CO1vVuvmWE0HRjnbbA32JOE8cx1eXB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JI7lPFHO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JI7lPFHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FCB1F000FF;
	Sat, 12 Sep 2026 14:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224623;
	bh=pCiM0e0p+ssWVhEvkRaygOIFltcejObzq9/TQtyYXdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JI7lPFHOAkssBqqnKh/OhhOJ5mU4RU+J1+2n6BFn3i3Y6wXHz9EItOjRmJ7oqJokR
	 HlS8cFM8Zamj/pHWiypvxbrHDMC/fqLVuqTwyeacl972xih/O2QNSb1p2eg9ZdtgjQ
	 s5rbMK1+tEPA+mBnH36Ww1c1ri8qm38hUPgD0niw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1030/1424] iio: light: isl29028: return zero in write_raw() on success
Date: Sat, 12 Sep 2026 08:57:42 +0200
Message-ID: <20260912065630.379205472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 5694683389bec..90099e467b707 100644
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



