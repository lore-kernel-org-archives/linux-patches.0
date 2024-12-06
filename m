Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED0E1474A9;
	Fri,  6 Dec 2024 14:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496272; cv=none; b=fbERMLh6PRulGK7iFdVyiKQcMnETcWfYuLQJI9k4ksePajjXwNh2sqao6mIUw5Sj3fr747jY150yk5h7BLsKk5Ap8RqnMjhXoqrN019Y4x4K2AlLT243XAPY11sSnAA4XnMH0y0TbhJiY6Zm0qGyieeqt8xvEQPIJbZ/fNClH3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496272; c=relaxed/simple;
	bh=S4p467Bm95WZuSiwl3dj2BiYau6zO5wtyqDen4QsLiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDY1ZimdtD9LOj8VDrXLPHAdnY7NSbVwJg96b9vE1t/MeA0zp0gR9w4H8MS1pC+SLZo3jyoZOsWtfDSySTS4d0xcWHTwjFmGFmq4Ph/jtMxdZ0dkqhTH2CXTSNbrM8Ah+cPgoo5cVpewMijJAt0hxgGARgxCuH54WmodV5oS3yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uq2H00ny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uq2H00ny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4BDC4CED1;
	Fri,  6 Dec 2024 14:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496271;
	bh=S4p467Bm95WZuSiwl3dj2BiYau6zO5wtyqDen4QsLiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uq2H00nyn/7zAbHV+cCziHUqLvCpRmpCHDGtH5+X/0M0rIx+WD/wD/VRJE2U9I4td
	 Bw1uEzgzNS+lxwFYkrZ/OpzcSAET5DYuMbq+zfNYQU2LA9vf6eDvj/xq+FR07pRPum
	 YVwBoFsm2DPKsQS0ipT3moa/uDXf3p6C7azkUltk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 103/146] iio: Fix fwnode_handle in __fwnode_iio_channel_get_by_name()
Date: Fri,  6 Dec 2024 15:37:14 +0100
Message-ID: <20241206143531.622366223@linuxfoundation.org>
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

From: Zicheng Qu <quzicheng@huawei.com>

commit 3993ca4add248f0f853f54f9273a7de850639f33 upstream.

In the fwnode_iio_channel_get_by_name(), iterating over parent nodes to
acquire IIO channels via fwnode_for_each_parent_node(). The variable
chan was mistakenly attempted on the original node instead of the
current parent node. This patch corrects the logic to ensure that
__fwnode_iio_channel_get_by_name() is called with the correct parent
node.

Cc: stable@vger.kernel.org # v6.6+
Fixes: 1e64b9c5f9a0 ("iio: inkern: move to fwnode properties")
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Link: https://patch.msgid.link/20241102092525.2389952-1-quzicheng@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/inkern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -269,7 +269,7 @@ struct iio_channel *fwnode_iio_channel_g
 			return ERR_PTR(-ENODEV);
 		}
 
-		chan = __fwnode_iio_channel_get_by_name(fwnode, name);
+		chan = __fwnode_iio_channel_get_by_name(parent, name);
 		if (!IS_ERR(chan) || PTR_ERR(chan) != -ENODEV) {
 			fwnode_handle_put(parent);
  			return chan;


