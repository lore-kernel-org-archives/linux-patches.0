Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F6B267B89;
	Tue,  8 Apr 2025 11:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112788; cv=none; b=gt8NqPIhJttWRHdF6gJdvAD4EOxPTYVbCjgS0aw3ilkPIpl0UL3vMFhHMSQzcGB8Lb4tdGOaeRFh1+NAZMZ0NGreQ8BbCiMIx6k+Lv4QxqMeJfjaFKeseFDLDTlwjfKj+4NMj01BQYF+vnVsoORalo+fkdY570grsMMSiNtjoeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112788; c=relaxed/simple;
	bh=V+OAk3Lcj2Kxx5iLiqIgaxEddkLU062JaW9NoXyb35A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzUOmBrZqkmdOjkbV/USGcHX/uVEnHCUZQ67Oa0Mew49+qz7bIaZXNhAZ+f06MjQNJ2OHmAkz5RX3HRMpHT99azDk7B2gEGxa3S+SLRAtkpUZz7kLEDXQiIvnxKDu/vvfWESmoFx0J5DNcVDWXDbdacjTShnjV/M5LqKCWhaIdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arFU2NU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arFU2NU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4CCC4CEE5;
	Tue,  8 Apr 2025 11:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112788;
	bh=V+OAk3Lcj2Kxx5iLiqIgaxEddkLU062JaW9NoXyb35A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arFU2NU60gpG4JxTTJTdpyLBg1uTg+n8adlcj9oc1knfaL8aYMXR1OY6yI58287ow
	 /hd/DSUFc1vJZunvPgPw6VzT/JPkIQSwe+9FwqByF6Ob3WTY40qxije13Wy3Le+gdQ
	 ovzSGpdianSNjaVBRSlm4u0GumhfBedDRY33wHB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 197/279] iio: accel: mma8452: Ensure error return on failure to matching oversampling ratio
Date: Tue,  8 Apr 2025 12:49:40 +0200
Message-ID: <20250408104831.655720454@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit df330c808182a8beab5d0f84a6cbc9cff76c61fc ]

If a match was not found, then the write_raw() callback would return
the odr index, not an error. Return -EINVAL if this occurs.
To avoid similar issues in future, introduce j, a new indexing variable
rather than using ret for this purpose.

Fixes: 79de2ee469aa ("iio: accel: mma8452: claim direct mode during write raw")
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250217140135.896574-2-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma8452.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 1f46a73aafeac..a7168803408f6 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -709,7 +709,7 @@ static int mma8452_write_raw(struct iio_dev *indio_dev,
 			     int val, int val2, long mask)
 {
 	struct mma8452_data *data = iio_priv(indio_dev);
-	int i, ret;
+	int i, j, ret;
 
 	ret = iio_device_claim_direct_mode(indio_dev);
 	if (ret)
@@ -769,14 +769,18 @@ static int mma8452_write_raw(struct iio_dev *indio_dev,
 		break;
 
 	case IIO_CHAN_INFO_OVERSAMPLING_RATIO:
-		ret = mma8452_get_odr_index(data);
+		j = mma8452_get_odr_index(data);
 
 		for (i = 0; i < ARRAY_SIZE(mma8452_os_ratio); i++) {
-			if (mma8452_os_ratio[i][ret] == val) {
+			if (mma8452_os_ratio[i][j] == val) {
 				ret = mma8452_set_power_mode(data, i);
 				break;
 			}
 		}
+		if (i == ARRAY_SIZE(mma8452_os_ratio)) {
+			ret = -EINVAL;
+			break;
+		}
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.39.5



