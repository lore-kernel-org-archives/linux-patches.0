Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CC236B048;
	Tue,  6 Jan 2026 17:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722134; cv=none; b=gnGnK5wzEUZG8Pi8VElgQ1tYGx+uZfw9ypiN96GZx4oMue0rn7mMKDoKNmQ+JVFT2yb7xC0jtfUhjWTOR+Wu9anpPO0AGJwz5purjjt/h3TQ4+HcSQPPe9dh+xwdqfXUsUCiOE2O1rjM+ZFtZ4qPtmcylYSRTz+R/adAQW/DT7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722134; c=relaxed/simple;
	bh=t2+n0P6vQ1Zx8BC2Iq36gF8Yz7zxDDyHq6b0qwRy/8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hqf+GyBX5Kd4mYaDtuS+Ei17L38D/gz3FMoSTBSS0xI7LGSvS+8rNSmW0eOKkDPlS+ffDHo0q9rkvYBkz1CfIymiK0nHRNVyF0y0jQGQku/nQSmGZqdQt6GUoyQbAE9LjaMQGaUKx0DE0wDPpLXvy7ImjT7S8pABXKRFmmC2oV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elMKlnXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elMKlnXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3F9C116C6;
	Tue,  6 Jan 2026 17:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722133;
	bh=t2+n0P6vQ1Zx8BC2Iq36gF8Yz7zxDDyHq6b0qwRy/8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elMKlnXF/bW2wA0nzpV0NXuwJxSJ3ii5KB7sq54nau7H25zrnrQbjZ4Xph/nsLl77
	 j6OeMSPAB+qKo9GseDv2/hqPo+d4yPRuqc5i9aUkAjaPKg74R0HFnmkCHh90i0+aUn
	 zf6I96PNHBOo2+5A5KfdKP8zAPDiB1rV12AUI55A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 176/312] media: msp3400: Avoid possible out-of-bounds array accesses in msp3400c_thread()
Date: Tue,  6 Jan 2026 18:04:10 +0100
Message-ID: <20260106170554.200287695@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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
@@ -596,6 +596,8 @@ restart:
 				"carrier2 val: %5d / %s\n", val, cd[i].name);
 		}
 
+		if (max1 < 0 || max1 > 3)
+			goto restart;
 		/* program the msp3400 according to the results */
 		state->main = msp3400c_carrier_detect_main[max1].cdo;
 		switch (max1) {


