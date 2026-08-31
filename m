Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E6F529417;
	Mon, 31 Aug 2026 13:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183884; cv=none; b=u1Byt4Uya+vCAY8aJwzeIgGEztPhqftdBE4JdAih4C1yT3ZQof5XBHVA+b9mk/o10ujf/1a2KHYBWdTN7/WRtTYr6AnuudsvrZOr5OukrP2hPIBmkUkwaiPuUMRvGX6qWMV1zRLMU7eXxrJ81lrqwcOOanvJFN9w72FqKCmYwxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183884; c=relaxed/simple;
	bh=Kv+DRr2VJQYizmDh8HBR+wxMqfrZXhVYDCc/Ivz19Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZwyGdBnAuy+tH56BTC/Z9vjmoA/ps3gOfLzQjbJiPvQlKgcsGCJY3ieaDR+BCdJnL7yTYlANIYHySFspUtTIrcxmAbcr3yYUzNQwqTWxcrfQeBbJFdgXX2ImCTYcBkBKdMyzFct8vXl2Jct+jmGUTn/46ixITba1seicZAo7Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/oZyt4A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/oZyt4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9F71F00A3E;
	Mon, 31 Aug 2026 13:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183882;
	bh=jwBPom1dkzu68mNaFnPphcxlAK0iK82qBvBTHqmNymw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/oZyt4A+dpU5XCvkho2AMa282tGt0IXPcAMgE4DlZaoMKUcvG//NV3ZHKDs1dIAi
	 UBFSLBJtmz6LnL9vCh2JaRc+HcHWDsatu3uvoxlln0FR9FmkOcM3HsREnDJLD6Ii7i
	 gT/hCC6nHr2Mk3JZPRxeQ2QoOtG0lCtCLy9/x/LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 7.1 19/76] accessibility: speakup: unregister tty ldisc on later init failures
Date: Mon, 31 Aug 2026 15:33:51 +0200
Message-ID: <20260831133400.188020202@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit a76acbaec9b8fd74413646984d2e3626d0543e39 upstream.

The ldisc registration is intentionally non-fatal, since some synth
drivers do not use tty/ldisc.  However, once speakup_init() continues
past the registration point and later fails, the init unwind path should
mirror speakup_exit() and call spk_ttyio_unregister_ldisc().

Add the missing unregister call to the error path after synth_release(),
matching the normal module exit cleanup order.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Fixes: e23a9b439ce9 ("staging: speakup: safely register and unregister ldisc")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260531230804.254962-16-samuel.thibault@ens-lyon.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accessibility/speakup/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/accessibility/speakup/main.c
+++ b/drivers/accessibility/speakup/main.c
@@ -2444,6 +2444,7 @@ error_kbdnotifier:
 	mutex_lock(&spk_mutex);
 	synth_release();
 	mutex_unlock(&spk_mutex);
+	spk_ttyio_unregister_ldisc();
 	speakup_kobj_exit();
 
 error_kobjects:


