Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BD347B437;
	Sat, 12 Sep 2026 12:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217106; cv=none; b=o/Wf/UU0aDxgJi8w1nIKihqtd9EaudMAYZ/8MvUoiKHigqDa2nTdDwOR5P8gORPos7BtSycJoWzTNDrapd6+aNggMctIOMXl/boatmrVensPbP7pwx7HskNdR0zGQOsM25vlC2MazUHK8l+f8Jx97yCeew2IQHvCmdL6mNNCT9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217106; c=relaxed/simple;
	bh=fz29pXqXOiYOVrXST6o0KxHKh38cQ4ptTGCH200e8ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogI0jmN9wo0OL0SWwsDE3qB7dYAvHSlBAkYgTZKgjuUfv202TEqXxUxRhRxhX+3ZsGGjYlTpYatc96e+YHixjc1WI3Y2xX8tkpbx6lrmvAiZLi2TXRFrIDUqi0DyH7fuSsdLN581wrlm3UIdxka56nWBOMPPaDIeOrBGSctdePc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDQVgDrA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDQVgDrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8FD1F000FF;
	Sat, 12 Sep 2026 12:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217105;
	bh=sBbxQjYla6ak8zpuEWCGm8nKzC1ntNvy86Dt8lRjdEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vDQVgDrAjRjyOzANMhXdgDx+Uds1ywlwHoMeBqTDAWlDQsAFopCM2+dix9hVHmBnI
	 rSXPFNbq2sGq+IbmHjbxvM6Z7sFoC15xCheoR9LFcVh2ztrtQTAAeSfV2VWhM/2CCy
	 PvgrM/RKHX2JTIcXlFAveIHj9tlt+cy341xmqC2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0872/1376] iio: light: tsl2583: return zero in write_raw() on success
Date: Sat, 12 Sep 2026 08:54:58 +0200
Message-ID: <20260912065626.992076252@linuxfoundation.org>
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

[ Upstream commit 42e8791841e0677418a3ccc97fa5c22a1455f417 ]

tsl2583_write_raw() returns the value of pm_runtime_put_autosuspend(),
which is 1 if the device is already runtime suspended.

In that case write() on the sysfs attribute returns 1 instead of the
number of bytes written. Make tsl2583_write_raw() always return zero
on success.

Fixes: 371894f5d1a0 ("iio: tsl2583: add runtime power management support")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/tsl2583.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/tsl2583.c b/drivers/iio/light/tsl2583.c
index 02ad11611b9c5..dfcb8228ada1d 100644
--- a/drivers/iio/light/tsl2583.c
+++ b/drivers/iio/light/tsl2583.c
@@ -800,7 +800,7 @@ static int tsl2583_write_raw(struct iio_dev *indio_dev,
 	if (ret < 0)
 		return ret;
 
-	return ret;
+	return 0;
 }
 
 static const struct iio_info tsl2583_info = {
-- 
2.53.0



