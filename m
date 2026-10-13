Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12003E8338;
	Tue, 13 Oct 2026 12:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895336; cv=none; b=MVemsQy/ccoggRDaJI2wmeHddOXmi/L7oPgMwo51N4BIRX8f7mvBKiLohCzEmDz5xYr3oEFKbyGcqgrbVvISQ+LC7CoY8+N3VFRs+cSfdzuLV26rqbpk+3N4++IH3r8ITqbIGQukAB3ni0StnzreRia/bOhpefSLK8P1PmSwjqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895336; c=relaxed/simple;
	bh=K2qCOam9JQ4Cn8oLq6u99v7XVlHOY6ajVDX5oFntP2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBdtZmeeqdoUJfmec6cfSbkPCZm7PCI0eqtM0Un6kUAIjyJGjxqlBMJSV2UMH+ifvRDFsTjcbS5p1jQyr7sNBvdbhuK23VJ0+IHIF0xSsbNHkYi8jwt9apmVAzdZ0I14WbE1AKUMqf+5qKxehffZ72xGV/6ahPTY1nmUsT2dtXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUi+rjAN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUi+rjAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030E41F000FF;
	Tue, 13 Oct 2026 12:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895335;
	bh=JpY0koXRmvyMOgsoIvKRxKDF99EAa1hV8Q9ZgQbpxR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUi+rjANPDSY0uEUxm+XLLuMDDlDT7DRfoZDf51irwSEE954ApFGsxhrppqB+ATEx
	 ttMvNrZjs9DMRp8UxpBwSRd3NhBBVzhE2duqAGSBMJrb4oT/peRWxmPG3yC+rHylVx
	 QY8x5Edt/x9irp4sss9+CpQotBAje9wZKVC/4p5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 241/497] iio: frequency: admv1013: fix wrong channel field used in admv1013_read_raw()
Date: Tue, 13 Oct 2026 13:36:48 +0200
Message-ID: <20261013112913.615645962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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


