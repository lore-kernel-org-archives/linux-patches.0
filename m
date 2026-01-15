Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B4F3D2FF3;
	Thu, 15 Jan 2026 17:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499712; cv=none; b=d2GJri83b4Lb1pxmo3rAVTmOtfWIzmduRBRMFRDbwcJDUkk/1c5jYw+eH0+U7jwb8Lj9oAc0po3ptSU+rHhhj8QzKMuDRfSgFxbS+HiJYAarR6SJG7KAsKAKqmoHknwf2xihtoi5wIujkejhzO6R9WsVfdXoXSUY3mA9LuzSIfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499712; c=relaxed/simple;
	bh=Ftvy68mwZDd5aZeZjMIQ2pPoMGlLa/+YQTJNGvqudw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIWflXKU3PrLHcIYHwnGHnaUwKd3fKcf8l0VRAaXdZAyaCh8riC3EEPtk8eIXnag5tsGh+2ypX+f81UUMkRXk8HfQIDOJTGAZuXE/VznTALtD2NZQ8a8/B43zlcj3v+nq8jc1CUg3owmohvRCJRCcHRc+nMax0eQRm3GumS8jEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkMk0w+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkMk0w+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E501AC116D0;
	Thu, 15 Jan 2026 17:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499712;
	bh=Ftvy68mwZDd5aZeZjMIQ2pPoMGlLa/+YQTJNGvqudw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkMk0w+wJvC6Cf7KQ6Cvw2S5H5/ZL6Bghk1x1YcrOB6o5ivSkF/BHlr0AXYSVgNEh
	 Db47CD+FY4V5PRaWjJkM/DjxhLtDlyYAY9Rs+6GtkBWUiqRSpbb6uosazi7zbNalQo
	 twuT/uKS7y4LNwpPVsgv5DJj7qv8am8W60VWTZuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 323/451] media: msp3400: Avoid possible out-of-bounds array accesses in msp3400c_thread()
Date: Thu, 15 Jan 2026 17:48:44 +0100
Message-ID: <20260115164242.584701970@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Abramov <i.abramov@mt-integration.ru>

commit d2bceb2e20e783d57e739c71e4e50b4b9f4a3953 upstream.

It's possible for max1 to remain -1 if msp_read() always fail. This
variable is further used as index for accessing arrays.

Fix that by checking max1 prior to array accesses.

It seems that restart is the preferable action in case of out-of-bounds
value.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 8a4b275f9c19 ("V4L/DVB (3427): audmode and rxsubchans fixes (VIDIOC_G/S_TUNER)")
Cc: stable@vger.kernel.org
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/msp3400-kthreads.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/i2c/msp3400-kthreads.c
+++ b/drivers/media/i2c/msp3400-kthreads.c
@@ -592,6 +592,8 @@ restart:
 				"carrier2 val: %5d / %s\n", val, cd[i].name);
 		}
 
+		if (max1 < 0 || max1 > 3)
+			goto restart;
 		/* program the msp3400 according to the results */
 		state->main = msp3400c_carrier_detect_main[max1].cdo;
 		switch (max1) {


