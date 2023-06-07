Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1753F3AE76
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C826C433D2;
	Wed,  7 Jun 2023 20:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169841;
	bh=bGHS3tOR1qiz/0FkRLD/dcSGoDztp6yKtm9PHrVJ4SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y7Rle1iEHlXr0gnQapGUV8VUkxKiSz3N0b1EsxpQgvJ/erBonvCZljPklacJ95exp
	 j/TIEzJfKk8cM/FRqWXbd1CywuB1GvPK74McZcdyzM3phzPUsHocQmHZVuF/cb5n9c
	 HQZjNz080pTg+2ddfDff7jpRXp/zZuTKsIMn50fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.3 235/286] module/decompress: Fix error checking on zstd decompression
Date: Wed,  7 Jun 2023 22:15:34 +0200
Message-ID: <20230607200930.974276492@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lucas De Marchi <lucas.demarchi@intel.com>

commit fadb74f9f2f609238070c7ca1b04933dc9400e4a upstream.

While implementing support for in-kernel decompression in kmod,
finit_module() was returning a very suspicious value:

	finit_module(3, "", MODULE_INIT_COMPRESSED_FILE) = 18446744072717407296

It turns out the check for module_get_next_page() failing is wrong,
and hence the decompression was not really taking place. Invert
the condition to fix it.

Fixes: 169a58ad824d ("module/decompress: Support zstd in-kernel decompression")
Cc: stable@kernel.org
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module/decompress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/module/decompress.c b/kernel/module/decompress.c
index e97232b125eb..8a5d6d63b06c 100644
--- a/kernel/module/decompress.c
+++ b/kernel/module/decompress.c
@@ -257,7 +257,7 @@ static ssize_t module_zstd_decompress(struct load_info *info,
 	do {
 		struct page *page = module_get_next_page(info);
 
-		if (!IS_ERR(page)) {
+		if (IS_ERR(page)) {
 			retval = PTR_ERR(page);
 			goto out;
 		}
-- 
2.41.0



