Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D835E1F4275;
	Tue, 21 Jan 2025 18:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482744; cv=none; b=NjHyXfDwWjga6h7q3oRIAGhghuH55dUGag8S8Hh0Be0kGKpboKt1qXOO0Ra5tMTHESwEXDxSWyuL97ILX0i/fSclKC9SysFzR/Q7Is/B9LPRFgQGFeAKq4bILV8YcCPby7y37ILXgZIlH5KlMv1IGUQwNtHBEaMF5577UoKNq70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482744; c=relaxed/simple;
	bh=y3+0ayntGGK5Qc6D5iumBg6+HoxBqqImns6xgkcPzjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seTrDh/QhfvbLHb55Z1UmNvAXGMHYooqFEsqH+8wMlpU06wjLaEqI1aU1Rcd2HWu+m99m6c/05ifVRONUuTaRO+cZ59Rbbv9JmT+VWU38PN61QUU6b1IioGPSY7jTIc8eDQlS7T8e2tdq1Gv2zFWVCsXDI3Y9tVQ1Q3Hc5jTiLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcswT38V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcswT38V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D647C4CEDF;
	Tue, 21 Jan 2025 18:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482744;
	bh=y3+0ayntGGK5Qc6D5iumBg6+HoxBqqImns6xgkcPzjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcswT38VxYfdlb0ZLwmEswClfScdncl0DFjGavcYPmF9J4If7NyaIbJGUxqGRZQQ3
	 YunBF5TxxLjVh/IgOm9ptNDwdg/ypo/r3kXd7TiqAriKFor1WYozqSQTFFTOT3tU7w
	 6nrlY27w5m9dAClcl4FlDtZiRT0hqJN3uSIrupaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 31/64] zram: fix potential UAF of zram table
Date: Tue, 21 Jan 2025 18:52:30 +0100
Message-ID: <20250121174522.742601364@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1192,6 +1192,7 @@ static bool zram_meta_alloc(struct zram
 	zram->mem_pool = zs_create_pool(zram->disk->disk_name);
 	if (!zram->mem_pool) {
 		vfree(zram->table);
+		zram->table = NULL;
 		return false;
 	}
 


