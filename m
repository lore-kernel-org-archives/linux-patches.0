Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8328C2571BD;
	Thu, 17 Apr 2025 18:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914478; cv=none; b=FawkxnJXFJiXV8yuwtIem7ZBbQrYKSQFDMq/Cqrg9Xa7rJaXOzFStIQwiW2nh2wAHaU3IFFsu2er3wzltj0t028P93Is0VLKKknN5XF08BFFx6N9Wl5s2wKZsEy8NsltzNgZxQvOd+qNPrpvwuBnUjIPHnytkW3fZn5r4f5yu2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914478; c=relaxed/simple;
	bh=oilpsKq+K0Xh7eTQKGmuRVAiBzMYYoh53zH2t3dkAtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcaZmPcvtrtbHDi+bNwN//prh036lwCwxqcB2wN1hRhBs5YBZe9tuEstzbaud6yRLxufHvCZO6OSj/zlrDCBF1+oe6VB5l8QFi2RBZTqZvkiyMKvyf87PxTxsuPYIAFPb/5UaHGw5B7zs2FsPFdcOFMujkxKMHBZE2MlSAb5/0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTOdHaed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTOdHaed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB6CC4CEE4;
	Thu, 17 Apr 2025 18:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914478;
	bh=oilpsKq+K0Xh7eTQKGmuRVAiBzMYYoh53zH2t3dkAtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTOdHaedVOa+K6KA8Q0Nek9I3R0E6FEL6Q0B+XHYytscS/HHg/NKajD9LAXr2jgpP
	 4rs4ZezKCoKk0/StWQoKPdAjrwK0asYfpC+htqBhTB0x4VzDakHNPMqhIFIAGpCozx
	 bmTO/Frc5tJjOvNAxnSbhOVIfypRqyuAHrSLxDhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karina Yankevich <k.yankevich@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 228/414] media: v4l2-dv-timings: prevent possible overflow in v4l2_detect_gtf()
Date: Thu, 17 Apr 2025 19:49:46 +0200
Message-ID: <20250417175120.604612617@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -764,7 +764,7 @@ bool v4l2_detect_gtf(unsigned int frame_
 		u64 num;
 		u32 den;
 
-		num = ((image_width * GTF_D_C_PRIME * (u64)hfreq) -
+		num = (((u64)image_width * GTF_D_C_PRIME * hfreq) -
 		      ((u64)image_width * GTF_D_M_PRIME * 1000));
 		den = (hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000) *
 		      (2 * GTF_CELL_GRAN);
@@ -774,7 +774,7 @@ bool v4l2_detect_gtf(unsigned int frame_
 		u64 num;
 		u32 den;
 
-		num = ((image_width * GTF_S_C_PRIME * (u64)hfreq) -
+		num = (((u64)image_width * GTF_S_C_PRIME * hfreq) -
 		      ((u64)image_width * GTF_S_M_PRIME * 1000));
 		den = (hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000) *
 		      (2 * GTF_CELL_GRAN);


