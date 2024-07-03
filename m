Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E7817332B;
	Wed,  3 Jul 2024 10:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003991; cv=none; b=dXTwULvVX/GYxpmPs3e4zexdKAolHCv4IbkHc1R9xvN4tQN1qv3f930X8FISH40cHv6FoFQF+K+jBF6XlbWqZINdo3fuNfhZNHMwqUfeUhMoeQrjc8DcFg8nuzeXK3I+8bqECtbr8syXnPuJz5EYp3+sPqhbUjRdZn+cRr/qRSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003991; c=relaxed/simple;
	bh=/ARhvZ7YoMFFcQS31ymhyloRBV8inH/G5sLoknghRjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4yIORZCBcddy4AoyldrVFGp+J7s+UNInvncPinb9Z9H/n7DUShbu4rHDFOwh3lRnNTw+3kV21dZumHWS5KOf7Bw1frYZYNtNzxKTpVa33oIIH4qeJ0Q6ro1EUOLbdyWMq0u4DSFv8g2LQahfr9um+nkCTMtRipiyJXQHO3lBPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSlEnJoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSlEnJoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFE4C2BD10;
	Wed,  3 Jul 2024 10:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003990;
	bh=/ARhvZ7YoMFFcQS31ymhyloRBV8inH/G5sLoknghRjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSlEnJoyFJniswzSeCCMrFypken/rMDS7wdm69zLYQmKfjk3ssOQqtQAN07yac9nb
	 kv0m8IOmUODKmxWs6UbPNaGWHzBmOnS7a4u3Cof9vFq/UrMYIVUA9cKS14bPpK5hgU
	 Nk8pwX2bLOIUx5530s+SvmtdRoJcQqbkBeZ0DDrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sicong Huang <congei42@163.com>,
	Ronnie Sahlberg <rsahlberg@ciq.com>
Subject: [PATCH 5.4 086/189] greybus: Fix use-after-free bug in gb_interface_release due to race condition.
Date: Wed,  3 Jul 2024 12:39:07 +0200
Message-ID: <20240703102844.746674521@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sicong Huang <congei42@163.com>

commit 5c9c5d7f26acc2c669c1dcf57d1bb43ee99220ce upstream.

In gb_interface_create, &intf->mode_switch_completion is bound with
gb_interface_mode_switch_work. Then it will be started by
gb_interface_request_mode_switch. Here is the relevant code.
if (!queue_work(system_long_wq, &intf->mode_switch_work)) {
	...
}

If we call gb_interface_release to make cleanup, there may be an
unfinished work. This function will call kfree to free the object
"intf". However, if gb_interface_mode_switch_work is scheduled to
run after kfree, it may cause use-after-free error as
gb_interface_mode_switch_work will use the object "intf".
The possible execution flow that may lead to the issue is as follows:

CPU0                            CPU1

                            |   gb_interface_create
                            |   gb_interface_request_mode_switch
gb_interface_release        |
kfree(intf) (free)          |
                            |   gb_interface_mode_switch_work
                            |   mutex_lock(&intf->mutex) (use)

Fix it by canceling the work before kfree.

Signed-off-by: Sicong Huang <congei42@163.com>
Link: https://lore.kernel.org/r/20240416080313.92306-1-congei42@163.com
Cc: Ronnie Sahlberg <rsahlberg@ciq.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/greybus/interface.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/greybus/interface.c
+++ b/drivers/greybus/interface.c
@@ -694,6 +694,7 @@ static void gb_interface_release(struct
 
 	trace_gb_interface_release(intf);
 
+	cancel_work_sync(&intf->mode_switch_work);
 	kfree(intf);
 }
 


