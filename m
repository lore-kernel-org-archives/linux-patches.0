Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621683;
	b=Qung2y9bC864oyGbhltHk7bpGKN2O6OdXBApYOvWPTUT+iVn7vQrWMTQXIrTN0+ubBCZ
	 96fyzc5CC3l9GXbcT7Plowpbpg/S3IkdCXCMeZRoBojIDZ8weN3SrSGeROJFK+2TpOy+O
	 uJ3Xnbi+48CA31u7TeIeGF8NA3VRpDm+JQvNkxoN4UrAbausHvDg6occvLeHH9LepRlVo
	 mhlswIArgVy3AVBt2mRMfTmTYX1HJPAq8CkqR6Rzdn+p2bsJ+Z9ry/0qDujkZNx2JaETK
	 YWf337aTTU5wv8OSCFIo0OGnlwGGDlnfMF3aj+SS/dQjAdZBp1bsxJrJnfygabyAuqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4/ddo22dpjSgffGJAXwNPAM/Wmq06A0Dj+f3GPyxQsI=;
	b=O89PF04g7OyUDOk2D76DwiwPvlBSX+q8r8FcYjriGTff1Up8AdHzCK//kFwatfLElQW2
	 ac/9qfCzb24TfjImSR3/gycKrFeshFJGfEWqSQD6AtF3rEwrN9SrLRde0e7pbi5lfpSEq
	 Nu3Wf3QFloynRBGBADui22UZW6r5z5119Xbp0Ox72c/3Gd9+azwnD3ind+GsmoJIbFM0z
	 71UcsP+QQM5lMRdDma6K59p7QpW+huQe8tlLDJV0hW/4MtxbjvE7AKxUMF9JhTkB2y4Fu
	 o+BTWres7B2qgXV7MowRtERZrhJdH4+yM+QL780T2CH15l0cwBKMnQkpWrybV42KyjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EbLIQNaJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE23606A321;
	Wed, 25 Nov 2026 15:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EbLIQNaJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E141F000CA;
	Wed, 25 Nov 2026 15:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621683;
	bh=4/ddo22dpjSgffGJAXwNPAM/Wmq06A0Dj+f3GPyxQsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EbLIQNaJ3oVs3/KgoBJBdC63trQtljOYZiI/fIb8lVyDkN4kAR0SeJykVtZJOZ0dG
	 bOVGD8CKA46s/LMFQ+bv033+rMm6WAY6E4i88VwlsnNOwTbjorZQhE4f6hQHUgR1rV
	 llJ+Mli6jR+g7sreDAM40utFOikVaiLmwRGTJFz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 301/990] libfs: end offset readdir at positions past DIR_OFFSET_EOD
Date: Wed, 25 Nov 2026 15:27:48 +0100
Message-ID: <20261125143829.141781570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 45eb9737058fa78a73f17a5da55c8cb482c6d5bb ]

offset_dir_llseek() takes any position up to LONG_MAX but
offset_readdir() only skips the walk for DIR_OFFSET_EOD itself. For a
position past it mas_find_rev() starts the walk at the highest offset
in the directory. So an lseek() past the end makes the next
getdents64() return the whole directory again.

Before commit b9b588f22a0c ("libfs: Use d_children list to iterate
simple_offset directories") the walk went up from the position and
found nothing past the end, and dcache_readdir() returns nothing there
either. So only walk for positions below DIR_OFFSET_EOD.

Fixes: b9b588f22a0c ("libfs: Use d_children list to iterate simple_offset directories")
Link: https://patch.msgid.link/20261101-work-libfs-offset_readdir-v2-3-c621125b56d1@kernel.org
Reviewed-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index cb37a117c8e5c..f210c0c642459 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -519,7 +519,7 @@ static int offset_readdir(struct file *file, struct dir_context *ctx)
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
-	if (ctx->pos != DIR_OFFSET_EOD)
+	if (ctx->pos < DIR_OFFSET_EOD)
 		offset_iterate_dir(file, ctx);
 	return 0;
 }
-- 
2.53.0



