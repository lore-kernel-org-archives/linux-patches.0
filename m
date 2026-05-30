Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0508B1A680F;
	Sat, 30 May 2026 17:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163529; cv=none; b=PjkFJaUqJvsK/rfOgzIfplqgY39+RLiUcIQep3if3h/v1yCcInUqHU7wHDDSdUsA4DLCANG5tch2/fKWqn6o55HbwVX1i2J4D9gMcBd7Bw7hqkNKZPLroVE67PAENwiZoYwI169DDDOrQC6f6siXOHbGqNmTy2SRuG2qeBz0q9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163529; c=relaxed/simple;
	bh=gna57Fm68ACA+dGs84DgavJCr1whJQwVTPCmzooE0ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fV7/ovC1JVeU6uBo4X9uHpIvILApx8XqnWpjU0B+G+g6r7JDWfOVCktTzmOggIQ/e7nN8fIyH+0vR5lCx3iM7q/UIXXhjwvTdDZstxcxsBRuRyB5Eu6NlhS8ydN+85nwo6m9kRdADA706zCN/iv+bWHutxCzzze3zb99NlAekFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McnjCg9X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McnjCg9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1171F00893;
	Sat, 30 May 2026 17:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163527;
	bh=K9BKy+nShem/nOtwdwiZ1/agD+UtRgRw+QGmAwFOLOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McnjCg9X29jgF7wJ965Ky0EBMerOGZ0Wm+DxHJm3fTEQY38/xEUrvQLYom45Dw98Q
	 +zT40jBQnGpp5cZ/tI7Wnb+7dGBS5Ju3PVboRkTpccCkScGofUdudTVYf/uhQg6aUC
	 AQ1DTufMPraRD9lBrcvxFlKJE/3tvYho1YxQ9irg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <cminyard@mvista.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 285/776] ipmi:ssif: Fix a shutdown race
Date: Sat, 30 May 2026 17:59:59 +0200
Message-ID: <20260530160247.922043486@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Corey Minyard <corey@minyard.net>

It was possible for the SSIF thread to stop and quit before the
kthread_stop() call because ssif->stopping was set before the
stop.  So only exit the SSIF thread is kthread_should_stop()
returns true.

In the mainstream kernel this was fixed in 6bd0eb6d759b ("ipmi:ssif:
Fix a shutdown race").  However, that requires a fix in kernel
version 6.1 has a fix to kthread stop to cause interruptible waits
to return -ERESTARTSYS on a stop.  This has not been backported to
older kernels, and that would probably be a bad idea.  But it means
that the mainstrem kernel fix for this will not work.

Instead, wait for kthread_should_stop() to return true before exiting
the thread.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index a811b5bdba259..42cbf761fa749 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -522,6 +522,16 @@ static int ipmi_ssif_thread(void *data)
 		}
 	}
 
+	/*
+	 * The thread can break out of the loop if stopping is set,
+	 * and this can be before kthread_stop() gets called and thus
+	 * kthread_should_stop() will not be set.  This can cause
+	 * spinning calling this function and other bad things.  So
+	 * wait for kthread_should_stop() to be set.
+	 */
+	while (!kthread_should_stop())
+		msleep_interruptible(1);
+
 	return 0;
 }
 
-- 
2.53.0



