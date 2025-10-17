Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081DE330B0C;
	Fri, 17 Oct 2025 15:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716219; cv=none; b=H205MSPQ9Z5UpN8i0ckJIBNkj+0dR4Et5365qox0jAz7Ja/pKQQ45JoBbprucU3hS+xQiQDySILk1hAxTbEOKLfmMpcyeXSyAyDxb7czcqCp+vGve6NVE28uA8Qw0L8ckRnktzGVr9B7PZfPrSBjHxME2GQZ+oRPZ5MRkkgmxl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716219; c=relaxed/simple;
	bh=nVIvG+Bxu6vC9TzwIyWxOwC/pF/0kEPNvwwjKKE1Nnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxATQqRGnTF0cLsL6hpsGE7O+R5Ce3RClERgtuclNqb4qaRgxYeSdopg4LqcmfqVr16iEJfpMwY8PBNa6G1SWsSWkm+vKF424Ns/4lBMcHn+EyfrMSdoA11nHltBorczfXnxbOQ0KjSGJq0ynW7SMwyntLMunP1Uz7moEC7z1xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKCszy6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKCszy6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E3FC4CEFE;
	Fri, 17 Oct 2025 15:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716218;
	bh=nVIvG+Bxu6vC9TzwIyWxOwC/pF/0kEPNvwwjKKE1Nnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKCszy6UA3z1MtU4UcxIU7O9Pupw0+TI2bGU/j4nGCRAO0vAa1CSq07Y9+2Y1pCti
	 v3E3CeJzg1KewRDymVgxjDSFAt6HmfHYRSguGYs5NNsdm6XcRGCtdMSXDfyMGYc2WA
	 6VpQ6I+XkIbTbbyDPZ93l/sVRix+zqvJGdCdIYE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Beguin <liambeguin@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/276] iio: consumers: Fix offset handling in iio_convert_raw_to_processed()
Date: Fri, 17 Oct 2025 16:52:45 +0200
Message-ID: <20251017145145.115136035@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 33f5c69c4daff39c010b3ea6da8ebab285f4277b ]

Fix iio_convert_raw_to_processed() offset handling for channels without
a scale attribute.

The offset has been applied to the raw64 value not to the original raw
value. Use the raw64 value so that the offset is taken into account.

Fixes: 14b457fdde38 ("iio: inkern: apply consumer scale when no channel scale is available")
Cc: Liam Beguin <liambeguin@gmail.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://patch.msgid.link/20250831104825.15097-3-hansg@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/inkern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 5eabb54c1fc72..8815747e67be7 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -619,7 +619,7 @@ static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,
 		 * If no channel scaling is available apply consumer scale to
 		 * raw value and return.
 		 */
-		*processed = raw * scale;
+		*processed = raw64 * scale;
 		return 0;
 	}
 
-- 
2.51.0



