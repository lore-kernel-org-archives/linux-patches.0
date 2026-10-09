Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AB6367B8F;
	Fri,  9 Oct 2026 14:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557168; cv=none; b=ZqGD3vVXNwZVG+vQ4giCIgltFz69nZTHI5yuOhU1qDiFRZqpdfS9/UiLnD4Oqgx+Wj/G7uZcPSZo2Yfp+6UQ2xqjvwTP+BsOL1XXfdOIFf/Ja3qATqMn+rb3SFgzzHaZYTt4JkkpddRUAsE39+xjqgXb5D/P4qc5rFzyXEvAOY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557168; c=relaxed/simple;
	bh=heNj1oGhbY39Q3H1foCDpdZtD6+V3pRHHrDOPg5FNUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lO7jGHxZnGQ4mLjCvM4jZMUqQr8McrO4acG/bJttKegC66IW00RAJALsTRbTY+VH1l4nUbxOuu+mxU3ZT+MAt/1jGHarisbVXPsiDOo3fgVncCRRcO55n1K8PyAt9pj5ZRkMXnV6VkJtMP/wUeAhaoJZ+jyRLMYKRVL2wEr4XtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ry6T98ak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ry6T98ak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75241F000FF;
	Fri,  9 Oct 2026 14:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557167;
	bh=65Jg5WKYleU3ZdErzgg+RM3xyS101TRI36nmwSmkASk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ry6T98akiAqN+bylxE8VIoD1IRuli1oxFyjXOttni16Wz8VV0ETXJaj433CWCGyLE
	 7JrZeEdmH51HGhj78I6KtpkmwEV8TqpwoXF+FXv3VsqQjnErDhNHSM4Vn7YBLnybua
	 D4ODF+UcVIm1HQ+57UHyD89ozIF9Isuc1BKLGEFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 323/403] iio: frequency: admv1013: fix wrong channel field used in admv1013_read_raw()
Date: Fri,  9 Oct 2026 16:11:24 +0200
Message-ID: <20261009140959.782974247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit 2093236e886ad9446ec3285ba520e024dd1464e1 upstream.

admv1013_read_raw() switches on chan->channel instead of
chan->channel2 when handling IIO_CHAN_INFO_CALIBBIAS. The channel
field only ever holds 0 or 1 (see ADMV1013_CHAN_CALIB()), while the
IIO_MOD_I / IIO_MOD_Q modifiers are stored in channel2. As a result,
the switch always falls through to the default case and calibbias
reads always fail with -EINVAL, even though the corresponding
admv1013_write_raw() path correctly uses channel2 and works as
expected.

Fix the read path to switch on chan->channel2, matching the write
path and the actual channel_spec definition.

Fixes: da35a7b526d9 ("iio: frequency: admv1013: add support for ADMV1013")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/frequency/admv1013.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/frequency/admv1013.c
+++ b/drivers/iio/frequency/admv1013.c
@@ -196,7 +196,7 @@ static int admv1013_read_raw(struct iio_
 
 	switch (info) {
 	case IIO_CHAN_INFO_CALIBBIAS:
-		switch (chan->channel) {
+		switch (chan->channel2) {
 		case IIO_MOD_I:
 			addr = ADMV1013_REG_OFFSET_ADJUST_I;
 			break;


