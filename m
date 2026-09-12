Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972C947988C;
	Sat, 12 Sep 2026 16:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230702; cv=none; b=d0xqmk1GHGqreGjYyDSWXAj/hSPY9WD+WC3b+uk34gdti2LS9JuwPkRZzuM9cMwVC1f2mCBMdcPL2MGlR2h/odnhiyA1jhydr3AOtxLtz+1rRNk3c2uYpEucSenohQzXSN998ibVEzL92pfVlNB3uwWYOTzehPR3Dvh1q1GRaUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230702; c=relaxed/simple;
	bh=sWigH+YwMJQ7T1kWMoiSIkM2BBvhEq+PfchVbwGkRk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRiBhWNUEJyKaWxSGLV6qiqPymbuNQ4RxHyPMVpXLbizxKdGSeH6Th6r8r+5tg4UF4jcE7+onYSTuBz0DdmJax+UjaCxrXpFMfXN5B6Sx4Bbn+2Rvv+iAzUEJGSi8VKvEpSvijCocpmXJxfrdvoHeayZgCJcWvWfJWQErQpuBUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/RajgAT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/RajgAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A990F1F000FF;
	Sat, 12 Sep 2026 16:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230701;
	bh=Jhqkrm0I6SeE+407VcJu4KmG7ovjzB53ksWpjiK5SaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/RajgATUuoH1IsrVPmJoOWDcrivCHGVcjnxnLyxFJxqkSZC+zCDUFGuSQk2E4Va1
	 qTAhP2ZpreW5dD4aRe5KKZVQi/DAy8wOS97OuaHlcmpK2RLK+nWJOQqqMA4VYVK8mi
	 6S1pvIqiEQrPPq9N4ebRifWJyuXOQ+qSi2I0/oMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0848/1191] iio: light: isl29028: return zero in write_raw() on success
Date: Sat, 12 Sep 2026 08:59:36 +0200
Message-ID: <20260912065607.302950573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 32d58e18f26da..ce82ecff59d76 100644
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



