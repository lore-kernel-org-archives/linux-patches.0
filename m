Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD29646;
	Wed,  6 Nov 2024 13:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899315; cv=none; b=raxyMbC1AgQ7QXdED0yKv/ZZ9DOhjdeHETN4AYBHyPKHWmHoRouWQ87m/mERM5LJ2yvwtoEYp5A6Il4VBU3mqMQuih4KWAJWHgjOB6nGMDlWDhytl9eSD2vqSVUybe1rwN8GTpj9IGMuzuCbAkf6JHJopmqa1b0oGVAM2+2iFo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899315; c=relaxed/simple;
	bh=hrwIEUBiLrMyuRwLW2Q14jmU3PtFK+CCD4R7R5+9yGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yw76cbQ3SXPScKPvSl9SeEDr6wx3q95tXIKchV6DXHH+zJBmUZ3LrNrCSwz6h+Z7CVWA7zLPxwgm+t7G0DoOyWsYrfZhytEqYYmIK8TAkcZ9AgJCNNUsCwbhF3fPsTlgt2XovePASGGb5/dhrzBPF/53j1wQxsdtG2F6jStxqDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpJA8zeX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpJA8zeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D06C4CECD;
	Wed,  6 Nov 2024 13:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899315;
	bh=hrwIEUBiLrMyuRwLW2Q14jmU3PtFK+CCD4R7R5+9yGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpJA8zeXCFP2RbQJfVWI2kOtK3oJuThNneSBzH69iXY9Qzg6IQ5pcCn7NdFmqLcQs
	 Fc21Tg1mNOFJcytEmNQaVbBFQ4a8WCnnEUdB3VC34O3icjqaxbrMVczh/ZY4TxxM6E
	 hsqMC6KDG5N8ka8LgRluihfgoWC7GQrPaAQTMJh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+955da2d57931604ee691@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH 5.15 72/73] vt: prevent kernel-infoleak in con_font_get()
Date: Wed,  6 Nov 2024 13:06:16 +0100
Message-ID: <20241106120302.091550426@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

From: Jeongjun Park <aha310510@gmail.com>

commit f956052e00de211b5c9ebaa1958366c23f82ee9e upstream.

font.data may not initialize all memory spaces depending on the implementation
of vc->vc_sw->con_font_get. This may cause info-leak, so to prevent this, it
is safest to modify it to initialize the allocated memory space to 0, and it
generally does not affect the overall performance of the system.

Cc: stable@vger.kernel.org
Reported-by: syzbot+955da2d57931604ee691@syzkaller.appspotmail.com
Fixes: 05e2600cb0a4 ("VT: Bump font size limitation to 64x128 pixels")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Link: https://lore.kernel.org/r/20241010174619.59662-1-aha310510@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4594,7 +4594,7 @@ static int con_font_get(struct vc_data *
 	int c;
 
 	if (op->data) {
-		font.data = kmalloc(max_font_size, GFP_KERNEL);
+		font.data = kzalloc(max_font_size, GFP_KERNEL);
 		if (!font.data)
 			return -ENOMEM;
 	} else


