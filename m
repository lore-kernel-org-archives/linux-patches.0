Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6402938A73C;
	Sun,  7 Jun 2026 11:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830224; cv=none; b=HmFKqlhzzWb1gdd+mq52LKj41oSoN+Iz0ir7ljUk+esPPFoJCnvbQqEjFST/oYk3YiYbyHK7EXODnx5dEnMglv5SdFSoZkqxYRIJl5EBw+oUw0EqNo+HMwpQmyGt1CyT/XHHU+/n23CkNduX0cMRmwCGwLKLBccC7aY3Jws9sug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830224; c=relaxed/simple;
	bh=pnGbNK1bdRFpeUg1jroshRpdps0Uex/uYcWBazFXRAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEBQsPK/9aKJRFLIiQY+0KMviAPHTbb+7NbmDhgya6onsI4h/YG5N30PtuiFilZCkc7HCA5zA1HTXXPNfYVdQLAl/Du2D561/wZFDWSBt4IOd18XNerEvkufPvN4PpKJziMVlnpSIWRgcGlzBhjaRxHFJoBszX7skwyUHAM0Mrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcQE/4VP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcQE/4VP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A5B1F00893;
	Sun,  7 Jun 2026 11:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830223;
	bh=gXpAvxQE9NANqj5ZFAEDzqQUXUZdEOReOd78Vrcy6kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jcQE/4VPaxVQwhrmOeZ4h0YASb/W1o0/+D6N1/7fBkq5fskAJXMAdG6mgadMZEadE
	 rxBR6w1TSyOXT71d32/x2dZ0Z3l8jjqyhE2ThY9xqyuJerNVKXSrTBH4TpppeDZ/XL
	 8MzIP0YpSBsEOttKMyvAji9vMiOfBX0D7lIurC6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 291/307] iio: chemical: scd30: fix division by zero in write_raw
Date: Sun,  7 Jun 2026 12:01:28 +0200
Message-ID: <20260607095738.430060004@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit 5aba4f94b225617a55fed442a70329b2ee19c0a5 ]

Add a zero check for val2 before using it as a divisor when setting the
sampling frequency. A user writing a zero fractional part to the
sampling_frequency sysfs attribute triggers a division by zero in the
kernel.

Fixes: 64b3d8b1b0f5 ("iio: chemical: scd30: add core driver")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/scd30_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/scd30_core.c
+++ b/drivers/iio/chemical/scd30_core.c
@@ -257,7 +257,7 @@ static int scd30_write_raw(struct iio_de
 	guard(mutex)(&state->lock);
 	switch (mask) {
 	case IIO_CHAN_INFO_SAMP_FREQ:
-		if (val)
+		if (val || !val2)
 			return -EINVAL;
 
 		val = 1000000000 / val2;


