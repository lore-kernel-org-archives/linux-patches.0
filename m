Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA4B176238;
	Fri, 15 May 2026 15:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860606; cv=none; b=f4rNokq2+Wg7QkQfaXrnfiEkuW/wWcmDiKyVM77GtcpSOcRN0a0TBUcqZbD0Yt99T+dDG/oISFAhYJG/J/1MgjbK/UEeDw7DnqKgu5vc8jgOakiGXiB3GZeRjdK2uZk5IALle2wVe7VNE4dO+53Xzn5UFREJDIRKNYREi05vmQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860606; c=relaxed/simple;
	bh=E2zoLuTIPzKKGqfCvLKUU96ZL1s56Eo1PLH3Cd54pAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkmPN2OEBVGk6+0XEo3I5AopkO1h4jijtcpUWyn7xC/bRg5r+5fpkFBLWjLka81gvJlCqVPoxe7bFgkgKE03iAVurviqecdClYxO+vzobc+sHaITSVxjVdexhpvt81A09Qf2p7+wpEGJPYqhA5R1s1DwWHSONfuEMGSdI1XYxaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+MtObkK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+MtObkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58E3C2BCB0;
	Fri, 15 May 2026 15:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860606;
	bh=E2zoLuTIPzKKGqfCvLKUU96ZL1s56Eo1PLH3Cd54pAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+MtObkKVeFpJG0a2Ra5xXHxSrCaLZfj7bEgFRwpI0NzVMctCyHrJDBPwXUo2WRol
	 SofMfVDT4WpTOQkc8m4MWh5q+iA34CGziBPh7kxq2lTpxzTzMRULmdaytde180Vh4n
	 24HYKIwbn6Wzd/Xrj00msmZbEkCG3faD95zgWEDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	ychen@northwestern.edu,
	Tyllis Xu <LivelyCarpet87@gmail.com>
Subject: [PATCH 6.6 010/474] misc: ibmasm: fix OOB MMIO read in ibmasm_handle_mouse_interrupt()
Date: Fri, 15 May 2026 17:41:59 +0200
Message-ID: <20260515154715.277938055@linuxfoundation.org>
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

From: Tyllis Xu <livelycarpet87@gmail.com>

commit 4b6e6ead556734bdc14024c5f837132b1e7a4b84 upstream.

ibmasm_handle_mouse_interrupt() performs an out-of-bounds MMIO read
when the queue reader or writer index from hardware exceeds
REMOTE_QUEUE_SIZE (60).

A compromised service processor can trigger this by writing an
out-of-range value to the reader or writer MMIO register before
asserting an interrupt. Since writer is re-read from hardware on
every loop iteration, it can also be set to an out-of-range value
after the loop has already started.

The root cause is that get_queue_reader() and get_queue_writer() return
raw readl() values that are passed directly into get_queue_entry(),
which computes:

  queue_begin + reader * sizeof(struct remote_input)

with no bounds check. This unchecked MMIO address is then passed to
memcpy_fromio(), reading 8 bytes from unintended device registers.
For sufficiently large values the address falls outside the PCI BAR
mapping entirely, triggering a machine check exception.

Fix by checking both indices against REMOTE_QUEUE_SIZE at the top of
the loop body, before any call to get_queue_entry(). On an out-of-range
value, reset the reader register to 0 via set_queue_reader() before
breaking, so that normal queue operation can resume if the corrupted
hardware state is transient.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Fixes: 278d72ae8803 ("[PATCH] ibmasm driver: redesign handling of remote control events")
Cc: stable@vger.kernel.org
Cc: ychen@northwestern.edu
Signed-off-by: Tyllis Xu <LivelyCarpet87@gmail.com>
Link: https://patch.msgid.link/20260308062108.258940-1-LivelyCarpet87@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/ibmasm/remote.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/misc/ibmasm/remote.c
+++ b/drivers/misc/ibmasm/remote.c
@@ -177,6 +177,11 @@ void ibmasm_handle_mouse_interrupt(struc
 	writer = get_queue_writer(sp);
 
 	while (reader != writer) {
+		if (reader >= REMOTE_QUEUE_SIZE || writer >= REMOTE_QUEUE_SIZE) {
+			set_queue_reader(sp, 0);
+			break;
+		}
+
 		memcpy_fromio(&input, get_queue_entry(sp, reader),
 				sizeof(struct remote_input));
 


