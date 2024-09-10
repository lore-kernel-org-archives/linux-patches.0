Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FFE1A00CF;
	Tue, 10 Sep 2024 10:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963450; cv=none; b=Hi4r1fhCwCXuB5iDg1aoRBIh0Md2WE7iH1th7wQPhmE+lGJRyq937D3+XUTaxeOkueZqDqa0MQGTXZBR7qv7r5C1+GEG2V/gQXm5yRt1bnNoU27j9smgHsn3in21x8lBmk5ClN2DQMRqr0/7OQFJUd+IijAdE3AcVTWr/zlCx7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963450; c=relaxed/simple;
	bh=AkqDv6iQwvq74hDAOYoxTeJVLHVDX/8BF6konN3OOs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=df9J2/Eo0z8K8QlMk+figjorVDsYmPVayRedvLuNcBm6CitvdlQkkkWAOyF8SKXK9w7seBWls1ahBfG+6+1VH1n5eKtS+0ch0ySAo5xNCbkXuiOThMZ3TNbca3vRsDjxQNiFtOEnuDt36bOYZ8Ox+5m91bVP+lVH8fILjexy3mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wydP23Rf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wydP23Rf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC80CC4CEC3;
	Tue, 10 Sep 2024 10:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963450;
	bh=AkqDv6iQwvq74hDAOYoxTeJVLHVDX/8BF6konN3OOs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wydP23RfkEU0dEhjdgRuALQlIbMxAZgMpi4d6Nq7p9tJKCMxSYOdSQVljT5tMdcHv
	 uGllV+/yL0dt7LoHk9LI+Gp/lsKRYnhvKAJum3EkuESZXtiF1ZuBzY1+lUvmMyNGdJ
	 +ULvi4FdNQo+88c4GCrGrnT0nt3LIaLwE/BogPQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/214] media: uvcvideo: Enforce alignment of frame and interval
Date: Tue, 10 Sep 2024 11:31:16 +0200
Message-ID: <20240910092600.971564051@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit c8931ef55bd325052ec496f242aea7f6de47dc9c ]

Struct uvc_frame and interval (u32*) are packaged together on
streaming->formats on a single contiguous allocation.

Right now they are allocated right after uvc_format, without taking into
consideration their required alignment.

This is working fine because both structures have a field with a
pointer, but it will stop working when the sizeof() of any of those
structs is not a multiple of the sizeof(void*).

Enforce that alignment during the allocation.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20240404-uvc-align-v2-1-9e104b0ecfbd@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -936,16 +936,26 @@ static int uvc_parse_streaming(struct uv
 		goto error;
 	}
 
-	size = nformats * sizeof(*format) + nframes * sizeof(*frame)
+	/*
+	 * Allocate memory for the formats, the frames and the intervals,
+	 * plus any required padding to guarantee that everything has the
+	 * correct alignment.
+	 */
+	size = nformats * sizeof(*format);
+	size = ALIGN(size, __alignof__(*frame)) + nframes * sizeof(*frame);
+	size = ALIGN(size, __alignof__(*interval))
 	     + nintervals * sizeof(*interval);
+
 	format = kzalloc(size, GFP_KERNEL);
-	if (format == NULL) {
+	if (!format) {
 		ret = -ENOMEM;
 		goto error;
 	}
 
-	frame = (struct uvc_frame *)&format[nformats];
-	interval = (u32 *)&frame[nframes];
+	frame = (void *)format + nformats * sizeof(*format);
+	frame = PTR_ALIGN(frame, __alignof__(*frame));
+	interval = (void *)frame + nframes * sizeof(*frame);
+	interval = PTR_ALIGN(interval, __alignof__(*interval));
 
 	streaming->format = format;
 	streaming->nformats = 0;


