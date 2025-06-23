Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEFC1EEA3C;
	Mon, 23 Jun 2025 21:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714108; cv=none; b=jXDQ93jD8cbIlpZ0tXI2yUavbunXvHVhGPu+I5rLoi7cxG19Ggu0uZ2plcPqL1uahRNyxJJJHBQY1WoMXGJKW4cknkWYaOKuoTUX8yltTDfLN4NoHNlnbs0tnUtE1jrKwUhb2eoxbz7QCC0yhBTXXdO2YHb/dfiYiYbnv3VDf8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714108; c=relaxed/simple;
	bh=iKH9BsWku3fjsETt9sTFbFKGsGFqTjnxdDWX80zRai8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKHQ0GX7VpH4A1vy2l4SXWsbWbyyxyP+uLZLyl3HORCgRv3Us4f20fFIqTPqDmTKPnrq88hCzV54xo6ZxxIioGZ6fzmgh5IroGy3X3tFOV3OGrtbBROpas25/2qZgRhAUCMtszcrRwHtj86ntlFFP+oOh8CwR0skBI8jNFh96Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ll1BvOsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ll1BvOsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EFDC4CEEA;
	Mon, 23 Jun 2025 21:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714108;
	bh=iKH9BsWku3fjsETt9sTFbFKGsGFqTjnxdDWX80zRai8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ll1BvOsY6xv0UhNkSyYrp77rk5EikPda/U7cDQtW9kMhMCY36pW+rBwhLqG3OQKqL
	 DIGKGVdMTO65tdFQ/ZyR0hEKE45yPfwA1idBD9Z9jub/blJt68bDft1s921XWmSRsF
	 XpbJtILdye5honnpsWRzrPVj6B5suzMUnBFmoaVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <cminyard@mvista.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 371/592] ipmi:ssif: Fix a shutdown race
Date: Mon, 23 Jun 2025 15:05:29 +0200
Message-ID: <20250623130709.266189176@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

[ Upstream commit 6bd0eb6d759b9a22c5509ea04e19c2e8407ba418 ]

It was possible for the SSIF thread to stop and quit before the
kthread_stop() call because ssif->stopping was set before the
stop.  So only exit the SSIF thread is kthread_should_stop()
returns true.

There is no need to wake the thread, as the wait will be interrupted
by kthread_stop().

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 0b45b07dec22c..5bf038e620c75 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -481,8 +481,6 @@ static int ipmi_ssif_thread(void *data)
 		/* Wait for something to do */
 		result = wait_for_completion_interruptible(
 						&ssif_info->wake_thread);
-		if (ssif_info->stopping)
-			break;
 		if (result == -ERESTARTSYS)
 			continue;
 		init_completion(&ssif_info->wake_thread);
@@ -1270,10 +1268,8 @@ static void shutdown_ssif(void *send_info)
 	ssif_info->stopping = true;
 	timer_delete_sync(&ssif_info->watch_timer);
 	timer_delete_sync(&ssif_info->retry_timer);
-	if (ssif_info->thread) {
-		complete(&ssif_info->wake_thread);
+	if (ssif_info->thread)
 		kthread_stop(ssif_info->thread);
-	}
 }
 
 static void ssif_remove(struct i2c_client *client)
-- 
2.39.5



