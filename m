Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9980444AB6E;
	Tue, 21 Jul 2026 21:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670763; cv=none; b=prRBxYDYLDr4wA2pTMgjtAf31n3uUi0vHRZWs1bs5iahDVmUZ++MMa+mANe0YtqrCKoMeqRW8BfNbwan/C7wl2mNAywEzvR0JJKKpmeYQ+A78oTgYFQxxRxtNDK/b64K5mgkLws+N38mp+Hvl46EQNyiFNK6SmnjEneOrdZZQJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670763; c=relaxed/simple;
	bh=+rhvarRTP4bYoAwuRmDgxvcJJcv1W1cS/1MnZj9lg30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6TRrfPMCSxkck7h4dpivvTMVMlC6AY8uZpstn0OpN47wATlttKpp3n/rHe8TfYsa25Z1nIXAUoqAdwqKxqW+weuaS0YGxvQY9PGjoh3o+lfkwHSLfyxd0mF8XemTbFBPQ5Y9sKJU6TBNA8ET58Nj4Be/YnMYTWM7Vc5Lt714ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gzX72Qq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gzX72Qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5DB1F000E9;
	Tue, 21 Jul 2026 21:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670762;
	bh=t8UY+AJb13BEgKDFVDP8VQNnMyAXHS3SkkXxXM/8pM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2gzX72QqTYksSs7DKbmFI8yCH0k9d+IxkxrNpOhFfromrGKND/asUUEvsqBX2CVFF
	 H/PC682C2+V7nY6qpk3fOc3NGTUqCEJRIP5rhUYmcHjMFWaQ2M+UZz/6R9Uvf1lx9U
	 nu87gkXIMCksxXCeEk+lEpD9vo0+yTTsy9RUvR2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.1 1054/1067] driver core: Fix missing jiffies conversion in deferred_probe_extend_timeout()
Date: Tue, 21 Jul 2026 17:27:35 +0200
Message-ID: <20260721152448.165112330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

commit f9e6da99fe49277979798a1c3b9790ae10aaa18a upstream.

mod_delayed_work() takes jiffies, not seconds. Thus, restore the dropped
conversion.

While at it, fix incorrect indentation.

Fixes: 1137838865bf ("driver core: Use mod_delayed_work to prevent lost deferred probe work")
Tested-by: Biju Das <biju.das.jz@bp.renesas.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260525012340.3860581-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -327,7 +327,7 @@ void deferred_probe_extend_timeout(void)
 	 * start a new one.
 	 */
 	if (mod_delayed_work(system_wq, &deferred_probe_timeout_work,
-						 driver_deferred_probe_timeout))
+			     secs_to_jiffies(driver_deferred_probe_timeout)))
 		pr_debug("Extended deferred probe timeout by %d secs\n",
 					driver_deferred_probe_timeout);
 }


