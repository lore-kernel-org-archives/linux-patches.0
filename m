Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB4A7BB0E;
	Wed, 21 Feb 2024 13:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523668; cv=none; b=Wq0LQPR0z5/YgxHiD4jS+kB7/BmJK07h4RQgo2ynVUDnnuxZqu61QieMu46mb00KaGkoXWOqUzu/Uzjo7Wgalo1P2meMIwyEe/k/MNEb+QdzuKpEXQMDXVwVvZwyhvKOtARg1BGrEnJ7dkmhErYVbFn6h2bSKoD+J09/WcKCBf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523668; c=relaxed/simple;
	bh=ASVcYrLBQCVkxUXahW05TycXMFVvReYHDiA8HTt8sKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsPQJnRXAr3V0ogQbBoe83/6GrUrodJnL4kaUNRc1P3q7y61mhXhwRkPtSxrneBhBZA5mwb9LevpdEAOCMTAJkD0JBydAH4qdK9X+9y3aCtZqzX+JtDL2KsWFJv9OD1Bmqtdsb82Xto47GeJylnWdDb/yK4ouTm63zSRxtwRqYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPTV7WIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPTV7WIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A69C433F1;
	Wed, 21 Feb 2024 13:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523668;
	bh=ASVcYrLBQCVkxUXahW05TycXMFVvReYHDiA8HTt8sKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPTV7WIFSfqp1YucohFsPLsrgS6VcKVwvjVsQi64AW5xlrUxdCOSiTQlbZRYUnr14
	 f5Yh7MPjJc+p3vrGtLsQ+4OsR/z1nBlwHx3yLCN9u9aFlGpQfdpR/jJFaE+Eremcwg
	 77cU/ckpAjx8IL4p7BZHd8y3qIIR3yXWt2yXmcnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <quic_qianyu@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.10 023/379] bus: mhi: host: Drop chan lock before queuing buffers
Date: Wed, 21 Feb 2024 14:03:22 +0100
Message-ID: <20240221125955.604258214@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -569,6 +569,8 @@ static int parse_xfer_event(struct mhi_c
 			mhi_del_ring_element(mhi_cntrl, tre_ring);
 			local_rp = tre_ring->rp;
 
+			read_unlock_bh(&mhi_chan->lock);
+
 			/* notify client */
 			mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
 
@@ -591,6 +593,8 @@ static int parse_xfer_event(struct mhi_c
 					kfree(buf_info->cb_buf);
 				}
 			}
+
+			read_lock_bh(&mhi_chan->lock);
 		}
 		break;
 	} /* CC_EOT */


