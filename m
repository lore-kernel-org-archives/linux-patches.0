Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6BC7BB1F;
	Wed, 21 Feb 2024 13:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521910; cv=none; b=m3SsUe0SSYT2JUO9rRsR60QPBjb1Sh58HxUM1NMncfE4FWBctWdQcvkIN7s6xAuSMd1QHv0k2Ao424VPBQBR4RL7XyycpJvUn+V53OzyuTexfIUCEX2QMG2QOxjMqTF2RBNfR9S2VhvljcOZpQhjkcPkQQ0BqZZBrBX6ukRJKb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521910; c=relaxed/simple;
	bh=AcePDnos4lER4HWA7lQtKeDDRSLSJcegmO49RkE9tpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxGGVkswyrOHh4dtOVxN1FdZsycKoLgyW8OQXSoc96wx3EvN+yOOUzdUdHr21LW5SVSYlrCMth7uEK23Xf9Cj5lCxWmDuydDXl8jzkk8nPbDq1x3iHlif+EH0TmX7RdFKh9YDOvy4NReRhJypIRAyUnfPjG653jPMw2WdmyiMSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DR1SrHnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DR1SrHnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D84EC433C7;
	Wed, 21 Feb 2024 13:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521909;
	bh=AcePDnos4lER4HWA7lQtKeDDRSLSJcegmO49RkE9tpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DR1SrHnHzbcdtEKXY9NdDCLQmOM97/6DVHlM+Hydcsmi4X2AmAYtAI51TD8kjhkeB
	 yOVFbXJEVit1ctEp0bzhxFPB2bCQ5KfnRfA6I1O0m77s/t6WfWmdwT3eTaHTPqDwUd
	 ey7nq0h2/HzHMRpNsCDVN/sNCMje9pzLtWMCVJIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <quic_qianyu@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.15 023/476] bus: mhi: host: Drop chan lock before queuing buffers
Date: Wed, 21 Feb 2024 14:01:14 +0100
Message-ID: <20240221130008.757717806@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -633,6 +633,8 @@ static int parse_xfer_event(struct mhi_c
 			mhi_del_ring_element(mhi_cntrl, tre_ring);
 			local_rp = tre_ring->rp;
 
+			read_unlock_bh(&mhi_chan->lock);
+
 			/* notify client */
 			mhi_chan->xfer_cb(mhi_chan->mhi_dev, &result);
 
@@ -658,6 +660,8 @@ static int parse_xfer_event(struct mhi_c
 					kfree(buf_info->cb_buf);
 				}
 			}
+
+			read_lock_bh(&mhi_chan->lock);
 		}
 		break;
 	} /* CC_EOT */


