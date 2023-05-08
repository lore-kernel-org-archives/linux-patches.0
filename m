Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F9C320A
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E72C433EF;
	Mon,  8 May 2023 11:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544720;
	bh=W5dXkr+r5xUyDXHbAK4x4mXIDeWryIxamq/GQNcZtTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzkFf8ACrCWPr8d9qMoaXwi9qmwWkYnp2ZGzt8rC095j6JnCYholOvsi7AAKPzXCD
	 VqoViu1RFscHRf9F1JxIjvWIZMT4raClky4LkFJu5CImi6bq6bvASFKMstBMDjqQoa
	 NOQTT0bfSpNJFuxa8yZIBh3leR4CL+UI/sT4Zedg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Gorski <piotrgorski@cachyos.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Ira Weiny <ira.weiny@intel.com>,
	"Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 502/694] module/decompress: Never use kunmap() for local un-mappings
Date: Mon,  8 May 2023 11:45:37 +0200
Message-Id: <20230508094450.373771610@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabio M. De Francesco <fmdefrancesco@gmail.com>

[ Upstream commit 3c17655ab13704582fe25e8ea3200a9b2f8bf20a ]

Use kunmap_local() to unmap pages locally mapped with kmap_local_page().

kunmap_local() must be called on the kernel virtual address returned by
kmap_local_page(), differently from how we use kunmap() which instead
expects the mapped page as its argument.

In module_zstd_decompress() we currently map with kmap_local_page() and
unmap with kunmap(). This breaks the code and so it should be fixed.

Cc: Piotr Gorski <piotrgorski@cachyos.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Fixes: 169a58ad824d ("module/decompress: Support zstd in-kernel decompression")
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Piotr Gorski <piotrgorski@cachyos.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/decompress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/module/decompress.c b/kernel/module/decompress.c
index bb79ac1a6d8f7..7ddc87bee2741 100644
--- a/kernel/module/decompress.c
+++ b/kernel/module/decompress.c
@@ -267,7 +267,7 @@ static ssize_t module_zstd_decompress(struct load_info *info,
 		zstd_dec.size = PAGE_SIZE;
 
 		ret = zstd_decompress_stream(dstream, &zstd_dec, &zstd_buf);
-		kunmap(page);
+		kunmap_local(zstd_dec.dst);
 		retval = zstd_get_error_code(ret);
 		if (retval)
 			break;
-- 
2.39.2



