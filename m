Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D44C3C198A;
	Sat, 17 Oct 2026 17:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259870; cv=none; b=odS0e4876uuv9gXUBPpo8mMKWIqjdIPV3k2zxIKL68GrA8VUEK4QMULOxZqSilqaaT91Kw/Ui9Mt6kraGPEmVhCugijgPMlsi+avUdau0nz/V/I0wzO5IqOW76d9NGk0l7/pMiBGUagPGWwF1MTyJKrZr39HeY9mQYEsx9u1FUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259870; c=relaxed/simple;
	bh=dMqE8aUlm41XURnF3Knnu2sXYcpoFimY4ASAA63ckTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Se3pmJ3i8Esb/ZwiXcE4drm3ISCGUGoiDnV4LbJF6LFhx60rkHRdQRVvm1cQdB1kGNzeXp5CLhy+YT0q4PhduZX8jpLlO0B3dFQrQhiUMrJBbGp5nbmzGjKHJfL3FezDf9wdv682datMm8Ou9e7SD7+73f2VrjTZ3SEuHzhmXTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNdgvss2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNdgvss2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012E51F000C4;
	Sat, 17 Oct 2026 17:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259869;
	bh=/M0BmRTIbwdfTZd8tiEN6MTOX/FRGBhkFK1pW1R6PVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNdgvss2neGS/2/ngEKDT81hJUh4j0TsKZanXwgJR80XfW2uloWu+6Sbv0iz3/5kT
	 Xal8B9kI/1KoaSQGYF6kgJr9PbKvghGwnqakRBbGSqLfqtdq/ZI+ECYbl2HPzGersW
	 iLD4gd6kw7Ndo73omokEmk5V0nSnTdBTgQQyGOQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1356/1674] iio: light: ltrf216a: fix runtime PM reference leak in error path
Date: Sat, 17 Oct 2026 18:00:28 +0200
Message-ID: <20261017160505.967589448@linuxfoundation.org>
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

From: Vidhu Sarwal <vidhu.linux@gmail.com>

[ Upstream commit c132aef0e757a39036b1d40faf0569f2e343b13e ]

ltrf216a_get_lux() acquires a runtime PM reference by calling
ltrf216a_set_power_state(data, true). However, if
ltrf216a_read_data() fails, the function returns immediately without
dropping the reference.

This leaves the runtime PM usage count unbalanced, preventing the device
from autosuspending after a failed read.

Fix this by releasing the runtime PM reference before returning from the
error path.

Fixes: 83f0bcd40d5c ("iio: light: Add support for ltrf216a sensor")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/ltrf216a.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/light/ltrf216a.c b/drivers/iio/light/ltrf216a.c
index 68dc48420a886..45644c0699fa7 100644
--- a/drivers/iio/light/ltrf216a.c
+++ b/drivers/iio/light/ltrf216a.c
@@ -241,11 +241,10 @@ static int ltrf216a_get_lux(struct ltrf216a_data *data)
 		return ret;
 
 	greendata = ltrf216a_read_data(data, LTRF216A_ALS_DATA_0);
+	ltrf216a_set_power_state(data, false);
 	if (greendata < 0)
 		return greendata;
 
-	ltrf216a_set_power_state(data, false);
-
 	lux = greendata * 45 * LTRF216A_WIN_FAC;
 
 	return lux;
-- 
2.53.0



