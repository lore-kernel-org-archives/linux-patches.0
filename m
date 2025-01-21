Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C491E1F470A;
	Tue, 21 Jan 2025 18:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482441; cv=none; b=OrbwybviR5DM9z9uW2ZGfJv78W0abC4SdsInsIkYRdAQdQFwwbrb817XDb30ndq405PIgNsTz5OIlqQkJ+ZVCZam8PYzYg+wqcWxftW9TfnksztKRzqsE8jM2vIPdw+uuMB/DEJUla2GSkT/vw6yAHPVvbJ+7JtGafm6u/8TZWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482441; c=relaxed/simple;
	bh=liFYInXowpa4b16cRHpUyNkVuOtXOFDWZAOeXvSV3fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkXbn1CNTPh5AZATpbiKEcBPBKiJQCHwo4XXaG276QNfqDdCTX8aQamK9OjXOD69GaASNsYGyh2ebrLEuLD7i7PjAIw3tHcP/x4/ivXNSCe9FCWmx8tlWo4aAFTRnJuL8pEVr/Trbog/b5RwYX75USAjEIorhJeLDA27+I0Y7EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfU0nn7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfU0nn7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAC5C4CEDF;
	Tue, 21 Jan 2025 18:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482440;
	bh=liFYInXowpa4b16cRHpUyNkVuOtXOFDWZAOeXvSV3fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LfU0nn7cJa3GZvqETnX2zlKCnram6txxC7zIkeD5sxR6jdHCqFbNn0IYBRY3x18ao
	 Uk03Yqeq7NzgujkDsPR2cNeVFd23feRONfN1ODIrsNAl4zjXACBo2EARR4nw29Y/bk
	 rnqgXRJsyqMeRQw1FXTh4oSj9fuI5b2JT40WsXl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 078/122] zram: fix potential UAF of zram table
Date: Tue, 21 Jan 2025 18:52:06 +0100
Message-ID: <20250121174536.019761751@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1349,6 +1349,7 @@ static bool zram_meta_alloc(struct zram
 	zram->mem_pool = zs_create_pool(zram->disk->disk_name);
 	if (!zram->mem_pool) {
 		vfree(zram->table);
+		zram->table = NULL;
 		return false;
 	}
 


