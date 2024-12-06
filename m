Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A29D1494D9;
	Fri,  6 Dec 2024 14:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496145; cv=none; b=dbj323nAvx/lsPArPNRwbC4GskD5fk7K+g7Vt3zk0IgXUFqeTObKVwgivYEYwujcHpt2dQoi8rmyNu1XLUt2EgMOqz2ySBqN/3j14jLsoRCNuZ7HihCl8FKNnglvogzKiSp0mV1nizX06BGwOv6NnRutegOh9B4drE4zqFcwyho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496145; c=relaxed/simple;
	bh=NvhysSOUHuLnVHhXqUcB3ptvzcvEopMx3+AE3gFqAjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7VYs4LFxHAzRbbQ8laV/iWHWaP/DmlK9Hy/+UGsMg5CCpxdeZF1c01CMFdmlNR1CwIFaLBgEf3wcd7BJ98YI44+DbwjK+frYWcIHAyyaOTyStYvIFLNEMD6caKNO1w9Q0Gl0lhXB1NextMfbpSpp4XGMbPtOR7SLe1pKyTM/R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQYjawqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQYjawqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8CBC4CED1;
	Fri,  6 Dec 2024 14:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496145;
	bh=NvhysSOUHuLnVHhXqUcB3ptvzcvEopMx3+AE3gFqAjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQYjawqTqZDuXEJJPjhIwB+/AvQjEUl5qUNDZ3I+IbXX1QM/cB7MutgVeLlZeHDPB
	 x7l39shgOrED8o8Pnyk2pb23Wjq4sOO62LTKjLj2eAhEAWJp2l2AXwMm5Wb6t6rFmI
	 8VQ1jmt3Nf/NSiHWn/BR/yowE2QQ3PPKDRNRQKJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shin Kawamura <kawasin@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 047/146] zram: clear IDLE flag after recompression
Date: Fri,  6 Dec 2024 15:36:18 +0100
Message-ID: <20241206143529.475526203@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

commit f85219096648b251a81e9fe24a1974590cfc417d upstream.

Patch series "zram: IDLE flag handling fixes", v2.

zram can wrongly preserve ZRAM_IDLE flag on its entries which can result
in premature post-processing (writeback and recompression) of such
entries.

This patch (of 2)

Recompression should clear ZRAM_IDLE flag on the entries it has accessed,
because otherwise some entries, specifically those for which recompression
has failed, become immediate candidate entries for another post-processing
(e.g.  writeback).

Consider the following case:
- recompression marks entries IDLE every 4 hours and attempts
  to recompress them
- some entries are incompressible, so we keep them intact and
  hence preserve IDLE flag
- writeback marks entries IDLE every 8 hours and writebacks
  IDLE entries, however we have IDLE entries left from
  recompression, so writeback prematurely writebacks those
  entries.

The bug was reported by Shin Kawamura.

Link: https://lkml.kernel.org/r/20241028153629.1479791-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20241028153629.1479791-2-senozhatsky@chromium.org
Fixes: 84b33bf78889 ("zram: introduce recompress sysfs knob")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Shin Kawamura <kawasin@google.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1692,6 +1692,13 @@ static int zram_recompress(struct zram *
 	if (ret)
 		return ret;
 
+	/*
+	 * We touched this entry so mark it as non-IDLE. This makes sure that
+	 * we don't preserve IDLE flag and don't incorrectly pick this entry
+	 * for different post-processing type (e.g. writeback).
+	 */
+	zram_clear_flag(zram, index, ZRAM_IDLE);
+
 	class_index_old = zs_lookup_class_index(zram->mem_pool, comp_len_old);
 	/*
 	 * Iterate the secondary comp algorithms list (in order of priority)


