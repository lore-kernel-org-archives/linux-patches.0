Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FB048822B;
	Mon, 31 Aug 2026 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184940; cv=none; b=sPZSf5E1xt99pmYBe0nZuZgthkDwjV1U9LVlJixpbpdnJKkyRyGgyjSwKney9Y6k/C0xQLTF0pG9fupkEzNMcFGMOn26nKCvyRcQet7v9atASkjsgl/yakWnpCqPUOypGJ6qxd/eVAG6DqOHvnaPevSYg4+RmWOkIeSQGX30T6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184940; c=relaxed/simple;
	bh=DL1rRSIj9EgZf2mLPsG6Vy2HzvV2ZfMKRAkzZZeyP2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUiScAwEw3qSdtfnZLRxvKxZHeqSjNksjegO/bhv/z6LRp+rlqRjnn9nT/VJizdZtNoSRY7nWAns3vqm6Y/zebu2HPsnNRi6FE4/8mqywac6ZMY1DkCje0zjT98zCMQwmKlo1t+UZuJJ+EIuiiJdgToCwCi/zzmdkPNlFt50F3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBizphAP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBizphAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1981F000E9;
	Mon, 31 Aug 2026 14:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184939;
	bh=Aj1CkNmYBvikG01ZLZitR8oxsn+YFVYH2JXheSI9tCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oBizphAPDAbRXEu5APqXkyG8bwRjusF4GcpXmtpZ8iQv2MORlI3J3jseWpp2DiZre
	 08CjPjO0mCAlJY+EzpiayB2aRaRRAfexcrIDPGrFJda1/Xycdd2opBM87/661Ga+4r
	 5IMSbLkO4QBGKk3u/p520tSluaNEax/gPyHSe2dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 6.1 63/92] accessibility: speakup: unregister tty ldisc on later init failures
Date: Mon, 31 Aug 2026 15:35:01 +0200
Message-ID: <20260831133402.942045221@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2430,6 +2430,7 @@ error_kbdnotifier:
 	mutex_lock(&spk_mutex);
 	synth_release();
 	mutex_unlock(&spk_mutex);
+	spk_ttyio_unregister_ldisc();
 	speakup_kobj_exit();
 
 error_kobjects:


