Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D59917BB21;
	Sun,  7 Sep 2025 20:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276717; cv=none; b=H1rv4pOkq0Qx9NH2/0qGGx+gwfeZmp3QZyVJ6N+/H+VFlX5YqOTKL9xLddEugyypieIyUhqqc+KYDgHEFqSGW7f8ZwyzS2ZYXfsDQB7R7vG0cz7AQ7SONIn/tE52sOL7398KJhmOeQX4WNrWpcnXfMeC5uGZKPh99RJUdNNFpiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276717; c=relaxed/simple;
	bh=wzuWmMHSwNyF1QfHNnvP9KNzpB6ADRelzdSqMwT5kLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDn4snNTP/nkKT5MTumDY3dymhy2RpsqgiB5SELvzX9yObBAOVGGFLVQZPuEU5gEGgvBC8Ll7U4mToKda29A2zpwMP7EChNPkQRjJTU2eEVIuVLkIPT58aw3BqloVKNeu6PF78Wu6BwFBQoNt4q60ZC3ydJznjppYCe18hoTiwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/91wvvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/91wvvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20212C4CEF0;
	Sun,  7 Sep 2025 20:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276717;
	bh=wzuWmMHSwNyF1QfHNnvP9KNzpB6ADRelzdSqMwT5kLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/91wvvY/8DrhkaPORq8YZ2aABsxciKiYsMcCXhrKhqI91CHFh4euvfdeHuBzblOb
	 kNPBxJEIoEDnBLAfGToNXCuLmxT3daXB+tqeYbz9gqijpnQJgJ+mxjxPEJIBFhvhqT
	 akMHEPqXVLooFhww71dy30R94F9sxY7mS4k+x8eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/121] iio: pressure: mprls0025pa: use aligned_s64 for timestamp
Date: Sun,  7 Sep 2025 21:58:42 +0200
Message-ID: <20250907195612.046483926@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit ffcd19e9f4cca0c8f9e23e88f968711acefbb37b ]

Follow the pattern of other drivers and use aligned_s64 for the
timestamp. This will ensure the struct itself it also 8-byte aligned.

While touching this, convert struct mpr_chan to an anonymous struct
to consolidate the code a bit to make it easier for future readers.

Fixes: 713337d9143e ("iio: pressure: Honeywell mprls0025pa pressure sensor")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250418-iio-more-timestamp-alignment-v2-2-d6a5d2b1c9fe@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ Applied changes to mprls0025pa.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/mprls0025pa.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/iio/pressure/mprls0025pa.c
+++ b/drivers/iio/pressure/mprls0025pa.c
@@ -87,11 +87,6 @@ static const struct mpr_func_spec mpr_fu
 	[MPR_FUNCTION_C] = {.output_min = 3355443, .output_max = 13421773},
 };
 
-struct mpr_chan {
-	s32			pres;		/* pressure value */
-	s64			ts;		/* timestamp */
-};
-
 struct mpr_data {
 	struct i2c_client	*client;
 	struct mutex		lock;		/*
@@ -120,7 +115,10 @@ struct mpr_data {
 						 * loop until data is ready
 						 */
 	struct completion	completion;	/* handshake from irq to read */
-	struct mpr_chan		chan;		/*
+	struct {
+		s32 pres;			/* pressure value */
+		aligned_s64 ts;			/* timestamp */
+	} chan;				/*
 						 * channel values for buffered
 						 * mode
 						 */


