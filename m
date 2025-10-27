Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3371931B819;
	Mon, 27 Oct 2025 18:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591268; cv=none; b=uiCn+2QGJpzPOb5gqGGQ1U5YYmzXmKM0U5WTm1vtqR1AVe1LseKh2DskCYDDc+ogEua2D3t4w7SxFkY9lLjG6gsDyFrJL/Lvy4IyxikbJSLMt6n04azeTusbIkh5/l4a9cM4dLT9cV5+anf748KRP3Yj9i+B5+b5XEYHYBlapy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591268; c=relaxed/simple;
	bh=EkGITUN8jU8mTOBbR2V/qK8qFYRlkOzvwlBNcSbCuVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iag8O6JaO/IHU89/puph6DBXayg6zChvZGsK1Ipg6quLrqd/jEe78hhSQEfY0fVtdHmJ82OL8USnnYaMAVtoQ9vmbx0dC7DuJpNvT202O5oDf5EqsDPaisgaSBxy/h06s/o7kkfKWoi5uDp3iObmiyQnS1ZzW3NbPFtCDQnO2MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EpuI01K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EpuI01K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45A2C4CEF1;
	Mon, 27 Oct 2025 18:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591268;
	bh=EkGITUN8jU8mTOBbR2V/qK8qFYRlkOzvwlBNcSbCuVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EpuI01KB/mB+5iTQXTCtxjyQc9tcDeOch7xPlTp3rEK5x0lbNVBDWAxDDFLevVxa
	 TE/a21WXwZ9hqk8NPmXMk6+quYM4i8NvMJqWPPVBBWt+MTjESH7w1Om41jkHmJtDqi
	 BJmlByLIOsVKoenrZwC1G1h2VHtVfYFa2eA9f2o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 132/332] xen/manage: Fix suspend error path
Date: Mon, 27 Oct 2025 19:33:05 +0100
Message-ID: <20251027183528.115309296@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit f770c3d858687252f1270265ba152d5c622e793f upstream.

The device power management API has the following asymmetry:
* dpm_suspend_start() does not clean up on failure
  (it requires a call to dpm_resume_end())
* dpm_suspend_end() does clean up on failure
  (it does not require a call to dpm_resume_start())

The asymmetry was introduced by commit d8f3de0d2412 ("Suspend-related
patches for 2.6.27") in June 2008:  It removed a call to device_resume()
from device_suspend() (which was later renamed to dpm_suspend_start()).

When Xen began using the device power management API in May 2008 with
commit 0e91398f2a5d ("xen: implement save/restore"), the asymmetry did
not yet exist.  But since it was introduced, a call to dpm_resume_end()
is missing in the error path of dpm_suspend_start().  Fix it.

Fixes: d8f3de0d2412 ("Suspend-related patches for 2.6.27")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org  # v2.6.27
Reviewed-by: "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <22453676d1ddcebbe81641bb68ddf587fee7e21e.1756990799.git.lukas@wunner.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/manage.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -116,7 +116,7 @@ static void do_suspend(void)
 	err = dpm_suspend_start(PMSG_FREEZE);
 	if (err) {
 		pr_err("%s: dpm_suspend_start %d\n", __func__, err);
-		goto out_thaw;
+		goto out_resume_end;
 	}
 
 	printk(KERN_DEBUG "suspending xenstore...\n");
@@ -156,6 +156,7 @@ out_resume:
 	else
 		xs_suspend_cancel();
 
+out_resume_end:
 	dpm_resume_end(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
 
 out_thaw:


