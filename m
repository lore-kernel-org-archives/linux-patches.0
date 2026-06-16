Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CCB2F12AE;
	Tue, 16 Jun 2026 18:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632922; cv=none; b=UzKJQffExi8EdEuTxAVJAqLSSgBCuKeulptE+gWLBHJO3Aezw6mmabzHwO24pQg3eec4f1qt7UEZvo4Dp1feN/cZTcOo9T8OaNlX6q09crR6c2nff4YUpECmux+9i3U3FDAnL3yGeBpoTdQjNa9K2UN+EXx/46DoOnnjYxvScdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632922; c=relaxed/simple;
	bh=+e2boGZ1fqnDzoRojDB1aeotpDcf6tHORqT1guzXXEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8U4nonX8ZmmdoydM0hmGPLU9QdMKzly43/athDL+20GSDuhqkMO7aXgOpsviKcN8dH2AMHLEI4ui/z50+DQEJwhpD/ePq4YP4G0GexOu3Aj/W9bOwofA5VTlZ3oqI2IAea0/QiY5cXAMsXSoMwwbNZUyY6pOMRWcGVDPiekg4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEngv096; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEngv096"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADF31F000E9;
	Tue, 16 Jun 2026 18:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632920;
	bh=SRoudnKKWTBz5NAA5h+2gfozovrElM8yR4zBGq27+YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zEngv096Sm1zYqhNdTG4MB/L8DqCpM1a8kyvAZyEFoJ3A6q+q1w3nTboS2F+akZDg
	 m63Y8INge2X5o8uMSKTmkNLvN2b3psbLvXUkNkdkS+pJZsHAJUE2E6SaiGRQi7gZ+9
	 36EOI1276o1Pmn7H171U+5rfOExXha3OJy2g2sy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiao <252270051@hdu.edu.cn>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.1 502/522] ipmi:ssif: Clean up kthread on errors
Date: Tue, 16 Jun 2026 20:30:49 +0530
Message-ID: <20260616145149.245848616@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Corey Minyard <corey@minyard.net>

commit 75c486cb1bcaa1a3ec3a6438498176a3a4998ae4 upstream.

If an error occurs after the ssif kthread is created, but before the
main IPMI code starts the ssif interface, the ssif kthread will not
be stopped.

So make sure the kthread is stopped on an error condition if it is
running.

Fixes: 259307074bfc ("ipmi: Add SMBus interface driver (SSIF)")
Reported-by: Li Xiao <<252270051@hdu.edu.cn>
Cc: stable@vger.kernel.org
Reviewed-by: Li Xiao <252270051@hdu.edu.cn>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_ssif.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1287,8 +1287,10 @@ static void shutdown_ssif(void *send_inf
 	ssif_info->stopping = true;
 	del_timer_sync(&ssif_info->watch_timer);
 	del_timer_sync(&ssif_info->retry_timer);
-	if (ssif_info->thread)
+	if (ssif_info->thread) {
 		kthread_stop(ssif_info->thread);
+		ssif_info->thread = NULL;
+	}
 }
 
 static void ssif_remove(struct i2c_client *client)
@@ -1916,6 +1918,15 @@ static int ssif_probe(struct i2c_client
 
  out:
 	if (rv) {
+		/*
+		 * If ipmi_register_smi() starts the interface, it will
+		 * call shutdown and that will free the thread and set
+		 * it to NULL.  Otherwise it must be freed here.
+		 */
+		if (ssif_info->thread) {
+			kthread_stop(ssif_info->thread);
+			ssif_info->thread = NULL;
+		}
 		if (addr_info)
 			addr_info->client = NULL;
 


