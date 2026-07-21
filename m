Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC1946DFFD;
	Tue, 21 Jul 2026 18:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658794; cv=none; b=h59MOuWkNzOlOSt0/jk7Nz7z//eBkWGQd+gQfvcXVkG1yF0+b0fF56/A6Iam1vQFVI3SGZ2uarHf5mw1WyFR/ciggC3jOyxRjwWy7+Vp9WCsfN3coTzhHT/N+IGesYY3lp9rvNK4C0F6gPgQAP4c7FOuNgFNYcETz1KYfYe82Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658794; c=relaxed/simple;
	bh=wLg/O/KukSJ+DS7KBwxIcgo03X9wReXQw6Ur73SQnnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kbhv292/mCK2xK+ECS0+YqjMCoAbcLN6ngEInJRGq+X4OHdmxWnLKg5OF4mKYCD4bWutSY1cvgSMqa+AYQmsGxM1MEpgAMvsVhifeV1sijJshOsIzcWlPzR8ohEr5CuHvKiBbqFc3XWOu6wN9lpAnEER9uqwL9gyquKed7XMyik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plVIj3fK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plVIj3fK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4391F000E9;
	Tue, 21 Jul 2026 18:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658793;
	bh=6I3UqA4j164AYbboUwTSq1f4cbIqiO9DhlHwet8TvCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=plVIj3fKBt/zCSMTSRelQgdlva7oJqHSV8Elfrf7Kg1lZr+BKZ1SVNR2AleBJ0Iqa
	 QLuaM6P+jIjgp3ZLgXqGOjeP1OxgXQ19vsX0GiKOy5PrOhkzA4JNBQ9ZTsyAb+7MaF
	 /GHLSDxmwbQeLjQAq/823fcAby4YC9h7n2wQ5D/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 6.18 1278/1611] bus: mhi: ep: Protect mhi_ep_handle_syserr() in the error path
Date: Tue, 21 Jul 2026 17:23:14 +0200
Message-ID: <20260721152544.191685119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/bus/mhi/ep/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index 5330b03dc636..9db2a2a2c913 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -232,7 +232,9 @@ static int mhi_ep_process_cmd_ring(struct mhi_ep_ring *ring, struct mhi_ring_ele
 			ret = mhi_ep_create_device(mhi_cntrl, ch_id);
 			if (ret) {
 				dev_err(dev, "Error creating device for channel (%u)\n", ch_id);
+				mutex_lock(&mhi_cntrl->state_lock);
 				mhi_ep_handle_syserr(mhi_cntrl);
+				mutex_unlock(&mhi_cntrl->state_lock);
 				return ret;
 			}
 		}
-- 
2.55.0



