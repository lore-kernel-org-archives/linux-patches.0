Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A40F372B5E;
	Tue, 21 Jul 2026 17:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654692; cv=none; b=PVyI5HsN199AGinelYgsPmppzoIdJtMc4Bg7x/+JBXWA1lrMI8gqHb/6RNUH4Rl+2D5/DErPikdDSPYoSD3rq8CA7j5bHLfVI+OsyTg3bcGge9QvckjrOTC8b2VBmmjxhYK1zH63Vu8BviE4N0r6QRLHRtOQOhZkel+0Kt0iwUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654692; c=relaxed/simple;
	bh=5SlouNeNle4NOa7jJMoFsVfA8nSwUK2iCZKIJs9c+uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9jJ0tRU9nT7ibcY095if3l270Rhf9mce2crPh1ulrm4NbjfRTab9vQb6LEEAq8LwRVjUaIAyGwa3FL7Khli5YJCsSSbVCd4oaX4GG75DkMCt6wl3kLS1EkRnLjaCLLCQKBIIo8M3+SW0PJX32npvlTK+MuYYtbORTkpNGDCX7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MY4uaL+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MY4uaL+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C149C1F000E9;
	Tue, 21 Jul 2026 17:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654691;
	bh=auiq7EXMiL8yIXdaIoLLci/5YbDUv3wQuSEGUw3i5QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MY4uaL+wwukrOERqMIHp4hQzvnLyRZ2ZEqN6p5nk58qx+lLmnSETR4O/ijdS5rBUa
	 qtn47DcV5UE4fSKze0HnWT+aUO+LiWjzxfK/g9Ri1m0ySCAy8xOh24mM9KoeXctWsE
	 Dr3+o8GYJtUUVbBC6UhW0+YMmsbvCx+JDe/L1Ios=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 7.1 1758/2077] bus: mhi: ep: Protect mhi_ep_handle_syserr() in the error path
Date: Tue, 21 Jul 2026 17:23:51 +0200
Message-ID: <20260721152634.210115198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -232,7 +232,9 @@ static int mhi_ep_process_cmd_ring(struc
 			ret = mhi_ep_create_device(mhi_cntrl, ch_id);
 			if (ret) {
 				dev_err(dev, "Error creating device for channel (%u)\n", ch_id);
+				mutex_lock(&mhi_cntrl->state_lock);
 				mhi_ep_handle_syserr(mhi_cntrl);
+				mutex_unlock(&mhi_cntrl->state_lock);
 				return ret;
 			}
 		}


