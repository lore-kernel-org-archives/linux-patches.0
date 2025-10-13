Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F650313532;
	Mon, 13 Oct 2025 14:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367240; cv=none; b=mqqd6DnYlx+MTKaW6MNUo9TCBq3Ui/zNwbZ3EURGJj6ZEd7EIVlo2Y3okeyRc1XyAETOd6l3GkKvrBr9HXCUj6LbZOa/w1EWvl2Nnq/H08N/k+a76ll+f9lIMsFYeCuETCfBm5EAjnYuIgZJHzssAuoq+Uy0Yl/GN74t2TT1ITw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367240; c=relaxed/simple;
	bh=Fjf2Bmt9dM6gp/oMA/8XsukfYhDa0RMGrN30jjV2Cnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDjgEIj7Y4KUNPFfFNd6mmvg9NrewTAjdh1qTbvFnxjRGuNUnDMVEXbZie1Zm19UHjQj5nRjvQMvQyTFQfLshdYC+bIcx1RmsUlIGGj2EwdNrFA+zrBpeDI1AepESwHuoI0QBpc0eq1k0+8pFcWto9035+6452RpOorL3yF0NrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNeDqnN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNeDqnN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D619C116D0;
	Mon, 13 Oct 2025 14:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367239;
	bh=Fjf2Bmt9dM6gp/oMA/8XsukfYhDa0RMGrN30jjV2Cnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNeDqnN2/Yl6G7WbxyLGixoHyMhFhFPOdaKGtmPwYHvHL7cbqYqWhTaS4ub879V3a
	 dGE1IKOzrFgPpGuNCsnHh6FSBAd1ryYnKCa24OZarTsN6pZi5ekmgEMja2ZNgl02JC
	 TikDjVgjNAzMxjUa22voHQYpIpS4dPYmlYy7FyHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Beguin <liambeguin@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/196] iio: consumers: Fix offset handling in iio_convert_raw_to_processed()
Date: Mon, 13 Oct 2025 16:44:56 +0200
Message-ID: <20251013144319.144915880@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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
index 5c210f48bd9ce..c7795feb904ed 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -669,7 +669,7 @@ static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,
 		 * If no channel scaling is available apply consumer scale to
 		 * raw value and return.
 		 */
-		*processed = raw * scale;
+		*processed = raw64 * scale;
 		return 0;
 	}
 
-- 
2.51.0



