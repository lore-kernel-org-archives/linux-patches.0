Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECC833B971;
	Tue,  6 Jan 2026 17:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720989; cv=none; b=gFT3GamIx/xROe/RzdHpjql+xrgooSpCoGjoYQAb1OOSW26QXX5G+bmzbtpLec4OzROOYqbwCjDlAdGHcJIS1b3hnJUbjTR9J4bvR7L6GSdfeCKH8YD9/+7sw6FJ16ntxzqZRMo2ZaaRV68xpFgtl5xD8v4okvswrZ3JkCGTtW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720989; c=relaxed/simple;
	bh=YtrwdEBsWo+dZXqUfXhgAmdmkEYffBfxkGAhjIvzHWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQ8jDZHUSm/TPlgLQdaalBSgWNa3rTSGczV0vw4uhmG2haHDklhcgG5UvKKeGUm1o8khttpiuugLZLDUF3oDNl04tjCSxIU08ANvpstBaFDz6k2AdBqYgBK5+9aUh3+y3r3I7zTNG1O8kqgHqfQWfx5ApokvzHjH6kK8rzsrrkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fs+pcGnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fs+pcGnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29B3C116C6;
	Tue,  6 Jan 2026 17:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720989;
	bh=YtrwdEBsWo+dZXqUfXhgAmdmkEYffBfxkGAhjIvzHWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fs+pcGnWz5579tfkPdk0z9R53rieXxpzIisCwUMT8YctTZ1yLACl/F4PniZY5BuW6
	 oCZ1fUz+Njihi4hbS1AyrMHeZSqA4RYEo/5AcX6+IvtXPQRCLD6O0FX/cj6Vs8tVp1
	 /bVVWXK7ZaZTgiYn3zsNyeJM2ZSVbKzd6O2KOZvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 403/567] media: msp3400: Avoid possible out-of-bounds array accesses in msp3400c_thread()
Date: Tue,  6 Jan 2026 18:03:05 +0100
Message-ID: <20260106170506.251385406@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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


