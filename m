Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F038531E849;
	Thu, 16 Jul 2026 13:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209083; cv=none; b=asOqC1BSagmqQDWo/nEl40OjYG5M3q/IZocW+TbJWp7SGOHc5c+Et08Z1fXQJDlC0LgLx5RbJ2JClCkj2vwrQ8zc6mAmtb5IlDsgVgFpSKdFKamMosrbt91NZzavdPRBsc2UKvtM48UU/ME+1sR66LpJao82Cxty413oNzOtS5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209083; c=relaxed/simple;
	bh=Aphjg/xqGqpWBPJH2gOUGeXhMqe5j1HkFedQTAfWg5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPqkn44imtW2kHIx9fTGJFrfmcNThbR9z9jZkiIEdrt23KLim0ouhmW/YvmjGcpjd/MiO8Spt0tLDtwjr0eeehCD8kFjeuqULsMDRN166skFw1nNdHGBzDdBcO6nXHGXsLouIqkVpSk1j84YLqOcJmxGkT0UIFvVDUUfRBffPfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkO5EbxI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkO5EbxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6039B1F000E9;
	Thu, 16 Jul 2026 13:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209081;
	bh=/IPS13ig3HJ34Ox/a6igMz05gGQO237518bmuxhaMsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YkO5EbxIiiQyy38rQJnZS2+p8L6ATAwLk2tMaMVB5LLCd26jX/aXAg327WgUBQgA4
	 b8mPNmZhUsdJzS00eO0ARWb7qQgTUHDsWycHnD4IMFiIQl/sjxBfLXF9Y4QDotLHKu
	 QN7kuGkwxoVZmufHJCVxF3rLUbsKFhcpiBYnsa8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Maxwell Doose <m32285159@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 050/518] iio: core: fix uninitialized data in debugfs
Date: Thu, 16 Jul 2026 15:25:18 +0200
Message-ID: <20260716133048.881404145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit ab92ed206d41fd171ebd37bc46360d9f2140d043 upstream.

If *ppos is non-zero then simple_write_to_buffer() will not initialize
the start of buf[].  Non zero values for *ppos aren't going to work
anyway.  Test for them at the start of the function and return -EINVAL.

Fixes: 6d5dd486c715 ("iio: core: make use of simple_write_to_buffer()")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Maxwell Doose <m32285159@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -418,7 +418,7 @@ static ssize_t iio_debugfs_write_reg(str
 	char buf[80];
 	int ret;
 
-	if (count >= sizeof(buf))
+	if (*ppos != 0 || count >= sizeof(buf))
 		return -EINVAL;
 
 	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, userbuf,


