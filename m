Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B241E907C;
	Mon, 21 Oct 2024 10:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506987; cv=none; b=FC5dUdENPfysf6+PbSJfcG1zZarYkx/cvwMVvlIYrQ0NwCYC3DWlNeL+4am4drI/7jxVv/KOBRLf4GMMz+IghLFNhNzfbC5flqr7ga3VCWgeLB1dBeOayXZ22sTkRRVUZz88nC708FOuUtadE6VzP3W4Ag+1Usz6Q1awas6c6Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506987; c=relaxed/simple;
	bh=mRpisEpSbJeOzRGWgiNfuhJKgZN7KWoc9P+zKLbQAX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZB6q8v+93ffw6qaqC4epTSO/9YRkOhP9rSN5wFWfZlylVGUy2IVkJfb4p6+7glIw/HMOhHd4WawpRNXm1dx0KmihrcPqzFoRLDk8+C8sO4mv8XM+XKt88I1hj/ObsSiZDjoPWwd1RzU89u5diyUskEXYXmbCPqlG/Rraiw0dG4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4DdVu8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4DdVu8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19328C4CEC3;
	Mon, 21 Oct 2024 10:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506986;
	bh=mRpisEpSbJeOzRGWgiNfuhJKgZN7KWoc9P+zKLbQAX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4DdVu8jf10dY5AtbAabF8KDiLnzKuyFroRIykLI5UlvThLoRtN/kVjhYSaBPbdux
	 nFpHQjrYtBneQKjy4cNMkonpuQ4/ph9GyoFAP+ylK5BWtI+2JrDQ5pGbZ0UnkwZPo/
	 j82SFQ+qbJyicykcDVH2JdWESfmxz3SRPNbmZYHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.6 050/124] s390/sclp: Deactivate sclp after all its users
Date: Mon, 21 Oct 2024 12:24:14 +0200
Message-ID: <20241021102258.664966459@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1195,7 +1195,8 @@ sclp_reboot_event(struct notifier_block
 }
 
 static struct notifier_block sclp_reboot_notifier = {
-	.notifier_call = sclp_reboot_event
+	.notifier_call = sclp_reboot_event,
+	.priority      = INT_MIN,
 };
 
 static ssize_t con_pages_show(struct device_driver *dev, char *buf)


