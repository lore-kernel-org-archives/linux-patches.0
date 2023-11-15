Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6DB3C461
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5hK6EOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF83CC433C7;
	Wed, 15 Nov 2023 19:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077126;
	bh=rZTDsPoXI2L4VZFTcFz3RHtYoAxqm1b1lD8hWQV2AvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5hK6EOLYmZCHaqctfKl71zjU2pyXS3jF94EiMmGhfH75aLHlwIG/6eL/0LiiiE3U
	 Q8MonDh4YHRExBmj19v2pfVdFL51RGXWXi8gg7Je0WMwHK9gn52sVHrbePS9O/diPm
	 30z3dDsfRp8/wXLCl96dPHhZWJQ7Pas8dtKaYfLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrea Righi <andrea.righi@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 530/550] module/decompress: use kvmalloc() consistently
Date: Wed, 15 Nov 2023 14:18:34 -0500
Message-ID: <20231115191637.673127331@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <andrea.righi@canonical.com>

[ Upstream commit 17fc8084aa8f9d5235f252fc3978db657dd77e92 ]

We consistently switched from kmalloc() to vmalloc() in module
decompression to prevent potential memory allocation failures with large
modules, however vmalloc() is not as memory-efficient and fast as
kmalloc().

Since we don't know in general the size of the workspace required by the
decompression algorithm, it is more reasonable to use kvmalloc()
consistently, also considering that we don't have special memory
requirements here.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/decompress.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/module/decompress.c b/kernel/module/decompress.c
index 4156d59be4408..474e68f0f0634 100644
--- a/kernel/module/decompress.c
+++ b/kernel/module/decompress.c
@@ -100,7 +100,7 @@ static ssize_t module_gzip_decompress(struct load_info *info,
 	s.next_in = buf + gzip_hdr_len;
 	s.avail_in = size - gzip_hdr_len;
 
-	s.workspace = vmalloc(zlib_inflate_workspacesize());
+	s.workspace = kvmalloc(zlib_inflate_workspacesize(), GFP_KERNEL);
 	if (!s.workspace)
 		return -ENOMEM;
 
@@ -138,7 +138,7 @@ static ssize_t module_gzip_decompress(struct load_info *info,
 out_inflate_end:
 	zlib_inflateEnd(&s);
 out:
-	vfree(s.workspace);
+	kvfree(s.workspace);
 	return retval;
 }
 #elif defined(CONFIG_MODULE_COMPRESS_XZ)
@@ -241,7 +241,7 @@ static ssize_t module_zstd_decompress(struct load_info *info,
 	}
 
 	wksp_size = zstd_dstream_workspace_bound(header.windowSize);
-	wksp = vmalloc(wksp_size);
+	wksp = kvmalloc(wksp_size, GFP_KERNEL);
 	if (!wksp) {
 		retval = -ENOMEM;
 		goto out;
@@ -284,7 +284,7 @@ static ssize_t module_zstd_decompress(struct load_info *info,
 	retval = new_size;
 
  out:
-	vfree(wksp);
+	kvfree(wksp);
 	return retval;
 }
 #else
-- 
2.42.0



