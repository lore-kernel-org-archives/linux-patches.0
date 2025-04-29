Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E775024113A;
	Tue, 29 Apr 2025 16:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945379; cv=none; b=eH/KSqsRjHKB+FyClqDGbtrliJ8JB/TqHrzTnEiwt5RtZS/bOaxEbaAFewIZxo1jowdhrJepK5v24M31cJqkdrOuvbXzUFIcYJf25pL9yIzQHb2JlAhdrfTVjynb85Kh09VZrne0DTU2IXI9ylfibHiY2N0JMDmXKCuGoyzOwNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945379; c=relaxed/simple;
	bh=lGBNf56XkdNg6UWSpva5iXYkJoQmjeklKtP7Gkuh9lA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHGkJJW8kUlVAhz8ixFUQTD5+YzKAgPEwfwl/TNkzvxcS9iHPLGPpSlMu8APbOqJpt2wwQRoaBxa4CGf5ove8XGDJaSjsvtROn0GYsrzCFR5Oocovr2DIB3LWKSktolTrSdx7j2oaX+M6wu+dbXeHpUSd7Cd5XKrPxGTccyoJ/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boPgWl3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boPgWl3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBD9C4CEE3;
	Tue, 29 Apr 2025 16:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945378;
	bh=lGBNf56XkdNg6UWSpva5iXYkJoQmjeklKtP7Gkuh9lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boPgWl3Ay2j1gXfSPV+q/Ol0VSERxsVaHAGGhZ7ucjHoEpj4k3X+/S5EnN9QylEyo
	 XelhYzVdY+ss6E8cILw88gY2sA3whaTS2go4t/UnZZ7h7K067TCfM7/Y9gmRoeOO8O
	 XB8/og+ZGlgrnJZr4VUmBGEWmanq9YPHqxQatAhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karina Yankevich <k.yankevich@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.4 052/179] media: v4l2-dv-timings: prevent possible overflow in v4l2_detect_gtf()
Date: Tue, 29 Apr 2025 18:39:53 +0200
Message-ID: <20250429161051.505613099@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karina Yankevich <k.yankevich@omp.ru>

commit 3edd1fc48d2c045e8259561797c89fe78f01717e upstream.

In v4l2_detect_gtf(), it seems safer to cast the 32-bit image_width
variable to the 64-bit type u64 before multiplying to avoid
a possible overflow. The resulting object code even seems to
look better, at least on x86_64.

Found by Linux Verification Center (linuxtesting.org) with Svace.

[Sergey: rewrote the patch subject/descripition]

Fixes: c9bc9f50753d ("[media] v4l2-dv-timings: fix overflow in gtf timings calculation")
Cc: stable@vger.kernel.org
Signed-off-by: Karina Yankevich <k.yankevich@omp.ru>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -755,7 +755,7 @@ bool v4l2_detect_gtf(unsigned frame_heig
 		u64 num;
 		u32 den;
 
-		num = ((image_width * GTF_D_C_PRIME * (u64)hfreq) -
+		num = (((u64)image_width * GTF_D_C_PRIME * hfreq) -
 		      ((u64)image_width * GTF_D_M_PRIME * 1000));
 		den = (hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000) *
 		      (2 * GTF_CELL_GRAN);
@@ -765,7 +765,7 @@ bool v4l2_detect_gtf(unsigned frame_heig
 		u64 num;
 		u32 den;
 
-		num = ((image_width * GTF_S_C_PRIME * (u64)hfreq) -
+		num = (((u64)image_width * GTF_S_C_PRIME * hfreq) -
 		      ((u64)image_width * GTF_S_M_PRIME * 1000));
 		den = (hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000) *
 		      (2 * GTF_CELL_GRAN);


