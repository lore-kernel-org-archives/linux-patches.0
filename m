Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0581621312A;
	Tue, 12 Nov 2024 10:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408158; cv=none; b=Wa0G6hk7l/JXsf0XhbZZO8DIXdPR00yRRTijFcIYv4jNuP+Sl5XUQMM+UGdtwXccXvzD2A2BUUE87DQ8R8Oh5Oc3Yqxp86kJmKJitzn+6DdWLHIIQhM6Puuij9Z2C8/TI/M1QHOK9IMBtG8fjmCUU/TOxF+E/HOqA4zIFu+YNYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408158; c=relaxed/simple;
	bh=JzxVm3CRRD8wnUkaNs8Mr0/ZjcpUMhPnu3esRiKFpac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7q5yHSwU0xwBwoxRRm6XVcoix+JAvpvaLH+Q1BZmRqVoFgZX0StyW4pIlaP5WWVoHQpT5OUVYotZlN+ogpNb/t3moNN7cX7GsaJhNYh8hs5VKxdRn5mMhmUptsd1FmasUKdrDweKFLXolSDMwqRH3oXDOgVogHdRId7jizsZf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SyYUigRv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SyYUigRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306A7C4CECD;
	Tue, 12 Nov 2024 10:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408157;
	bh=JzxVm3CRRD8wnUkaNs8Mr0/ZjcpUMhPnu3esRiKFpac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SyYUigRvBgS8zWXkCssCbmJ19h52B8ciNl+uyZDslGchoxaRKmvJOPTpKdGzeLWjV
	 QQz+jYD/F4em2zz/WMcO3DTGJBG26e1vqkSwnhVX+HGG9cp1PCfsfiT+M00ca5uSAS
	 2PGLbZRldCciQeNcS9Yk946BHK/3Y8TtOD+DKVz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jacek Anaszewski <jacek.anaszewski@gmail.com>
Subject: [PATCH 6.11 078/184] media: s5p-jpeg: prevent buffer overflows
Date: Tue, 12 Nov 2024 11:20:36 +0100
Message-ID: <20241112101903.855111909@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/platform/samsung/s5p-jpeg/jpeg-core.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/media/platform/samsung/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/samsung/s5p-jpeg/jpeg-core.c
@@ -775,11 +775,14 @@ static void exynos4_jpeg_parse_decode_h_
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
 
@@ -1058,6 +1061,7 @@ static int get_word_be(struct s5p_jpeg_b
 	if (byte == -1)
 		return -1;
 	*word = (unsigned int)byte | temp;
+
 	return 0;
 }
 
@@ -1145,7 +1149,7 @@ static bool s5p_jpeg_parse_hdr(struct s5
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
-			if (!length)
+			if (length <= 0)
 				return false;
 			sof = jpeg_buffer.curr; /* after 0xffc0 */
 			sof_len = length;
@@ -1176,7 +1180,7 @@ static bool s5p_jpeg_parse_hdr(struct s5
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
-			if (!length)
+			if (length <= 0)
 				return false;
 			if (n_dqt >= S5P_JPEG_MAX_MARKER)
 				return false;
@@ -1189,7 +1193,7 @@ static bool s5p_jpeg_parse_hdr(struct s5
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
-			if (!length)
+			if (length <= 0)
 				return false;
 			if (n_dht >= S5P_JPEG_MAX_MARKER)
 				return false;
@@ -1214,6 +1218,7 @@ static bool s5p_jpeg_parse_hdr(struct s5
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
+			/* No need to check underflows as skip() does it  */
 			skip(&jpeg_buffer, length);
 			break;
 		}


