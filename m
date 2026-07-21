Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE3044AB9E;
	Tue, 21 Jul 2026 21:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670122; cv=none; b=GqOTq3xGwSvIVQ5BcWxm3oH5jrF/5CakPSFHDEjIdHD6lLnBfcsP3mEECNUTG9G/BWSLmxiCyULCyloZjWy4vFq6VY42Tf0KVrZq4qMJqLSImk0ukT8iChKuZvznOEmPk/Rl6/G2Jwdri3+MI12+ctNjXeOSV36GhmFETlzEuzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670122; c=relaxed/simple;
	bh=lX/0QgrSmgthpSBMre8UZxorWKRscgRYr/hP+iGUgC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pkdy7OnBo/7EkUKbN5Ek7r7oB6dM8Sv4OE9V9GcbANPFe6cO/4j1ju2+2urAJBBF2BdNpt32LdGpF9tF7KOxQWlFEbt+A1cCwuEbr2UzwQtnmE5ZvOGBbJ5v9MJ6DQPAUfNHe6qlENkBTYlOIXxTuVtZFdGmPmkCZHbczy9nnu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfKK9GW0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfKK9GW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3CB1F000E9;
	Tue, 21 Jul 2026 21:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670121;
	bh=zvoGfHwapFkcYGiCb+Ao4R8nsWufw49dNsGSiR795EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NfKK9GW0sGZPk0KNvLd6l3G7oRIcniT1y1i7wFFrFHciJArTyUKLfO7EJeDcVlIBs
	 4L6wiVkPPEplz2PhtflodhkIvmd06r7UmRzbC5f7v4scfB4tADrQfM0kTHnpdWFWdp
	 6FnAmnonUW+O6N+cLOo9Irj8qzKGSqsozEvTVbVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 6.1 0813/1067] bus: mhi: ep: Protect mhi_ep_handle_syserr() in the error path
Date: Tue, 21 Jul 2026 17:23:34 +0200
Message-ID: <20260721152442.740587401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

commit 519ddf194b158b91439319f6b977b8a465fda0fb upstream.

All the callers of mhi_ep_handle_syserr() except mhi_ep_process_cmd_ring()
are holding the 'state_lock' to avoid the race in setting the MHI state. So
do the same in mhi_ep_process_cmd_ring() for sanity.

Fixes: e827569062a8 ("bus: mhi: ep: Add support for processing command rings")
Cc: stable@vger.kernel.org # 5.18
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260302085612.18725-1-manivannan.sadhasivam@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/ep/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -207,7 +207,9 @@ static int mhi_ep_process_cmd_ring(struc
 			ret = mhi_ep_create_device(mhi_cntrl, ch_id);
 			if (ret) {
 				dev_err(dev, "Error creating device for channel (%u)\n", ch_id);
+				mutex_lock(&mhi_cntrl->state_lock);
 				mhi_ep_handle_syserr(mhi_cntrl);
+				mutex_unlock(&mhi_cntrl->state_lock);
 				return ret;
 			}
 		}


