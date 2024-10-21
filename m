Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5CB1E130B;
	Mon, 21 Oct 2024 10:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507322; cv=none; b=Ape9QUm96P0sktCcVNOdh7+C9b/ErCOSDG4oChmv+QiNWGLE6I1cg5+qGhDlrbqVrfJx2CaqBVWOraugKxZs0qq6RIDU333fgjMGS+nhSJgKZKv2z38Aqy0cVdbHdNPAI/a+gJBvtCPAf04SKQV2wxRFWVNpq9X+c6Fl/ODhbVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507322; c=relaxed/simple;
	bh=IXTy9at3ZHwnYf1Otk7Sp11XpIgWHwoekWRtD5cbulk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VPVKf1B3IwrwpWjXJpfg9BPqiC1e/mIGJpqbmI56H52lkvKZOS7GGBM471eVMiZ0GKHqMS1+t8mhwvaUn10eCkC006M29bDRHJjzblqWkPhukX2AoKD/g+ke6BPPm3L95ma1BlexcYD9QwfxUGO4qL6WkOe6lgDuBHBa1//CpkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwNslH50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwNslH50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC28C4CEE5;
	Mon, 21 Oct 2024 10:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507321;
	bh=IXTy9at3ZHwnYf1Otk7Sp11XpIgWHwoekWRtD5cbulk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zwNslH508IcGEONVbTfIFc0z1B/UQ6jzKqdWFsU2sqSMABkZaHnF9Qb6yxdpenOCI
	 mFfNvJ2dPJp5WDuYu90Kv6sNLFL7GRuZRqxmnOfI/SGGyCm6i8pWRQo6+sdXpUIhsO
	 nhvryZQcjEdlFCGwskcd02u1EdBkpb41JjpvX69Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.1 39/91] s390/sclp: Deactivate sclp after all its users
Date: Mon, 21 Oct 2024 12:24:53 +0200
Message-ID: <20241021102251.349124771@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 0d9dc27df22d9b5c8dc7185c8dddbc14f5468518 upstream.

On reboot the SCLP interface is deactivated through a reboot notifier.
This happens before other components using SCLP have the chance to run
their own reboot notifiers.
Two of those components are the SCLP console and tty drivers which try
to flush the last outstanding messages.
At that point the SCLP interface is already unusable and the messages
are discarded.

Execute sclp_deactivate() as late as possible to avoid this issue.

Fixes: 4ae46db99cd8 ("s390/consoles: improve panic notifiers reliability")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Link: https://lore.kernel.org/r/20241014-s390-kunit-v1-1-941defa765a6@linutronix.de
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/char/sclp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -1200,7 +1200,8 @@ sclp_reboot_event(struct notifier_block
 }
 
 static struct notifier_block sclp_reboot_notifier = {
-	.notifier_call = sclp_reboot_event
+	.notifier_call = sclp_reboot_event,
+	.priority      = INT_MIN,
 };
 
 static ssize_t con_pages_show(struct device_driver *dev, char *buf)


