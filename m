Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6668D257855;
	Sun,  7 Jun 2026 10:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828558; cv=none; b=TBOXuwCigs6Ka31rXI6ZY/vuzYDPlhyT64zmbWwUWv/EOqvdTe4wbGzm1oLPpDzYvnzBdPP0LdKWmLW9KARFYWgW4NYH12zTzfHFWDbT3/zak4xUQ17bLYyZ7CXtXhpK7f7TgknIyxEd890yuyd/YP5XdUcnWMQTXEjiwmNv1oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828558; c=relaxed/simple;
	bh=uC71Pn7JU1ZuVv8TWDuRAmn99rjJdcBJumwgg8dPN+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1J/FHikFoTXZRusZCGcsWavxtY+uanMos3wTB64P+oIpZ634wIXc9FBZSB9qD1AnW4iTaCAqmiXzoNYSodt1g57rsIZMVWhhl2YmDQYfssQx3faYi+T8MMlfJE92DypYHHSR3ZsCEDlHydhveGPbkqyvTFdVetdd1XliYDFzHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arIbB2zn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arIbB2zn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7541F00893;
	Sun,  7 Jun 2026 10:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828557;
	bh=CQ1BdSo9LLSlrypeM5km6Ra9U3CPXb3DNIbg8p2kkbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=arIbB2znPRSSlWfDGGLAQuejIOyy8uOcs9uppusSDTM2pzUisXqgbq7+mVtpNWrDl
	 2847cs53DCvujz7RXQGpSDXHX4HTBP+ec3Rilc6wlbwSa0M5n6NQRATyVtw4hH4Ixw
	 5N3/KqeGrkr4bgx/gvhYu4KJBdx7wN0J7eoo3eEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 172/315] iio: chemical: scd30: fix division by zero in write_raw
Date: Sun,  7 Jun 2026 11:59:19 +0200
Message-ID: <20260607095733.905000185@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit 5aba4f94b225617a55fed442a70329b2ee19c0a5 upstream.

Add a zero check for val2 before using it as a divisor when setting the
sampling frequency. A user writing a zero fractional part to the
sampling_frequency sysfs attribute triggers a division by zero in the
kernel.

Fixes: 64b3d8b1b0f5 ("iio: chemical: scd30: add core driver")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/scd30_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/scd30_core.c
+++ b/drivers/iio/chemical/scd30_core.c
@@ -256,7 +256,7 @@ static int scd30_write_raw(struct iio_de
 	guard(mutex)(&state->lock);
 	switch (mask) {
 	case IIO_CHAN_INFO_SAMP_FREQ:
-		if (val)
+		if (val || !val2)
 			return -EINVAL;
 
 		val = 1000000000 / val2;


