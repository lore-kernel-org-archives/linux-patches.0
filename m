Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CBB36A35E;
	Thu, 16 Jul 2026 13:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209156; cv=none; b=knA6ZSttNA58Mu2E/v2RRsfvzdZW1U3OiEtvOuSyZfl8X5Z7XGJqV3vdIVO/ShGIGOjYIpYJUTN4V0xhbeaFrJxt8J9TVUrHdpUt6TTnE1Y5mQBk9qK2iNIj8NKIAclOq3dmaqGp9D0UIj2sPJLIEFGS9ZY9sk1wXaOG7jut6YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209156; c=relaxed/simple;
	bh=tPUR/9IKgY4xNWxtgIVsr8CmEDNcHeMCU4DiYbfY0FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EppjYw7yA/RJAZ5mUtrPyZB7+DbRmpBOLrC/op4uIdtIMfHF4X9Fd8ta4vrdhTMYB4UzXS6ggWxKzVaXKB46SSiNd+EZMcgY6GxZH1SaMVgvnqX7LByQmauDFIarKGE2ozs1+nNANjQnBDzIB6+vkYvePeEPJtDeypjbElII5Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7CkZdhs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7CkZdhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0972B1F000E9;
	Thu, 16 Jul 2026 13:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209155;
	bh=nWj6Dccgy/dqPwsyIXwcGMT1oDM2Hd6J4g9APV4zjJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s7CkZdhsCD1bPUYe0SFWPW+419VbR3rs1v3PI2JDV10/75uspWxBNBDbhmIyqtdHJ
	 Z+wzvhfko5hSfETuF4YEw4aO8hMjtjVx3c4J7yHv+8azcgPGYi9EBWLLtcj0HFBSbF
	 sr6MyDusupdGl1EuG1xvvtMG87CRRFjLaATfx2Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 034/518] iio: accel: kxsd9: fix runtime PM imbalance on write_raw() error
Date: Thu, 16 Jul 2026 15:25:02 +0200
Message-ID: <20260716133048.524500860@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biren Pandya <birenpandya@gmail.com>

commit 44a5fd874bb6873bdaec59f722c1d57832fbc9df upstream.

kxsd9_write_raw() takes a runtime PM reference with pm_runtime_get_sync()
but returns -EINVAL directly when a scale with a non-zero integer part is
requested, skipping the matching pm_runtime_put_autosuspend(). This leaks
a runtime PM usage-counter reference on every such write, after which the
device can no longer autosuspend.

Set the error code and fall through to the existing put instead of
returning early.

Fixes: 9a9a369d6178 ("iio: accel: kxsd9: Deploy system and runtime PM")
Signed-off-by: Biren Pandya <birenpandya@gmail.com>
Assisted-by: Claude:claude-opus-4-8 coccinelle
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/kxsd9.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/accel/kxsd9.c
+++ b/drivers/iio/accel/kxsd9.c
@@ -147,8 +147,9 @@ static int kxsd9_write_raw(struct iio_de
 	if (mask == IIO_CHAN_INFO_SCALE) {
 		/* Check no integer component */
 		if (val)
-			return -EINVAL;
-		ret = kxsd9_write_scale(indio_dev, val2);
+			ret = -EINVAL;
+		else
+			ret = kxsd9_write_scale(indio_dev, val2);
 	}
 
 	pm_runtime_put_autosuspend(st->dev);


