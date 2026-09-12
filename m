Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4C1208D0;
	Sat, 12 Sep 2026 09:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204610; cv=none; b=LVoG8xtnYddWpPfUWMqOvvo+h8dbVA5dbYn8YiY85hSwo5IXfp/nXT+iCBfya+D4vd38MNUUfBfn5Ff2CocFpeQJr29yQ2HRkkFpv5bej4Qu9OnCu6Q94bRKrkk0ywsko8N1IYL5DMbbe+jvNLeCxFrCDlq1bjSJTpwXKpkpkv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204610; c=relaxed/simple;
	bh=v1koBjagE2nAaRMqPW9TpjiHvlzS6OBZ079e2KHIecI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWQjfXrl0LM2A7SDiNq4zgF9r70RXZE4aVVsjHmXZMSjCfiNYeE3jEvNyf7IGZpPMNf226KtHKaFnA2DOmYGrOmSQV20JygGoTTLJ/B/C9OClZ6j+bIFptViOQBuV1dvnIRCA54aN2dmKTDxOaw0aUxOPGLOybz3eLCNi2wK/as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qmh13wfC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qmh13wfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2E81F000FF;
	Sat, 12 Sep 2026 09:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204609;
	bh=ByP61X5UJ2zpuxgXwPk3XcBuYit7lyn50u4uSm59Fb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qmh13wfC+cF41U3VN+mSYI743wc9PHmET4+QBOEkECW7Qw6cfEY+fXvdxdIpGp3cw
	 z+2KPGQDQKJpUl6q7eglsOmglZKPpVc3WJeVHfa5eB/EjmWNdhJikEYWw9cQg7eYvl
	 rXrE2PnXMJ255IFcuArWHuILJmUtxodwPk96alYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1605/1815] ntfs: Remove use of __folio_index in handle_bounds_compressed_page()
Date: Sat, 12 Sep 2026 08:55:55 +0200
Message-ID: <20260912065726.670570606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit a3976da121aef2b9bf0709e0fd257b2a7ae2749c ]

Nobody is supposed to use page->__folio_index.  Use page_offset()
instead, and simplify by working exclusively in loff_t instead of mixing
up loff_t and pgoff_t.

Link: https://lore.kernel.org/all/20260608210618.3437216-3-willy@infradead.org/
Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Co-developed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/compress.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index c904858dff3d2..8078041b87968 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -105,13 +105,15 @@ void free_compression_buffers(void)
 static inline void handle_bounds_compressed_page(struct page *page,
 		const loff_t i_size, const s64 initialized_size)
 {
-	if ((page->__folio_index >= (initialized_size >> PAGE_SHIFT)) &&
+	loff_t pos = page_offset(page);
+
+	if ((pos + PAGE_SIZE > initialized_size) &&
 			(initialized_size < i_size)) {
 		u8 *kp = page_address(page);
 		unsigned int kp_ofs;
 
 		ntfs_debug("Zeroing page region outside initialized size.");
-		if (((s64)page->__folio_index << PAGE_SHIFT) >= initialized_size) {
+		if (pos >= initialized_size) {
 			clear_page(kp);
 			return;
 		}
-- 
2.53.0



