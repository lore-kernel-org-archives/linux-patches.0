Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568DA3F6C49;
	Fri, 15 May 2026 16:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861587; cv=none; b=sIzakqXsoVdYLnjRcIIavyBAYW2nx6mUK+fxeHjux/pcgE2ctgOg4XUOfcqE7/JoeVunntTs7oKQzE/f9dnykBAAuIYMaopzFVA5SDEB4F/hBOeLF5tJPCQCpkaY4p91wW3MmIyqjLvUBUiXDiYtX/o5VQ0lTwwOnJg0KDlGbRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861587; c=relaxed/simple;
	bh=u9VBuS1yVRlwGkfMzbIpAZihSYcRVNFO3qVFjz0H90k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWG8HSzoajKw7lseg5+UZugU5fqHgIrKGOl4i3CYOkdTS3hhjBtR+r/AlM0/56JkCnZ1lYSzdruAw1iIsjjFFberpcKjGUiFqwFaOgYBSwQBTNj3r+HvsVbhRLBsKjiFSEW6TTXtJqyuNpX9w2EXgxGf7d2qR3TASLyQdw0O/Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JytSYZbw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JytSYZbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF30FC2BCB0;
	Fri, 15 May 2026 16:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861587;
	bh=u9VBuS1yVRlwGkfMzbIpAZihSYcRVNFO3qVFjz0H90k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JytSYZbwUv5G0S8CKTIMJnyZX+/vjk7f8yw0+uRR0/UV8d15FAWsDtAvfVsNAv9Er
	 RWV2iVOlvIMN6Aul0X3aK+lE0Fx0+5x7gmp2RoN2f7Z+jrS9SOh9WGYrIHg0iT3aWu
	 7fYNFuAfvr41pqc9BZzBxs8vVoeqt+AEr3fRCHeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiao <252270051@hdu.edu.cn>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.6 379/474] ipmi:ssif: Clean up kthread on errors
Date: Fri, 15 May 2026 17:48:08 +0200
Message-ID: <20260515154723.234779060@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

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
(cherry picked from commit 75c486cb1bcaa1a3ec3a6438498176a3a4998ae4)
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
@@ -1913,6 +1915,15 @@ static int ssif_probe(struct i2c_client
 
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
 


