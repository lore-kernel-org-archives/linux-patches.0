Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC9147D952;
	Mon, 31 Aug 2026 14:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185221; cv=none; b=S2nxmsTuzzCV5Bx4F9msAsREp4Rkm1fqTOsKUP5Cr4PCcQK3UHd6gFaCYKWKLhW5D+gpQtfekw8GHo2ipLiD9lhM0JKr4I+M9OV20+oXsjAbgmhF/ve1DeNLaDUIQ+MrQb62i+TFztA1K64Kz++gpeImW62k5O7idHIQD9/PUAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185221; c=relaxed/simple;
	bh=daF6jyXtz4flAk9NaNxqek24hbAiA7THprxTTGs9FiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FweUWqJF0a9DkVwvmeu7MbiWZOVPvWRbsTpfz6Vi+K6jtDrIwbfZTu9HnKXqpCIeaOZHGK2qYirlT/RHm65dKkUe4zEK3sG5RshA1nQXrO0FjooSLgtea+rqB1Fqkxq45vKY9CJnxsX5Q1h6dNXWOMYhG4Nkr3VVHDwNli/rOWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0vz4aSi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0vz4aSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C478C1F000E9;
	Mon, 31 Aug 2026 14:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185220;
	bh=IZpSY2y4MqFJFFEDOSSlUE3rxwOG6LbD+ClX21VhA2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0vz4aSiy/n0JPpKqnX4OwWNXDOaDOOGZVqNJ3PfLSaDVAXMGEQ57g/hDDH8/cCKG
	 YYkEFOAZVXTTuxu6FKuy9zpV5dQY+bzwlixuBFwpjI5Si5hKcPioDU03v+QYwcZfPT
	 hj1z9iJoe0G9n5dvHlgn1/vAa0INBB8OD6hzjgrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 5.10 25/43] accessibility: speakup: unregister tty ldisc on later init failures
Date: Mon, 31 Aug 2026 15:35:33 +0200
Message-ID: <20260831133359.713207504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2432,6 +2432,7 @@ error_kbdnotifier:
 	mutex_lock(&spk_mutex);
 	synth_release();
 	mutex_unlock(&spk_mutex);
+	spk_ttyio_unregister_ldisc();
 	speakup_kobj_exit();
 
 error_kobjects:


