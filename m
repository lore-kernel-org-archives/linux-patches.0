Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7856F06D;
	Mon, 29 Jan 2024 17:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548456; cv=none; b=cWcjVeHKUAqCBU5lnx58EwaBmejmQU4M4Rz9hKA0wjBhuqgSIJ8H/ck66NkT/oJNVdM03iDAf9oT518hgmOJlOK6R9qRP5skhMi3c1PFy2s1HwuITYc22lMlNT509tVtmPI5//I2VHYDg2XLruzFsrXQdsGKoxPcbGyDbM3zJFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548456; c=relaxed/simple;
	bh=kZeLg6J0BNf8ppkldDm+7ulco4YEAzBO4PA3ASOo1i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9IX4mnqiccvfqj3L5s/qqlrEQGYfCF3w8iJHDHj+L0Zsaaxr94MJqT399LE/7YiR7Gg0MvrWhbc98JsjntmBGXdBawyJKPVhX+Xdnm+Gs3oRnwY6jSAQw+HKKNyFZcjXzvrMXyrBmanNyuN4cArmorljeOc+KkzHLz5k5D6poM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQXiIpnz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQXiIpnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBB8C433F1;
	Mon, 29 Jan 2024 17:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548456;
	bh=kZeLg6J0BNf8ppkldDm+7ulco4YEAzBO4PA3ASOo1i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQXiIpnzTsI8m7DRiGqnOri5xDiMoau+zwKpKBuSiW/I8zh+Wtv325njTRuqf5zVy
	 u4tc9/tXtfKy58M0IuJtMajAF7HaiGMgMzlT8KFGCKfis6sA7KOspwmcRwNP2XJ+Wj
	 mby/GeTyeC74YiFxFpfTJ6f7XLr55k8BGlgsMJJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <quic_qianyu@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.6 068/331] bus: mhi: host: Drop chan lock before queuing buffers
Date: Mon, 29 Jan 2024 09:02:12 -0800
Message-ID: <20240129170016.918050709@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Yu <quic_qianyu@quicinc.com>

commit 01bd694ac2f682fb8017e16148b928482bc8fa4b upstream.

Ensure read and write locks for the channel are not taken in succession by
dropping the read lock from parse_xfer_event() such that a callback given
to client can potentially queue buffers and acquire the write lock in that
process. Any queueing of buffers should be done without channel read lock
acquired as it can result in multiple locks and a soft lockup.

Cc: <stable@vger.kernel.org> # 5.7
Fixes: 1d3173a3bae7 ("bus: mhi: core: Add support for processing events from client device")
Signed-off-by: Qiang Yu <quic_qianyu@quicinc.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Tested-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1702276972-41296-3-git-send-email-quic_qianyu@quicinc.com
[mani: added fixes tag and cc'ed stable]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -643,6 +643,8 @@ static int parse_xfer_event(struct mhi_c
 			mhi_del_ring_element(mhi_cntrl, tre_ring);
 			local_rp = tre_ring->rp;
 
+			read_unlock_bh(&mhi_chan->lock);
+
 			/* notify client */
 			mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
 
@@ -668,6 +670,8 @@ static int parse_xfer_event(struct mhi_c
 					kfree(buf_info->cb_buf);
 				}
 			}
+
+			read_lock_bh(&mhi_chan->lock);
 		}
 		break;
 	} /* CC_EOT */


