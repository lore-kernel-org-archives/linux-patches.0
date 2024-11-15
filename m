Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF20E645;
	Fri, 15 Nov 2024 06:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652786; cv=none; b=RhQTtjncIYo43twK/ne7wO8Qx4NUOW1/fqo96cHZzmhHOr1PB/ECqVJcnVqmlE3FSIoUtReOZ7vRRfNf6OjCOTvqqCETH2daGtzNs2wfW921WdEOVjc5ZJvaBsT9Sno25PUgkxPdkmeylJQsnVzIKE36m1+LBTLQuGsy+v0n4/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652786; c=relaxed/simple;
	bh=UfHNSl38A/AdVASJxBL/eRYw0bq1psQTUP2NdtZt+0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SH4aXNsJnHzvvGycG4Knrm03/mwYTCgCO2tFVF/bRKQ1ssJNDcBudLxZrC+rUIKWagx8RnDkXQNTPhYbF+6BpNEew6B4+ed7sBm/0KruUGverzsfi3VYOUMBcufoZUzedGUFSCQgDuh+K04cmJt+zpN3FRaQAfk1IqwsbWl1eoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kX7QWVnZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kX7QWVnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41948C4CECF;
	Fri, 15 Nov 2024 06:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652786;
	bh=UfHNSl38A/AdVASJxBL/eRYw0bq1psQTUP2NdtZt+0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kX7QWVnZGIyx87lpfYDdqMUWvS/5s8In5DB+v0mH3WCrGUvaN+gbQnSpH5fwrCWtp
	 6R/L6X38quqKnaeOJiSZJGyJwD7yh+uTRA3LQBCxz/kBPs25XuUkzQR/ILFLkh3mok
	 mk7KwpzFl2i6E3ILzs2bWOgemyIvnqJa8qe2PzJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jacek Anaszewski <jacek.anaszewski@gmail.com>
Subject: [PATCH 4.19 15/52] media: s5p-jpeg: prevent buffer overflows
Date: Fri, 15 Nov 2024 07:37:28 +0100
Message-ID: <20241115063723.406494422@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -803,11 +803,14 @@ static void exynos4_jpeg_parse_decode_h_
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
 
@@ -1086,6 +1089,7 @@ static int get_word_be(struct s5p_jpeg_b
 	if (byte == -1)
 		return -1;
 	*word = (unsigned int)byte | temp;
+
 	return 0;
 }
 
@@ -1173,7 +1177,7 @@ static bool s5p_jpeg_parse_hdr(struct s5
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
-			if (!length)
+			if (length <= 0)
 				return false;
 			sof = jpeg_buffer.curr; /* after 0xffc0 */
 			sof_len = length;
@@ -1204,7 +1208,7 @@ static bool s5p_jpeg_parse_hdr(struct s5
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
-			if (!length)
+			if (length <= 0)
 				return false;
 			if (n_dqt >= S5P_JPEG_MAX_MARKER)
 				return false;
@@ -1217,7 +1221,7 @@ static bool s5p_jpeg_parse_hdr(struct s5
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
-			if (!length)
+			if (length <= 0)
 				return false;
 			if (n_dht >= S5P_JPEG_MAX_MARKER)
 				return false;
@@ -1242,6 +1246,7 @@ static bool s5p_jpeg_parse_hdr(struct s5
 			if (get_word_be(&jpeg_buffer, &word))
 				break;
 			length = (long)word - 2;
+			/* No need to check underflows as skip() does it  */
 			skip(&jpeg_buffer, length);
 			break;
 		}


