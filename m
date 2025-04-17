Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895141EB1BF;
	Thu, 17 Apr 2025 18:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913166; cv=none; b=SUq9KLrk3CECDvcXd/DdcGz6+qAFQ9Big2Fzal6VoEQ0RyVkZy2FSr1lj0NqDf3ASdVoC//m1vJ7WZlesPf/WP5IAQ19so/w1ZrU5Gk+9J9FladLJHsOMnDIWrKn1+UyLBiI4QEBIDqUNiWwXrdO/poson1xRfajYmB4XS/KwfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913166; c=relaxed/simple;
	bh=6fx07BsuV2hY0PfOPpSCTBSVxfrjd4rgmtTgKVtDj4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpEyXqZFw0f5MCKSZNnSYP3SYz9Z5zVFKa4Oro9tHi9+lF591P7OBCuhOzj1WVpRf9dSXevBY4c9aCP9euJY1HyD98Bx/tSjlkfZYc8IXqdx8PHDVOzFeIOtNr3lfDtnVjHVN1PS04ARnXMsedX+QuIMGzNFIJOUbRc3TayUP9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5VDA3aH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5VDA3aH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B618C4CEE4;
	Thu, 17 Apr 2025 18:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913166;
	bh=6fx07BsuV2hY0PfOPpSCTBSVxfrjd4rgmtTgKVtDj4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5VDA3aHwCYMHUubWQ4GLgc2vOOu+gCkQNyXWvLo8r8OGzb8GUZeUbY7KGHh5lpZU
	 926yvdYyTRTWphopTzO2Rm/+EbV/mCbjcdZ8jMaw0S3SXk6TKs6UdAHHS+B03jP/Bm
	 iwVT0xgFrB+jXmxMf3371lqC33bulplcbi7g21XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 248/449] media: xilinx-tpg: fix double put in xtpg_parse_of()
Date: Thu, 17 Apr 2025 19:48:56 +0200
Message-ID: <20250417175127.977533808@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 347d84833faac79a105e438168cedf0b9658445b upstream.

This loop was recently converted to use for_each_of_graph_port() which
automatically does __cleanup__ on the "port" iterator variable.  Delete
the calls to of_node_put(port) to avoid a double put bug.

Fixes: 393194cdf11e ("media: xilinx-tpg: use new of_graph functions")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/xilinx/xilinx-tpg.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/media/platform/xilinx/xilinx-tpg.c
+++ b/drivers/media/platform/xilinx/xilinx-tpg.c
@@ -722,7 +722,6 @@ static int xtpg_parse_of(struct xtpg_dev
 		format = xvip_of_get_format(port);
 		if (IS_ERR(format)) {
 			dev_err(dev, "invalid format in DT");
-			of_node_put(port);
 			return PTR_ERR(format);
 		}
 
@@ -731,7 +730,6 @@ static int xtpg_parse_of(struct xtpg_dev
 			xtpg->vip_format = format;
 		} else if (xtpg->vip_format != format) {
 			dev_err(dev, "in/out format mismatch in DT");
-			of_node_put(port);
 			return -EINVAL;
 		}
 


