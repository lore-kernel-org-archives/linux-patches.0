Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9043A329C48;
	Tue, 31 Mar 2026 17:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976989; cv=none; b=rpb97D1EAqzPqjdekcQzkpOkaNHdcRi+TB/VB5Vo0MhSzoa0OVgx79oF8XT4WzawN8/SO47GdgXpgqemD7LuKByBiXuSzrNzXmK7vxUDXCGuTND/Ek8ryKV9GiLRqKNgFOyvXtTHA2V70Nh7ZPHC6NJsBQzwAlFrpag8Y+nEATM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976989; c=relaxed/simple;
	bh=nCRvFFXEBgjdkQGFcPABF+4id+pny9HABCJvisV3DM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIXCKRxTwTjaxvw9RWvx3nsZs2vrB5F7MmYMjwCU1vShD9mVYYaTLtmtZ8yquHpDmiAg8F2qFyRyb1XUVng59rJZg/iMFPeG3AQO/N+5imlp+PbsSpY7Ptw1rjYKNuf6r7ynuAUcjEFHqT6G+ny8sfAITfaN6qAGn2tYiE+HhgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jW26FpLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jW26FpLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48356C19423;
	Tue, 31 Mar 2026 17:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976988;
	bh=nCRvFFXEBgjdkQGFcPABF+4id+pny9HABCJvisV3DM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jW26FpLoxTHl1NmDc2s0ejpxFgLjBM1gnSg16DwlT8MmV19//GMe8rTNVZ7GjIAc1
	 kb5MmfRkfdj9rTawcVXpT1e1ETwR+lsCUwANT3ah/K8hW9hUi/AtEr+fZgcGkTRszM
	 JGiQLux6ZxeqR/41cZRg5VltbAXsnHmQlqeDUSIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GuoHan Zhao <zhaoguohan@kylinos.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 304/309] xen/privcmd: unregister xenstore notifier on module exit
Date: Tue, 31 Mar 2026 18:23:27 +0200
Message-ID: <20260331161804.753950118@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: GuoHan Zhao <zhaoguohan@kylinos.cn>

[ Upstream commit cd7e1fef5a1ca1c4fcd232211962ac2395601636 ]

Commit 453b8fb68f36 ("xen/privcmd: restrict usage in
unprivileged domU") added a xenstore notifier to defer setting the
restriction target until Xenstore is ready.

XEN_PRIVCMD can be built as a module, but privcmd_exit() leaves that
notifier behind. Balance the notifier lifecycle by unregistering it on
module exit.

This is harmless even if xenstore was already ready at registration
time and the notifier was never queued on the chain.

Fixes: 453b8fb68f3641fe ("xen/privcmd: restrict usage in unprivileged domU")
Signed-off-by: GuoHan Zhao <zhaoguohan@kylinos.cn>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260325120246.252899-1-zhaoguohan@kylinos.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/privcmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index b8a546fe7c1e2..cbc62f0df11b7 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -1764,6 +1764,9 @@ static int __init privcmd_init(void)
 
 static void __exit privcmd_exit(void)
 {
+	if (!xen_initial_domain())
+		unregister_xenstore_notifier(&xenstore_notifier);
+
 	privcmd_ioeventfd_exit();
 	privcmd_irqfd_exit();
 	misc_deregister(&privcmd_dev);
-- 
2.53.0



