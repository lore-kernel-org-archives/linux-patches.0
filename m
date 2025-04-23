Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD5D289373;
	Wed, 23 Apr 2025 15:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420939; cv=none; b=bY+/UjUyUWlcdr9ismnn5QCHCp0sfOlbmYaDZbbYwGLJN9dB1LM7R1ipBJBS8M+ATI7U1kutmieAMiI05NX9h28sSwtMJ+mL41dgXtv+ri2ZufrfRErjUkmSe6CJU6yLQ5xr/2TOTqlWIA7OqTGwWBGp/5z2JtFLQwoAwahpPjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420939; c=relaxed/simple;
	bh=gA2lUw3OIS6A1pCJpLRg2ZnpWSAi1Ib/7TOIlVbZylQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlMbEXTZbLq8pZRZZg0vaW2ukpJ6gKd8GNGzoKogjTp2DjXhWajbqF+ttHniy4J6DExVaYzHjA5bHT/2lCdCzKxZRbCivSZ9n1n6Xb8igFsy0Ly27cO3eNCxx71BJZBVSM86wdWYsbLxoijOP/6GVG7EAocKBqz7p153GChfWoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvyUCDz/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvyUCDz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBE5C4CEE2;
	Wed, 23 Apr 2025 15:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420939;
	bh=gA2lUw3OIS6A1pCJpLRg2ZnpWSAi1Ib/7TOIlVbZylQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvyUCDz/TqbOYBoFfygnbHS7bzEhyPqJJ/y0GGcNbAnO79coCStX1xb7Ij3K7c42y
	 fzZ9Nckv3TVf4w/HjEdmovffqSffwLVE6mdBb+UGJa+UjnSNKY8ZQP5BcKAxcTU6lF
	 aXbdrFCULNRJGmKGbHAfLN6ozF7BYkivKPCJYvWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karina Yankevich <k.yankevich@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 094/291] media: v4l2-dv-timings: prevent possible overflow in v4l2_detect_gtf()
Date: Wed, 23 Apr 2025 16:41:23 +0200
Message-ID: <20250423142628.197188677@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


