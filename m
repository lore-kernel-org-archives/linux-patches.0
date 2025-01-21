Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5C61F55ED;
	Tue, 21 Jan 2025 17:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482119; cv=none; b=GrG28V7UpZoe6OA9PRtX8YouxIDqP7kChr71OcE0ERl4U0wnOmtJ/W0M3yHz84ab15oPI69XxHhyxN6zefTkRfOiGiewoHzeDpL29AO43XdMqNSamEw4d14kUIpsO82JmJqBbs6CfjMp9e2UwCGzq2zBoOhMRAgaWv/3gtqSXeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482119; c=relaxed/simple;
	bh=2BxWNNrboKBiP9WCYb14QQnmNH7iYELSHPUq7HZ4xs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8BDFo1EChdZGifLVhysloqqcjZO0Km4OwBduxzUJbst+nG3SsAn5v/pDlXQXNBlUhS4UIpfgwKaXH1mPV2ikf1UvrlFGxDVJqrFjxQfyihrBOgtQ05NRRjcHUf1WunIcVjeHI/EEEKsv8SXcsiufcY66My8//Z0JtTSgpWY4p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQpmhcj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQpmhcj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F6AC4CEDF;
	Tue, 21 Jan 2025 17:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482117;
	bh=2BxWNNrboKBiP9WCYb14QQnmNH7iYELSHPUq7HZ4xs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQpmhcj05byBJplBTsW7KPi8yQvIt7jmz8FVa66PIsJWgCqfM8sXQUjyB86mneMBi
	 PpJNP1lobN33STpQtTpfIJyzsfYAY8P/w3nh3SalYMDfqI2t3BjyEXuofHv5/TXRG8
	 VHrIn58NsJ2vB0FrkOgaW0RuYmO1lAjX/oN4zrmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 39/72] zram: fix potential UAF of zram table
Date: Tue, 21 Jan 2025 18:52:05 +0100
Message-ID: <20250121174524.928767055@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kairui Song <kasong@tencent.com>

commit 212fe1c0df4a150fb6298db2cfff267ceaba5402 upstream.

If zram_meta_alloc failed early, it frees allocated zram->table without
setting it NULL.  Which will potentially cause zram_meta_free to access
the table if user reset an failed and uninitialized device.

Link: https://lkml.kernel.org/r/20250107065446.86928-1-ryncsn@gmail.com
Fixes: 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing device")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by:  Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1262,6 +1262,7 @@ static bool zram_meta_alloc(struct zram
 	zram->mem_pool = zs_create_pool(zram->disk->disk_name);
 	if (!zram->mem_pool) {
 		vfree(zram->table);
+		zram->table = NULL;
 		return false;
 	}
 


