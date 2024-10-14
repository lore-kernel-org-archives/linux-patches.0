Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341F21AB6E6;
	Mon, 14 Oct 2024 14:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915838; cv=none; b=F4ZXF97j/1VZJwYGasEKsHiVuAv7GADIVeHA3aT7WsDQ//nf9niuaAWt5hulGY4pcCKT+sAYztt3T/xyPZqwG0JADmOdLftsDE+BjMg6V5tgxIC6D46JXa7ZgDti8RKp6t5awoj6zMera8A4xRHQQ//xirf4WKDBpC6exwyZ+2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915838; c=relaxed/simple;
	bh=4J2YvKzHV5hvxrSzqsLNTaMuEKbOQNNZO+hKmAR7ZKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aylcnuw7yOxiE0xLsC+HulJS3wwjioguLMvduK0SabqT/uSmSc/xYLGvahhLbB7uudyvuVB8UvwoMPIlh5WS5xD1y0c/4jRE+vzWsgksMRdwJYdTii5Yz0wBEIBH29xTm72xQEs+RmXb7W8Ofjt8bjY7XXBPKhxu3FlbiovR2+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqZC+OMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqZC+OMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99194C4CECF;
	Mon, 14 Oct 2024 14:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915838;
	bh=4J2YvKzHV5hvxrSzqsLNTaMuEKbOQNNZO+hKmAR7ZKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqZC+OMV4DLMxjhqXK3I37I91naOtFKKXhuvQxcVXhYMOoDhxVeZW9I9evIwXZlVn
	 6wvVSydupAvx9+LGtpIp1FR9zPArtzQU/7CCVFu/J8lZgEDHSCm2HwYZyhSg20MKug
	 /bY7MOIrIySHcYwbZICZzCtZ8QCaPytK0gTxRoIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 014/214] zram: free secondary algorithms names
Date: Mon, 14 Oct 2024 16:17:57 +0200
Message-ID: <20241014141045.551022802@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 684826f8271ad97580b138b9ffd462005e470b99 ]

We need to kfree() secondary algorithms names when reset zram device that
had multi-streams, otherwise we leak memory.

[senozhatsky@chromium.org: kfree(NULL) is legal]
  Link: https://lkml.kernel.org/r/20240917013021.868769-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20240911025600.3681789-1-senozhatsky@chromium.org
Fixes: 001d92735701 ("zram: add recompression algorithm sysfs knob")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index efcb8d9d274c3..1a875ac43d566 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1989,6 +1989,11 @@ static void zram_destroy_comps(struct zram *zram)
 		zcomp_destroy(comp);
 		zram->num_active_comps--;
 	}
+
+	for (prio = ZRAM_SECONDARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
+		kfree(zram->comp_algs[prio]);
+		zram->comp_algs[prio] = NULL;
+	}
 }
 
 static void zram_reset_device(struct zram *zram)
-- 
2.43.0



