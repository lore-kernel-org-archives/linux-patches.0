Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0A815956E;
	Mon, 29 Jan 2024 17:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548046; cv=none; b=VKV9RDYXMCNGMC0jOpm/Od+MeIEin/9jyPyT3Q9F26Y9OpEVEccBJWdegH1xXLP14SGz7GQMDynPEoi9ato3Ft9RAFe/5dtWU3QUKigR2zDFxwaca25A87ZEiCfRgu96gxK11k3XNTaIbQ/fE70tnalUeqJ/XReDYUsSpMmpjHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548046; c=relaxed/simple;
	bh=pyA3grc2RMvyOktQjP8TrjJEEYEjLg2zDkuFXqq6FOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/LXwKhG/PaimiBwCC0sTWBw3o35mJ6MTCMqTzAZ4fNKKyMYxKbHO/MuqRfi7nugIHNiFOvxVSQEgMO+m5W0ZXnOuXEYib75AaMf5P97KtJSLkNc/g8LvqZTl0TErilkDCfKt+O+dK9dlw/NlWksGetez1uMb4iO3TBgWtOLq1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UuMXPy/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuMXPy/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45556C433F1;
	Mon, 29 Jan 2024 17:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548045;
	bh=pyA3grc2RMvyOktQjP8TrjJEEYEjLg2zDkuFXqq6FOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuMXPy/w4ThpaYthn72/tVKwhk3EVi8dysK+87m6GKc3vZSpMsZtaZUZ5jKI2AobY
	 HQ5CMc74ar81SPg8ZcKGrlbfBhpMFQH9hFqxFfgeUdx/hSp5BIdY0nl1/9TQSMhPoe
	 EJo09AT9bPNsfRGpJIm+qsclb5f+kNrsFUaY82hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <quic_qianyu@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.7 046/346] bus: mhi: host: Drop chan lock before queuing buffers
Date: Mon, 29 Jan 2024 09:01:17 -0800
Message-ID: <20240129170017.742553486@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


