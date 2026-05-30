Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C7933E36A;
	Sat, 30 May 2026 18:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165878; cv=none; b=ExAlFgwwGij29IjyZ2iRISbHgzpHxRcIN72DYNsE7nKIsuU4Xnah3K2DRnQUwaBoQZTpDabf1zy2i9N2KgNOopa0OTIViRXoNnmT19AUuaYNz7zsttvoIr7nZucVIKHQsDgqFpPWekBBiqe5vw9Fwhb51zIY01USF6c32HFsFns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165878; c=relaxed/simple;
	bh=MHTjPO+QlSflAnY/5tPtQONOS9B1uhsJ9hVg/sBL7oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0O0QCxtFlAvBsV9QZFGNynupyqqrHiLmsRfnPUO0CQv2vim2jwU6Ye6qlOk2itjSrOwLvB42MAAsqJRPacN1FYeoOH+tkRSMrDEytaAJpFkcwa4VyW8fojtJn9Yihicz6epNxIeBDl57ejQkaCEzJT/39UHGf0oxFnpQGLtsX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzCr9iuJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzCr9iuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588611F00893;
	Sat, 30 May 2026 18:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165877;
	bh=DXsfHOfcWTv5Ds9T34kdi7//gxIyOWRtwjWPxPWLC6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pzCr9iuJ3Cp+vPBn6/tV7qO+dUWZqsq8ZJXKbd7dnG+0pPtyRut1xKY1uNyaKZ5QU
	 MEFJee6TbAWn0PJhTMx/oMrJ1jbrGEtN9ywGeD+Sm2G0AsmuMyyxXCem+SkPK0tpi6
	 Q5xzzMIoJxgMbLTyK08z80ZXI2GyXyYS69pw8Adc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 5.10 207/589] ipmi:si: Return state to normal if message allocation fails
Date: Sat, 30 May 2026 18:01:28 +0200
Message-ID: <20260530160230.389995204@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -479,15 +479,19 @@ retry:
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


