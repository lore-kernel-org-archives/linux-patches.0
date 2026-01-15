Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55123BF301;
	Thu, 15 Jan 2026 17:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498058; cv=none; b=W0f1suT1ynpslCe9IFIRY+5FCFfvRTtN0KF06jpPGcjLifYWdmrZvDf4beKt2V3DYYem4pt+dX3BHl6A2BAqKEkgVrTreeoa6IQ3mgj+N7xenwO10NnjzaK0e2GAeLMWWcoSOALl6K33uHjMvnNgpA7e4VBcih6ZDnEKXlz//sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498058; c=relaxed/simple;
	bh=0j0edBThRX3vunsC9zOxb75AJvVNX/lO5mB8quiHWmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5pTbsIoLFuRTWOW5oF0q7mlVgSkwvYlbxBDQ9ZykQ9hdVO6qWrChcd+BOAC0hDT9KIFVArwWjmNY6ivVure/GFxt3lGauC9HKMmnDxjwqxxs3KGctwvD4+9J3asaah26u0oYpehK6VaSxygPkUxXntxAxv/q5CY2Oc2gBasNhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rwz9pe9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rwz9pe9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F71C4AF60;
	Thu, 15 Jan 2026 17:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498058;
	bh=0j0edBThRX3vunsC9zOxb75AJvVNX/lO5mB8quiHWmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rwz9pe9q+imBHMZSrprZ7NDKq9mVZuChk9vUq8enBqybp/pTD7/LqX/1ctXIbfkYA
	 eFjjvmji5cUbw9OG+0NQfkklFninXx26BPBTeQz09oge7HFJ4O7JIXFGTc6A/vUn21
	 RnNZBWKOKMJtCEYZRPr1sy1Y0kjmiwNqMF0JEyac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Arnd Bergmann <arnd@arndb.de>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 298/554] char: applicom: fix NULL pointer dereference in ac_ioctl
Date: Thu, 15 Jan 2026 17:46:04 +0100
Message-ID: <20260115164257.018804130@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
@@ -836,7 +836,10 @@ static long ac_ioctl(struct file *file,
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


