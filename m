Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD993921C6;
	Sat, 12 Sep 2026 19:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242982; cv=none; b=LswdCl+QD9ArkWDQJwqfJOA6hQSO+8pkBpvkmnnP9q9fNHKRlI/RM/OTAusZ1MTuR0dAdmrnrhOOoQZdVdP7oSbJjIVQAXKkuPDpNK6Q70QR/Yb8M8TiNA8jgv6t90MXa/82pA7PEteYNAaF0SjGPBECXM1UK29DLglCMFi1MHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242982; c=relaxed/simple;
	bh=K5gTHS9bwBNdgM8dMDymFrnCIiMbhijim8YG0LHBCxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eipXBqWYuhLPLMw1GRASlscbq4bQL9NkV4ntwArBpj/RFYC4fWRjynEmkwy9vMjAgBLD9CiKra5258N8cWO1G968LQIrW5BqxxVwTo5QBgQxTTCXlCsP7KYFQR+RnIHx39CWSj38KQ2qmW9pjB+c7n/sM9Ux9hIUXYEZbyCXUbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojZm13x7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojZm13x7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B09F1F00899;
	Sat, 12 Sep 2026 19:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242976;
	bh=9HgOaU0nkIu8nDw3EOpUn7q9Bbrm8W1AVozX3+ZAbNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ojZm13x71KKv/EG6TMy532+al4fHfuagvBTiuCD+q3mb7AhM2lP7uxe9yFe4QIvpM
	 nGeEy3HUpJDU1Ky2OhN63pVORtqD2VTWp4fwMSgbGwLJWLk6w4694d6h6lgpCbxDRC
	 bSufENyw2/yDywlhXCIEFWxC1IP+hWDoUvrL1yT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 592/798] iio: light: tsl2583: return zero in write_raw() on success
Date: Sat, 12 Sep 2026 09:03:40 +0200
Message-ID: <20260912065530.694467388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e39d512145a67..3f13c828116ef 100644
--- a/drivers/iio/light/tsl2583.c
+++ b/drivers/iio/light/tsl2583.c
@@ -798,7 +798,7 @@ static int tsl2583_write_raw(struct iio_dev *indio_dev,
 	if (ret < 0)
 		return ret;
 
-	return ret;
+	return 0;
 }
 
 static const struct iio_info tsl2583_info = {
-- 
2.53.0



