Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF9D17BED0;
	Sat, 17 Oct 2026 16:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253928; cv=none; b=AmEKUXfOd068itkZ5zemQaaTXv056ysb4R1MM0bly2556levCfW1y416Y5mmhS1Fby8onMASSkC/C9pPqpvoz67k6WceEvZhflfSZ+N2ZZMV8tkpZXu0lzDSwHuuJOpzOx6USEIFVqs/LDXU5aWZ2/FZDJLwmA7yYzrfvSrCGJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253928; c=relaxed/simple;
	bh=EyQyvvFJtIAXXRGifHkYe5ZfJeYkzNAKheU/Jucopko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zq9BZpkNoY0VyHvJGpeR8/85v1actWpWWKd+QBROGni+YhFdCq/rPRcORa3MDXiALFFSacXvH8rU93y2W1J/wT3CvaHSlzLNU8bLKiav+xM4yzBSdZ/eIxlyylzgTfCm16t2mY1hSv8JpAACb3VzNLDt7PzFTNYzBkbI42C/3sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjMLk7t5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjMLk7t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC78B1F000C4;
	Sat, 17 Oct 2026 16:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253927;
	bh=rhs9tVtHCLGqQ5fDc4fkXJZtk7is9l2lTpAZGXJTbLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YjMLk7t5OrAaj59qpt7YRU/at+PxU1acQip10aX9+LbhNNULZnI51KXN3K/HIcuxC
	 hk71PIvavFhF9Gq+BDJpy++aw1k7sdkoH2rjye5glcBpKA2NaUHmZYtBYMufhu6gGv
	 WMLdodPMkrqPyXx+erHiQIZz1V27cl4JB+WGTGlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiao <252270051@hdu.edu.cn>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 278/869] ipmi:ssif: Clean up kthread on errors
Date: Sat, 17 Oct 2026 17:51:59 +0200
Message-ID: <20261017160044.197865072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

[ Upstream commit 75c486cb1bcaa1a3ec3a6438498176a3a4998ae4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 7950f13c1ef76..a19184151323c 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1292,6 +1292,7 @@ static void shutdown_ssif(void *send_info)
 	if (ssif_info->thread) {
 		complete(&ssif_info->wake_thread);
 		kthread_stop(ssif_info->thread);
+		ssif_info->thread = NULL;
 	}
 }
 
@@ -1936,6 +1937,25 @@ static int ssif_probe(struct i2c_client *client)
 
  out:
 	if (rv) {
+		/*
+		 * If ipmi_register_smi() starts the interface, it will
+		 * call shutdown and that will free the thread and set
+		 * it to NULL.  Otherwise it must be freed here.
+		 */
+		if (ssif_info->thread) {
+			struct task_struct *thread = ssif_info->thread;
+
+			/*
+			 * The thread exits on its own once it sees
+			 * stopping, so hold a reference across the stop.
+			 */
+			get_task_struct(thread);
+			ssif_info->stopping = true;
+			complete(&ssif_info->wake_thread);
+			kthread_stop(thread);
+			put_task_struct(thread);
+			ssif_info->thread = NULL;
+		}
 		if (addr_info)
 			addr_info->client = NULL;
 
-- 
2.53.0



