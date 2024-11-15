Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA62154C00;
	Fri, 15 Nov 2024 06:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652987; cv=none; b=lx9/Lv8VLTKUZsW9oZP8k2h4Z/vF012ZUBT66eFc/lfn6JjLP6uyJswb7MV95JhwiJ4DaHGGrZ3POYBEirmX5f8XydUCz8uG+3x75GJZ3PA5zTg5xVYyvDvc5yuU/Jk+rANX3WdKZQ1CfDwG/QbzMzMJFeHo2YRzlFpMfCxQFj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652987; c=relaxed/simple;
	bh=cRJTDV1I4b/1UNt+/1aOkm2nHYMvMXvPlD+M2dSi+BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIpCA5DJgaamNFYvt8+IKHpo4e0rbW8shv8il8SpqFU5m46tKgtNOTOVKDJRLvANXMoyS/8f3VciGkfCFblOKLLwj8Y7+0bxF8qyrVZ+lfqrAyf/hH+wC8Cc4NEBTtCd87F/6LaWaYk+Tq2YNyT/sOIJG8Y22MUhZevUZznx4kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXdXipZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXdXipZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CEBC4CED2;
	Fri, 15 Nov 2024 06:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652986;
	bh=cRJTDV1I4b/1UNt+/1aOkm2nHYMvMXvPlD+M2dSi+BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXdXipZ09gNv0wAw/AJgfWq7Y4usaQy22fRmGG0kxoKM0qEVeBGJAr+3Yd5GwfgUE
	 87mkvkOMt/Chwfxxsd/YI55uPGdjIbVTzfpSXKR16xh/RMexYg9OmJ6GIfTKUE86tq
	 z5sQNM2OJgS7oBKStcaddki7KExWuFFyavl1Ap8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jacek Anaszewski <jacek.anaszewski@gmail.com>
Subject: [PATCH 5.4 21/66] media: s5p-jpeg: prevent buffer overflows
Date: Fri, 15 Nov 2024 07:37:30 +0100
Message-ID: <20241115063723.609323486@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit 14a22762c3daeac59a5a534e124acbb4d7a79b3a upstream.

The current logic allows word to be less than 2. If this happens,
there will be buffer overflows, as reported by smatch. Add extra
checks to prevent it.

While here, remove an unused word = 0 assignment.

Fixes: 6c96dbbc2aa9 ("[media] s5p-jpeg: add support for 5433")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -774,11 +774,14 @@ static void exynos4_jpeg_parse_decode_h_
 		(unsigned long)vb2_plane_vaddr(&vb->vb2_buf, 0) + ctx->out_q.sos + 2;
 	jpeg_buffer.curr = 0;
 
-	word = 0;
-
 	if (get_word_be(&jpeg_buffer, &word))
 		return;
-	jpeg_buffer.size = (long)word - 2;
+
+	if (word < 2)
+		jpeg_buffer.size = 0;
+	else
+		jpeg_buffer.size = (long)word - 2;
+
 	jpeg_buffer.data += 2;
 	jpeg_buffer.curr = 0;
 
@@ -1057,6 +1060,7 @@ static int get_word_be(struct s5p_jpeg_b
 	if (byte == -1)
 		return -1;
 	*word = (unsigned int)byte | temp;
+
 	return 0;
 }
 
@@ -1144,7 +1148,7 @@ static bool s5p_jpeg_parse_hdr(struct s5
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
-			if (!length)
+			if (length <= 0)
 				return false;
 			sof = jpeg_buffer.curr; /* after 0xffc0 */
 			sof_len = length;
@@ -1175,7 +1179,7 @@ static bool s5p_jpeg_parse_hdr(struct s5
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
-			if (!length)
+			if (length <= 0)
 				return false;
 			if (n_dqt >= S5P_JPEG_MAX_MARKER)
 				return false;
@@ -1188,7 +1192,7 @@ static bool s5p_jpeg_parse_hdr(struct s5
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
-			if (!length)
+			if (length <= 0)
 				return false;
 			if (n_dht >= S5P_JPEG_MAX_MARKER)
 				return false;
@@ -1213,6 +1217,7 @@ static bool s5p_jpeg_parse_hdr(struct s5
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
+			/* No need to check underflows as skip() does it  */
 			skip(&jpeg_buffer, length);
 			break;
 		}


