Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66814320CAD;
	Sat, 30 May 2026 17:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163489; cv=none; b=MXacnekzv99zDcjgWnHVvvriV16w1BDbVaOZbPilBY2PlUq+zx0fdCfgT/E4h9QyXb3pzQcm58pQwyBPmcaz/BvGrPfMu3hJnI3IE7hIOM/URnwdv8wei+hvcX6C/3mBYR4xDd7t6157ZIx/ov7YJ+WuU58EYAZI3qkLEXLiTZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163489; c=relaxed/simple;
	bh=bNFQhpV76jWdTi/w2oanxdJbx84Ea6lWG6lG8w1RFIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y54VBCaJhtPyHxDbCWyVdQdQqGomRokPdulDex+0S6bkLX5kVGzu5ucavvzhswq/LkUuFQ2PPMk+JR0MHpaW6Bo/PJXpz7ShqPF8v1rQRYIV25YYCKWhntHhv+MLlh6klQUbTQvvIB1qK4HPONxrbO2swLLP532/PzYLPMUHPew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jv6Ydg1M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jv6Ydg1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABED91F00898;
	Sat, 30 May 2026 17:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163488;
	bh=RHTRrJ2FMUeIjur37EUrAG3sCRz/zLC3aNsglPENPe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jv6Ydg1M9dUTql16M/BGLDU6uHngwmOsv656y4r414bVaf3nVqOBkUn9w/E0/rQeP
	 6oNWToKzAj+qTtlpBuXmE+pxIXtmTgv/CoFwqZ0pXfSY+FLTk2N0OVhREzxYHuVgiA
	 HlgeEfaPzBuYCtK7vzbg2g7x5rS/Stre5b1ULuWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 5.15 274/776] ipmi:si: Return state to normal if message allocation fails
Date: Sat, 30 May 2026 17:59:48 +0200
Message-ID: <20260530160247.638270031@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -480,15 +480,19 @@ retry:
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


