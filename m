Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C63407597;
	Tue, 12 May 2026 17:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607725; cv=none; b=LLRpgCHMHHdf5NCwkIhzYsj5VncxyQzfd455mGsZ0CGw+MPlk0f/dVdkzCxhJ/0DFnm5Z66BVpLbnqllaM4b7R+kUxlRhW15P6JBJXFT2tKRcxT3y9VRGSiFZ7/dCqPp/88+II8QL05yJQPpVV3RXzTgX0+EhyZtoNK7JUJqdn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607725; c=relaxed/simple;
	bh=4SM3FQXcc9PMj5RWa1lYwuq1isbbpOkWd1bfIvL2XuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/qRzJpIV4V1PciWq+MN8A12Uk2banKBc8F2CRjcFTAm+HDyMSoCZ4FYhhReQ/VwLthlhXQnwyGQOvdBRMyljNrM5wCWpcUpCA1V3IU4WVyAyfYMp7z0DxDrJM7NtnBHf/jV0Cy+YKPB0DvVtgRgETbBcO9mXr9i4qwzOwsrm/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGwPgimH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGwPgimH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECC7C2BCC7;
	Tue, 12 May 2026 17:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607725;
	bh=4SM3FQXcc9PMj5RWa1lYwuq1isbbpOkWd1bfIvL2XuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGwPgimHVqEhp8tQnAJrnvUvirYC5T98b1SIDcLqShUxlt0+Oad+/s46hVZl8Hoy2
	 jlas/rLQPFv4Yet4FW2USrfNkwwEl7VM8TJzwSIrGrk9T943nfr9KWgxK7M4eW4C3d
	 JFX3emtSBT00PtK/mVisgCPNLYMhQPU3Q+72cfhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.12 004/206] ipmi:si: Return state to normal if message allocation fails
Date: Tue, 12 May 2026 19:37:36 +0200
Message-ID: <20260512173932.910324105@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


