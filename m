Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302C4C8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB4BC433C9;
	Mon, 26 Jun 2023 18:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804981;
	bh=mQzHtJhgFNfl5m7WlBQbcodzQPLQadexwITC9q3uXHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOrUKK1y1SvYnLviEQJ5srKkdZ/zKjkQD3KFPNer1rFOJKXlbjteWWG2sU4CShLmg
	 O+rJOwaLOKF/1Zktbvz1KBsrTwR0lxjg7piOUAuiP2MjCRDXAP1hi8wmjtl3QrK6d5
	 zHUmQ+Fu/k/8PFbF/KHn6fF0cWcHy1K3xDEDp7qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Starks <jostarks@microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.10 10/81] Drivers: hv: vmbus: Fix vmbus_wait_for_unload() to scan present CPUs
Date: Mon, 26 Jun 2023 20:11:52 +0200
Message-ID: <20230626180744.870752336@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180744.453069285@linuxfoundation.org>
References: <20230626180744.453069285@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Kelley <mikelley@microsoft.com>

commit 320805ab61e5f1e2a5729ae266e16bec2904050c upstream.

vmbus_wait_for_unload() may be called in the panic path after other
CPUs are stopped. vmbus_wait_for_unload() currently loops through
online CPUs looking for the UNLOAD response message. But the values of
CONFIG_KEXEC_CORE and crash_kexec_post_notifiers affect the path used
to stop the other CPUs, and in one of the paths the stopped CPUs
are removed from cpu_online_mask. This removal happens in both
x86/x64 and arm64 architectures. In such a case, vmbus_wait_for_unload()
only checks the panic'ing CPU, and misses the UNLOAD response message
except when the panic'ing CPU is CPU 0. vmbus_wait_for_unload()
eventually times out, but only after waiting 100 seconds.

Fix this by looping through *present* CPUs in vmbus_wait_for_unload().
The cpu_present_mask is not modified by stopping the other CPUs in the
panic path, nor should it be.

Also, in a CoCo VM the synic_message_page is not allocated in
hv_synic_alloc(), but is set and cleared in hv_synic_enable_regs()
and hv_synic_disable_regs() such that it is set only when the CPU is
online.  If not all present CPUs are online when vmbus_wait_for_unload()
is called, the synic_message_page might be NULL. Add a check for this.

Fixes: cd95aad55793 ("Drivers: hv: vmbus: handle various crash scenarios")
Cc: stable@vger.kernel.org
Reported-by: John Starks <jostarks@microsoft.com>
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://lore.kernel.org/r/1684422832-38476-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/channel_mgmt.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -765,11 +765,22 @@ static void vmbus_wait_for_unload(void)
 		if (completion_done(&vmbus_connection.unload_event))
 			goto completed;
 
-		for_each_online_cpu(cpu) {
+		for_each_present_cpu(cpu) {
 			struct hv_per_cpu_context *hv_cpu
 				= per_cpu_ptr(hv_context.cpu_context, cpu);
 
+			/*
+			 * In a CoCo VM the synic_message_page is not allocated
+			 * in hv_synic_alloc(). Instead it is set/cleared in
+			 * hv_synic_enable_regs() and hv_synic_disable_regs()
+			 * such that it is set only when the CPU is online. If
+			 * not all present CPUs are online, the message page
+			 * might be NULL, so skip such CPUs.
+			 */
 			page_addr = hv_cpu->synic_message_page;
+			if (!page_addr)
+				continue;
+
 			msg = (struct hv_message *)page_addr
 				+ VMBUS_MESSAGE_SINT;
 
@@ -803,11 +814,14 @@ completed:
 	 * maybe-pending messages on all CPUs to be able to receive new
 	 * messages after we reconnect.
 	 */
-	for_each_online_cpu(cpu) {
+	for_each_present_cpu(cpu) {
 		struct hv_per_cpu_context *hv_cpu
 			= per_cpu_ptr(hv_context.cpu_context, cpu);
 
 		page_addr = hv_cpu->synic_message_page;
+		if (!page_addr)
+			continue;
+
 		msg = (struct hv_message *)page_addr + VMBUS_MESSAGE_SINT;
 		msg->header.message_type = HVMSG_NONE;
 	}


