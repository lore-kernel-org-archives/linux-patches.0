Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88AD3BB23
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndvcfxMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B61C433C8;
	Wed, 15 Nov 2023 19:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077478;
	bh=Uxjb501i9TR00BFdLPHlTOf+XEWFXnwDbogectWIvik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndvcfxMwMR4B02j7YTWwb5xtwcZ4MMP0H58u5Uyv+fhfsP9NsSdJUHKWqbAwDIMNC
	 nhQVkuJx01/5uJjVYSbnfRuYvVDO2A3dSRpCi0BAX3jIqZaj74hOvTBlGUif4XkrKy
	 fQuqrNO66xUFC1iwRzJe0XP50nCvhsbtxzgf3MWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <andrea.righi@canonical.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 328/603] module/decompress: use vmalloc() for gzip decompression workspace
Date: Wed, 15 Nov 2023 14:14:33 -0500
Message-ID: <20231115191636.206012766@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <andrea.righi@canonical.com>

[ Upstream commit 3737df782c740b944912ed93420c57344b1cf864 ]

Use a similar approach as commit a419beac4a07 ("module/decompress: use
vmalloc() for zstd decompression workspace") and replace kmalloc() with
vmalloc() also for the gzip module decompression workspace.

In this case the workspace is represented by struct inflate_workspace
that can be fairly large for kmalloc() and it can potentially lead to
allocation errors on certain systems:

$ pahole inflate_workspace
struct inflate_workspace {
	struct inflate_state       inflate_state;        /*     0  9544 */
	/* --- cacheline 149 boundary (9536 bytes) was 8 bytes ago --- */
	unsigned char              working_window[32768]; /*  9544 32768 */

	/* size: 42312, cachelines: 662, members: 2 */
	/* last cacheline: 8 bytes */
};

Considering that there is no need to use continuous physical memory,
simply switch to vmalloc() to provide a more reliable in-kernel module
decompression.

Fixes: b1ae6dc41eaa ("module: add in-kernel support for decompressing")
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/decompress.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/module/decompress.c b/kernel/module/decompress.c
index 87440f714c0ca..4156d59be4408 100644
--- a/kernel/module/decompress.c
+++ b/kernel/module/decompress.c
@@ -100,7 +100,7 @@ static ssize_t module_gzip_decompress(struct load_info *info,
 	s.next_in = buf + gzip_hdr_len;
 	s.avail_in = size - gzip_hdr_len;
 
-	s.workspace = kmalloc(zlib_inflate_workspacesize(), GFP_KERNEL);
+	s.workspace = vmalloc(zlib_inflate_workspacesize());
 	if (!s.workspace)
 		return -ENOMEM;
 
@@ -138,7 +138,7 @@ static ssize_t module_gzip_decompress(struct load_info *info,
 out_inflate_end:
 	zlib_inflateEnd(&s);
 out:
-	kfree(s.workspace);
+	vfree(s.workspace);
 	return retval;
 }
 #elif defined(CONFIG_MODULE_COMPRESS_XZ)
-- 
2.42.0



