Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C490F3B7B79;
	Tue, 21 Jul 2026 20:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667305; cv=none; b=UJRHKHfb9MCWFt/A8yCQi15BrrJL61A/fBLxuI8f8/5V+sd4fQUCRQdBTjQInG0Kk1TRdn74Y96uUitZWpTD85Uk8kyp1lJ+KHWT0Be3IaO9wpGw3P0IHo3iAFNCmkXkMFWkQAa8YIH6uyG+OBk9pgh3j+LNvU8kqtHZPuVC07c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667305; c=relaxed/simple;
	bh=80wheJNwJZ0N4Ib88jX6W/L/TdXirH8wZnREGa7X5D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckOodUgrrBFBnlkKtmNypMKrlJT2M9EiVBsGbb7A4Ljshi8heAHANYWTdYFYW0S3gTMW4RXzkcK+jXCHjjHfEPBdaABcxQ+qyqQR6ImHGhjpHdJnSnlq5hVAOth6njvapMnCwQXNOpZL/uOlumdzE10KYUREXAcW6sfScExfGC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qId1zSOC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qId1zSOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367CE1F000E9;
	Tue, 21 Jul 2026 20:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667304;
	bh=jkiqEPIDsODFR5IZwvBDIld3RylGKHlCag/IRxv4MOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qId1zSOC3FZYHH3rKbomVKoxKTaxq7TCA4qiOUQqRWsEZa/Pll3JKB39SpynyHjo+
	 jXv/KUvQsNXO9XOSflVAdWpyy56O0bxB65IwrTVIERYq+0jD+uAIC8Va6uUub1nRlI
	 y8Mh9usC/11G3r6yzSEO/kRaUBS/UjQJWd0Sp/S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 6.6 1009/1266] bus: mhi: ep: Protect mhi_ep_handle_syserr() in the error path
Date: Tue, 21 Jul 2026 17:24:06 +0200
Message-ID: <20260721152504.405674018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -216,7 +216,9 @@ static int mhi_ep_process_cmd_ring(struc
 			ret = mhi_ep_create_device(mhi_cntrl, ch_id);
 			if (ret) {
 				dev_err(dev, "Error creating device for channel (%u)\n", ch_id);
+				mutex_lock(&mhi_cntrl->state_lock);
 				mhi_ep_handle_syserr(mhi_cntrl);
+				mutex_unlock(&mhi_cntrl->state_lock);
 				return ret;
 			}
 		}


