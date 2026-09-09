Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A3956B843;
	Wed,  9 Sep 2026 14:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964180; cv=none; b=Vx7QkkLSDtDIdJvvcREBG27D/QzQMzAm4721Mn5SQ4/gkFWP2yNQ48Im4qfNH/RMzjjn5j/kpt57lIctZ2Z/14qxInNxNaAlKowHtv/Xq9mEMOhVN0kfC/Trqv9mFOJOKsW4P8YAM9n5FZRdfOtpG51qjzJ3j6cuf6voVCs0yEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964180; c=relaxed/simple;
	bh=0I84O3v/V2fScIQRfAhVb6O9Vztb5wro8Y3vefi0c10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftcIjKfNvncEGQ1s6ZgBF61B2ntxAJ19d6QaIuTSFQBZHXU0W+DfCF6ejDt07YROa8igvvUjc2xnttLQZA6zzZfqyKVbI1lOq09VjAxSdn36PzR5nBrvW0RH8EQrm61n7Uk57Gc97d9TpYlzCTb24BjHTwkzjENjqyuPtg+YY5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THGkrqWy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THGkrqWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD9C1F00A3A;
	Wed,  9 Sep 2026 14:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964179;
	bh=dS8ocMKQebcB8U78GVIr5o0QLyeN9Keq/Cmp1FNeozk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THGkrqWy/OeOVprS5KOP/3nwFDOwtwdccorMRkToQp9mare2+li9VMP3xU7vrL1TZ
	 SraFREbx/54RWq5e6SU+UPAkBZoh3c+05DwR/IFjuQDhIsMi5QwU1A7CTpHIjW6svQ
	 4+cRHuTxRyHGVguPLd3I/24HTSCHLg8cfbNeblUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 317/583] media: vimc: fix pixel format lookup in enum_framesizes
Date: Wed,  9 Sep 2026 15:40:02 +0200
Message-ID: <20260909134248.988957334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Arash Golgol <arash.golgol@gmail.com>

commit ad4c65fa30cfb00e2e06adae9a8eb407086eaa66 upstream.

vimc_capture_enum_framesizes() looks up the requested format using
vimc_pix_map_by_code(), which searches the pix map table by media
bus code (MEDIA_BUS_FMT_*).

However, v4l2_frmsizeenum::pixel_format holds a V4L2 pixel format
(V4L2_PIX_FMT_*), not a media bus code, so valid pixel formats end
up being rejected with -EINVAL.

Fix this by using vimc_pix_map_by_pixelformat() instead, which
performs the lookup by pixel format as the ioctl expects.

Fixes: 09c41a23a2e2 ("media: Revert "media: vimc: propagate pixel format in the stream"")
Cc: stable@vger.kernel.org
Signed-off-by: Arash Golgol <arash.golgol@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vimc/vimc-capture.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/test-drivers/vimc/vimc-capture.c
+++ b/drivers/media/test-drivers/vimc/vimc-capture.c
@@ -175,8 +175,8 @@ static int vimc_capture_enum_framesizes(
 	if (fsize->index)
 		return -EINVAL;
 
-	/* Only accept code in the pix map table */
-	vpix = vimc_pix_map_by_code(fsize->pixel_format);
+	/* Only accept pixel_format in the pix map table */
+	vpix = vimc_pix_map_by_pixelformat(fsize->pixel_format);
 	if (!vpix)
 		return -EINVAL;
 


