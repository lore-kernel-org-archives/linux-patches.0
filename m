Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864B4341AC7;
	Sat, 30 May 2026 17:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163532; cv=none; b=CpGcCRzZdoxuNbZJjg6S2y9XUdb7/yt6QJ2TulpDfZfrPlKMW77FbE2bz1H7KYQPNb654i5ahfyS51oTkdwB2F6Gpf2sWPcenoeZe2n73wtEJYtYJKqOAFDshcDShvSRQpNtDmMYRfnS+tRLfRE/WwFPSJNLF0Hbb1BSfFpgs8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163532; c=relaxed/simple;
	bh=OgfvdH4jg2nAV1TAstJdaKJJhvP75vIwqs/wi8srbco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmGLWKf1sdAkEnGic8Z0l76+5G/txXBM8RVHDSApN6ZTBY5E2SsDZFcfG+Jn83JhF2XWo6vXZBsz3MZwaxUgmlnBYSS/17s68CWTHlWVz9VYjMJ5Fk3fC5VeRCdHdmBr0fVX1dEY9hQ/YGJzp+7IR+0ZseYK9zS/7kiuEWiNVV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCInDkY8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCInDkY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93EE1F00893;
	Sat, 30 May 2026 17:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163531;
	bh=RTfI+sF4+ZmXQVUZI271dOVVoY4JwOB9JZlEygHTcpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCInDkY8IWX03NBaGS/UXGbJmd7+cQuv3f1jIy92YNtJdByW+iyScSEXmllG1lVga
	 31DCv2T9NnKavk/Ilbo5Qup+ohp1RtNlfJ7vqV5osKUJKlaN3eU5HWHr3e3VUeFcbD
	 GmTKFnj5RE7qSTcWTaM2qTIhbpw/sBN04tVeH00o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiao <252270051@hdu.edu.cn>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/776] ipmi:ssif: Clean up kthread on errors
Date: Sat, 30 May 2026 18:00:00 +0200
Message-ID: <20260530160247.947980095@linuxfoundation.org>
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
[Adjusted for stopping flag and complete operation still being present.]
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 42cbf761fa749..55ebe1d31766b 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1311,6 +1311,7 @@ static void shutdown_ssif(void *send_info)
 	if (ssif_info->thread) {
 		complete(&ssif_info->wake_thread);
 		kthread_stop(ssif_info->thread);
+		ssif_info->thread = NULL;
 	}
 }
 
@@ -1941,6 +1942,17 @@ static int ssif_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
  out:
 	if (rv) {
+		/*
+		 * If ipmi_register_smi() starts the interface, it will
+		 * call shutdown and that will free the thread and set
+		 * it to NULL.  Otherwise it must be freed here.
+		 */
+		if (ssif_info->thread) {
+			ssif_info->stopping = true;
+			complete(&ssif_info->wake_thread);
+			kthread_stop(ssif_info->thread);
+			ssif_info->thread = NULL;
+		}
 		if (addr_info)
 			addr_info->client = NULL;
 
-- 
2.53.0



