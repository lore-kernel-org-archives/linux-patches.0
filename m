Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB84D259C9F;
	Thu, 17 Apr 2025 18:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914468; cv=none; b=R16cvVVhNa7t9PRVeK90YAz90RIzbkxZbBm9dIFo7uzwFntESGYEvi4/jNBw932MfmouI//uvlAR1F8vXy8EsrAxUIx2ADr9RcNb4EK+poCIGAgNM2sJoYgvMyE1ziEUXFbuC5BIcgKmhJhO5qUAeTSd3RltVrgH06UtbzUF3ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914468; c=relaxed/simple;
	bh=C1UILtRpt9tbqz4aUmmTr/agymj2bi6T1Awqq6v/h7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NP3ZqRVYt81fBWsWgNTh5bogytMvTBdqb5P699qvLIGimUEuSjVi+pApOhG1MFNkwjVam/LmaC5shF90uR0flmGWysg1umIeR/UiwJInTEe7ADFthRFM6pBvMplaO+jRCcG93tYYZHi2ckYPSYRP2Iig6hOMnhLMgwWbUPkrJ7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsjPWpR0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsjPWpR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B96C4CEE7;
	Thu, 17 Apr 2025 18:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914468;
	bh=C1UILtRpt9tbqz4aUmmTr/agymj2bi6T1Awqq6v/h7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GsjPWpR0IjA8Wc659hsi9T59utVqiWtUku3wZfm2nsbMXPTuPkqfh/CoA6OmISEwA
	 hT/BXNVHE+DgIrZ/YRdqM7JU8nZ02+eDmz9vBP6F7tRm3qcujDUUIE7E8PfhugeTga
	 U9xHVRAzY4bxCBTvyZ3CpqCNM598ZOMIN5klMK1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 226/414] media: xilinx-tpg: fix double put in xtpg_parse_of()
Date: Thu, 17 Apr 2025 19:49:44 +0200
Message-ID: <20250417175120.526996890@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


