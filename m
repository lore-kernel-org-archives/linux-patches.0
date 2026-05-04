Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F013A7F4C;
	Mon,  4 May 2026 14:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903799; cv=none; b=lz+KtKTPQ+Plfo4x76UtFhzt7Rg5jLpxCGOplMcyK2eR/rDSWAvpteUefZlexc7LDQZkZaqqdXx1MDDgTUF0xirM3ARKEodohTXeSVoKZVEBLjMBdq6AaMkI6qyCujvC4b4/ZcvYXw3a3bk9anXo+Wu906FE9p8/7YAOwoKUwro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903799; c=relaxed/simple;
	bh=OKBgdSFymcVHS90uBl9DTmD8XE/nf6AXI9H7hV9M1Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtaePPJFVhaSin2j0iZ881FrhbQ/zQRgHpWM2VpxFqWky3Xyw2tVLi+2HS2P7GrXdBHC6pvkB6CmZmnYJH9UtYmJGZa8erHYcN9zITHIg+s8eOk8w5BC+VrU0MgUC66e1rrW8SUZ/ZK7hO8MnGibZTZMWDCHRvnjhC5F089XiTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zx1Ke8bO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zx1Ke8bO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B22C2BCB8;
	Mon,  4 May 2026 14:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903799;
	bh=OKBgdSFymcVHS90uBl9DTmD8XE/nf6AXI9H7hV9M1Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zx1Ke8bOsLOW7C2O2JlIPWfYAk7vn9m7xbDN6/WKRPOAZnw+06L6rlNhoKdo4ajfj
	 NIaAEJ7yKmYFcDm9iNXLPewU2YfvfQaM1SNzq7CpXS6B+EmKpy91GJDx6MSBvr7gGs
	 4l6f2OQWPaP96wMFdMO9UoS+mEZAprvykb/meXVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiao <252270051@hdu.edu.cn>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.18 067/275] ipmi:ssif: Clean up kthread on errors
Date: Mon,  4 May 2026 15:50:07 +0200
Message-ID: <20260504135145.421056583@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
@@ -1270,8 +1270,10 @@ static void shutdown_ssif(void *send_inf
 	ssif_info->stopping = true;
 	timer_delete_sync(&ssif_info->watch_timer);
 	timer_delete_sync(&ssif_info->retry_timer);
-	if (ssif_info->thread)
+	if (ssif_info->thread) {
 		kthread_stop(ssif_info->thread);
+		ssif_info->thread = NULL;
+	}
 }
 
 static void ssif_remove(struct i2c_client *client)
@@ -1918,6 +1920,15 @@ static int ssif_probe(struct i2c_client
 
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
 


