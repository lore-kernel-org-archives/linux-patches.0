Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C71C79DBF;
	Wed, 21 Feb 2024 14:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525773; cv=none; b=WF3lmkozPcGDAYz8MfGoEmtympor8hcWUwO/FxFOblc1Vkyjz120I4u///y6CE0olSMyLWYRdndVw8sjVrBvwEuFXqpPanoPDaB4wdylwiVgB1ardA3UN0d4HdUfxkIZ3VF18mJjW8+gPPWq9lqtc81efhlN54iFzvf0Aug6z6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525773; c=relaxed/simple;
	bh=uuCTFeeRmRSVp78NcP4wKKXDFZnhEt/a553VYD1SfjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MG7XiMxR9Ua3wNS+a50C/Bq4pKFzs/cZBI3gah/cvLXNnh4HjX34m487juW7sq8FMEAeJk22D4PirL7/lRi9YxwzIq4iCu3zaFwBfmbvzfqm19Y/XWIxCd+++jogcwjAbxPLRSlXqs2buJCzUiSDGrbPmOxZXU5ZvpwAp6BMyhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kug5vIWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kug5vIWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55123C433F1;
	Wed, 21 Feb 2024 14:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525772;
	bh=uuCTFeeRmRSVp78NcP4wKKXDFZnhEt/a553VYD1SfjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kug5vIWl97gI1rw6O+bH3EsYk+ifiQLIkthWFd1+kji+tlmp3sTyEAJPVsoIV8TWY
	 KnLgh1vVH3k20MRq0qRWBujCAsn1ldZBpwYMW+6HWRr7U7HdLpL2sFjvy7mygTaf2w
	 dg1N6WNsguOp68Bdp9KXEXpgf9x1whUT5pXZ0/Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Schiller <david.schiller@jku.at>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 231/267] staging: iio: ad5933: fix type mismatch regression
Date: Wed, 21 Feb 2024 14:09:32 +0100
Message-ID: <20240221125947.505558153@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Schiller <david.schiller@jku.at>

commit 6db053cd949fcd6254cea9f2cd5d39f7bd64379c upstream.

Commit 4c3577db3e4f ("Staging: iio: impedance-analyzer: Fix sparse
warning") fixed a compiler warning, but introduced a bug that resulted
in one of the two 16 bit IIO channels always being zero (when both are
enabled).

This is because int is 32 bits wide on most architectures and in the
case of a little-endian machine the two most significant bytes would
occupy the buffer for the second channel as 'val' is being passed as a
void pointer to 'iio_push_to_buffers()'.

Fix by defining 'val' as u16. Tested working on ARM64.

Fixes: 4c3577db3e4f ("Staging: iio: impedance-analyzer: Fix sparse warning")
Signed-off-by: David Schiller <david.schiller@jku.at>
Link: https://lore.kernel.org/r/20240122134916.2137957-1-david.schiller@jku.at
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/iio/impedance-analyzer/ad5933.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/iio/impedance-analyzer/ad5933.c
+++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
@@ -624,7 +624,7 @@ static void ad5933_work(struct work_stru
 		struct ad5933_state, work.work);
 	struct iio_dev *indio_dev = i2c_get_clientdata(st->client);
 	__be16 buf[2];
-	int val[2];
+	u16 val[2];
 	unsigned char status;
 	int ret;
 


