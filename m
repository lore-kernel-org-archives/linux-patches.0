Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485C3168C2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CF8C433EF;
	Mon,  8 May 2023 10:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541261;
	bh=zOMtrZwVaZkKZq0gweW1/PlI8MYXNXMIIBzhw41tmg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2HX43wX/vraMsSdGO58tG97U+3vFd88Q47ft9Uph4ucvNHda5KiZcLia716J29dV
	 H1wBfvWcrlcCEkvGUw3bcd7IH2al/Ir4T4ewlWcwTP9Wud6zMseQYWlSOeFvuhJf81
	 fQD4L8pC4Pw13jYUuBoaj8BaM8cu6L2QUBTE9QVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yuchen <zhangyuchen.lcr@bytedance.com>,
	Corey Minyard <minyard@acm.org>
Subject: [PATCH 6.2 057/663] ipmi: fix SSIF not responding under certain cond.
Date: Mon,  8 May 2023 11:38:03 +0200
Message-Id: <20230508094430.342363529@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Yuchen <zhangyuchen.lcr@bytedance.com>

commit 6d2555cde2918409b0331560e66f84a0ad4849c6 upstream.

The ipmi communication is not restored after a specific version of BMC is
upgraded on our server.
The ipmi driver does not respond after printing the following log:

    ipmi_ssif: Invalid response getting flags: 1c 1

I found that after entering this branch, ssif_info->ssif_state always
holds SSIF_GETTING_FLAGS and never return to IDLE.

As a result, the driver cannot be loaded, because the driver status is
checked during the unload process and must be IDLE in shutdown_ssif():

        while (ssif_info->ssif_state != SSIF_IDLE)
                schedule_timeout(1);

The process trigger this problem is:

1. One msg timeout and next msg start send, and call
ssif_set_need_watch().

2. ssif_set_need_watch()->watch_timeout()->start_flag_fetch() change
ssif_state to SSIF_GETTING_FLAGS.

3. In msg_done_handler() ssif_state == SSIF_GETTING_FLAGS, if an error
message is received, the second branch does not modify the ssif_state.

4. All retry action need IS_SSIF_IDLE() == True. Include retry action in
watch_timeout(), msg_done_handler(). Sending msg does not work either.
SSIF_IDLE is also checked in start_next_msg().

5. The only thing that can be triggered in the SSIF driver is
watch_timeout(), after destory_user(), this timer will stop too.

So, if enter this branch, the ssif_state will remain SSIF_GETTING_FLAGS
and can't send msg, no timer started, can't unload.

We did a comparative test before and after adding this patch, and the
result is effective.

Fixes: 259307074bfc ("ipmi: Add SMBus interface driver (SSIF)")

Cc: stable@vger.kernel.org
Signed-off-by: Zhang Yuchen <zhangyuchen.lcr@bytedance.com>
Message-Id: <20230412074907.80046-1-zhangyuchen.lcr@bytedance.com>
Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_ssif.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -794,9 +794,9 @@ static void msg_done_handler(struct ssif
 		} else if (data[0] != (IPMI_NETFN_APP_REQUEST | 1) << 2
 			   || data[1] != IPMI_GET_MSG_FLAGS_CMD) {
 			/*
-			 * Don't abort here, maybe it was a queued
-			 * response to a previous command.
+			 * Recv error response, give up.
 			 */
+			ssif_info->ssif_state = SSIF_IDLE;
 			ipmi_ssif_unlock_cond(ssif_info, flags);
 			dev_warn(&ssif_info->client->dev,
 				 "Invalid response getting flags: %x %x\n",


