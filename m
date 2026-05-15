Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0F83E0096;
	Fri, 15 May 2026 16:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860968; cv=none; b=tr/gj8CKOwtHHiVz0r7VXPtY2Xr1xJNhmgLJPMplxlqTdEo2kbsU02EwRXvh1Y3sfc+Zn/XuNODjDEnkVpzw+Og3I4gGmDGD85GAhwCoeMjlK49Kyx+W+eQDpAOezDeyDi3EOZ2dM3Ce5cjPbKduNUGJg1yLOn0lHMoQLeVLhU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860968; c=relaxed/simple;
	bh=aoefghfLsJygHQxgIeqoMHqi5KvNmYUeiUOwGwOfsh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOGcIEUY+rUxDAC4Xe3eKn3iioZjtCa6Wisqn42oyoSI/B9WMuaqkL8Cg5MFOmToLifOt3amZ90Vs8ECins02rBo5x/FM7drE1+IFVK8jUE/qHaiNNdE6OqGMYYKbP5zjWY7yy9R+FOsSL8hBLtx7qcgLzQE1s+sXxJA4r9xh/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJ9hI/ha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJ9hI/ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBD5C2BCB0;
	Fri, 15 May 2026 16:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860967;
	bh=aoefghfLsJygHQxgIeqoMHqi5KvNmYUeiUOwGwOfsh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJ9hI/haEnu/5JyfenJujnGGdD25VNgMJhLSrbwFhNN+jWY0UkoyAcXSwgIWAMo0D
	 NQRLEusxobN+XhTQMvFOD2CLzbquFRRW6fBrckdyO2Mrui1UzskiDbe6rjRJhx7o/z
	 Ibmq33895o8C991PuL9gGOWbuH1X0qEdw7ykoiFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.6 147/474] ipmi:si: Return state to normal if message allocation fails
Date: Fri, 15 May 2026 17:44:16 +0200
Message-ID: <20260515154718.207872555@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Corey Minyard <corey@minyard.net>

commit 09dd798270ff582d7309f285d4aaf5dbebae01cb upstream.

There were places where nothing would get started if a message
allocation failed, so the driver needs to return to normal state.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_si_intf.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -481,15 +481,19 @@ retry:
 	} else if (smi_info->msg_flags & RECEIVE_MSG_AVAIL) {
 		/* Messages available. */
 		smi_info->curr_msg = alloc_msg_handle_irq(smi_info);
-		if (!smi_info->curr_msg)
+		if (!smi_info->curr_msg) {
+			smi_info->si_state = SI_NORMAL;
 			return;
+		}
 
 		start_getting_msg_queue(smi_info);
 	} else if (smi_info->msg_flags & EVENT_MSG_BUFFER_FULL) {
 		/* Events available. */
 		smi_info->curr_msg = alloc_msg_handle_irq(smi_info);
-		if (!smi_info->curr_msg)
+		if (!smi_info->curr_msg) {
+			smi_info->si_state = SI_NORMAL;
 			return;
+		}
 
 		start_getting_events(smi_info);
 	} else if (smi_info->msg_flags & OEM_DATA_AVAIL &&


