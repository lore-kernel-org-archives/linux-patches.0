Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719761B6D08;
	Mon, 29 Dec 2025 16:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025670; cv=none; b=LK7zqEl/ir6V1kc1MQXoyRWMbQN7nDQiINnrZGFO/Qn5stOFhvzc5yps4QEaLMXKoubWH+iRPKv3srLQQqEYimcXiP9EvbEV6mFCmTgE1xTDgiEUGdQreTalfqB3vgRWq5XwYOfDmy5PxSxzIkK/D5ZFmCqhAF4KhPxFw1mdGQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025670; c=relaxed/simple;
	bh=ge9a2Y3YX/SSii766CU6OJ1cdYloV29L4HTChEYP1iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNQ6SSMn/3Th8HZfIpX48/8yR9RXRXr0qIAC0rAQLCQ5DyzkKUgRriabAFRVSzhMdqdQ41cYmdyoZdDLst4fpmiQTw7J8jQnbjGcmSgcPU+dKZnpvSV1RY5bCv55tlQ0pV4OWWhQX/fWqCFfoeeOqL0a+qfX0r3UMuvqumjvmvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8gvnC0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8gvnC0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F3EC4CEF7;
	Mon, 29 Dec 2025 16:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025670;
	bh=ge9a2Y3YX/SSii766CU6OJ1cdYloV29L4HTChEYP1iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8gvnC0tMQTi9xZPauswVEV7yYi2zJGfQX1aoQfrUdqo0G3M0NXmBSUMTLcMJ35FO
	 ZsdZBjmeSwDJadbWV+K2PBgiNAKNS2AhGIJMZk4PzFggw1bPikETDap/nlttGwV9vE
	 tFnZCbRvbPwxURRJgmkxRsv6A18/HATelMtisWg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Arnd Bergmann <arnd@arndb.de>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 295/430] char: applicom: fix NULL pointer dereference in ac_ioctl
Date: Mon, 29 Dec 2025 17:11:37 +0100
Message-ID: <20251229160735.195887009@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Tianchu Chen <flynnnchen@tencent.com>

commit 82d12088c297fa1cef670e1718b3d24f414c23f7 upstream.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

In ac_ioctl, the validation of IndexCard and the check for a valid
RamIO pointer are skipped when cmd is 6. However, the function
unconditionally executes readb(apbs[IndexCard].RamIO + VERS) at the
end.

If cmd is 6, IndexCard may reference a board that does not exist
(where RamIO is NULL), leading to a NULL pointer dereference.

Fix this by skipping the readb access when cmd is 6, as this
command is a global information query and does not target a specific
board context.

Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20251128155323.a786fde92ebb926cbe96fcb1@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/applicom.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -835,7 +835,10 @@ static long ac_ioctl(struct file *file,
 		ret = -ENOTTY;
 		break;
 	}
-	Dummy = readb(apbs[IndexCard].RamIO + VERS);
+
+	if (cmd != 6)
+		Dummy = readb(apbs[IndexCard].RamIO + VERS);
+
 	kfree(adgl);
 	mutex_unlock(&ac_mutex);
 	return ret;


