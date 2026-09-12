Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E4C35AC1E;
	Sat, 12 Sep 2026 08:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201577; cv=none; b=GwI8SEir+Pwjk3cdtRCzaqhDGiU8j9tWaSP8XOqApQT5rw7mwq2Yk9S5KH3VVBwev8Q8rEDZZLWliSP9TChG5XA3KDckvbrssZzFy+LU9GjeXr2LULzB6q9msCQpKXcOn+6Mq71Sc+lh917nANoJFbc/NFiP1CxlSqjM7t1ECEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201577; c=relaxed/simple;
	bh=p6yi98zL/+WuxLIJASYoPDBhYtd3L4x/lODqw/RcQh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyaQ8w05X0VrB7cC6ydXdLGDAQ8UzppFxao7Xov5sHkw0jnZXh9e2s8sSSg8xqtz02tMFZJYHD+68YfVxdz210zJxeI3UXXNSyvTqqLivIEURi/8PUHgWJPRFrKzUCWCNJTlBluGhHUkowKiIn7cvBIG3QTjYxiq9Cyst37Ed5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxcQE0nI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxcQE0nI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97291F000FF;
	Sat, 12 Sep 2026 08:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201576;
	bh=d21xQybiDLXXOV8j/iFUHy9EiwkaZ8S5lUD6TWfeUsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxcQE0nIMz8hqGobS2Ax8E5xUSoTON++Z/XMU1aEnpRvpgKwzvhCNIgL2rH4Xg/Ka
	 cj+52+HiCp+8JQFUzxuetVJ74dG44362xDaQXM1/JKlO1gEu30/MA4rPT7coFMvDCA
	 x+c8MPHSKO3acW6u7+hcFZ9yybvQM97UFdOlR0M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1024/1815] iio: light: isl29028: return zero in write_raw() on success
Date: Sat, 12 Sep 2026 08:46:14 +0200
Message-ID: <20260912065713.057408995@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index b88e7c4eae3ec..6d5dd17e7a7d0 100644
--- a/drivers/iio/light/isl29028.c
+++ b/drivers/iio/light/isl29028.c
@@ -409,7 +409,7 @@ static int isl29028_write_raw(struct iio_dev *indio_dev,
 	if (ret < 0)
 		return ret;
 
-	return ret;
+	return 0;
 }
 
 static int isl29028_read_raw(struct iio_dev *indio_dev,
-- 
2.53.0



