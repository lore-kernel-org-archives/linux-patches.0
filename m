Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2877541F5E6;
	Thu, 30 Jul 2026 15:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425576; cv=none; b=iF5ve5o/Gcou0kc6BHEsJhwVBuCXn0aEN0GlOBoAXHRkd2O2b8t9YxPLiD+bstT+8lcIQBb/VLLRr9qVle4TEm8zKouoSzijKGEklbSEt8NIf0poceji9IbuL28YIyyr4w+5gCHYqFuFuEpYxsy05erBJMOQ3u9teKizWfrIEVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425576; c=relaxed/simple;
	bh=QnKFi7qqE5iF9uzW7gUEWYiRbgGCUQJHUcrUyeV1jro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rxa6ohb/5t3ULiL156zT7WVingXjNtHm7uEOlSsmPN5I7fQJ0QuGJ4lw8ddOweshe/36arOvsxFVw7ZaCivD0tFVqjWRwRatYgs9rV2Dsih6pj8PtL+oKGKaKZGHc716rqCS+wHv3kyG+O1VTkz51w/Xs4ut8q6OgCFoj0IqaoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RA/zN9Rd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RA/zN9Rd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4138D1F000E9;
	Thu, 30 Jul 2026 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425574;
	bh=u+vVZEOSl5Y12eWCZZhqPady8b6RDnLM69ogJzOSB2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RA/zN9RdiXgtF4HaklrZX83T1HBk1eP+c/vjmyHE3naA1EbRxR9QM+B1otVRi5ON/
	 XZpKT12Q97yJ3G1h91qYsdIQnnJCQ30Cz/vg1iTeyUxNjgnllqGXPJoVPuSaahqh8l
	 vFuUJSJ7GOY9HJoP97krbT3AzsqHAfMFPO3T9BpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.12 117/602] usb: chipidea: fix usage_count leak when autosuspend_delay is negative
Date: Thu, 30 Jul 2026 16:08:29 +0200
Message-ID: <20260730141438.447525766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit fc3afb5728e297994863f8a2a01b88a920bbf53e upstream.

The probe() calls pm_runtime_use_autosuspend(), but remove() does not call
pm_runtime_dont_use_autosuspend(). This can lead to a usage_count leak if
autosuspend_delay is set to a negative value.

The pm_runtime_use_autosuspend() also notes that it's important to undo
this with pm_runtime_dont_use_autosuspend() at driver exit time.

Fixes: 1f874edcb731 ("usb: chipidea: add runtime power management support")
Cc: stable <stable@kernel.org>
Assisted-by: Claude:claude-sonnet-4.6
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260716104126.2763454-1-xu.yang_2@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -1265,6 +1265,7 @@ static void ci_hdrc_remove(struct platfo
 		usb_role_switch_unregister(ci->role_switch);
 
 	if (ci->supports_runtime_pm) {
+		pm_runtime_dont_use_autosuspend(&pdev->dev);
 		pm_runtime_get_sync(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_put_noidle(&pdev->dev);


