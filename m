Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DF721D00A;
	Sat, 12 Sep 2026 11:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213763; cv=none; b=AM3YZeS2fF/4zjrCGsNn9njQTY7l25GpZKqNr/GnhH7LR9IDHbqprPKMfzKOMapPorfqlNd7zyES6K/BZH5DySJnqzGFpGmJ+LAeN6VjVG1lmswu+2NJHJA2vutrU1aa91PwzLUNFO2RoG7du5KhYseqZROLKcVGwvhUOKbwaSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213763; c=relaxed/simple;
	bh=XWv3aBAOMddbTbHZDn3MmKUhh5tkibRjPKqd/Tn5cR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ql5+6Y8V3qlyjgiDatXJHOtxt9I8ZYALdQD53LmflX47hbzZsLgCvCD+bW1vFrVimoQb4lAGxqo8UDcV8No1HfNnL9By1m5T3yrbTksJm9mTWmFkiNfx2C3OSusSjA96qvwt8yCsL3WjligX1cGtXYO2PrroCJPciMfxHQR13wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iW+5s8W7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iW+5s8W7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948B81F000FF;
	Sat, 12 Sep 2026 11:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213762;
	bh=JlRe5xMCaxCiuLPLFuOrDCryS2JUeqnGpJ+1Ifv+460=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iW+5s8W79SEPF+Snj9H+tzaGsL1PCyr36t/CulD6oy2wW7uS+/8kWfgIgmIe9yD4i
	 1yf9O12MpdilxPxEBbDQF51eNai40ML4kjQNtNJOKIUVIhgLm3V5Tk5bz4lBkEccSU
	 IUsvq3J6iI6CxnF9qLYEotiDAco+7lrq8W/Y7QqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giorgi Tchankvetadze <giorgi@tchankvetadze.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 0144/1376] iio: light: cm32181: return zero after writing calibscale
Date: Sat, 12 Sep 2026 08:42:50 +0200
Message-ID: <20260912065610.762453944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>

commit 8756acd30919a3e9f547ea4a1d4b7f7895f4d340 upstream.

The write_raw callback is documented to return 0 on success or a
negative error code.  However, the IIO_CHAN_INFO_CALIBSCALE case
returns 'val' (the user-supplied value) instead of 0.

Fix it by returning 0 on success, matching the behavior of other
calibscale implementations in the subsystem.

Fixes: 971672c0b3cc ("iio: add Capella CM32181 ambient light sensor driver.")
Signed-off-by: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/cm32181.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/cm32181.c
+++ b/drivers/iio/light/cm32181.c
@@ -370,7 +370,7 @@ static int cm32181_write_raw(struct iio_
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBSCALE:
 		cm32181->calibscale = val;
-		return val;
+		return 0;
 	case IIO_CHAN_INFO_INT_TIME:
 		ret = cm32181_write_als_it(cm32181, val2);
 		return ret;


