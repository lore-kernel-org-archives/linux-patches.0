Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B3C2D7DC8;
	Mon, 17 Aug 2026 15:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979002; cv=none; b=YYUvofqLfaCXE3Gt6pmSq1gMzlYFiMhKhSbcxWY8LcYlDsvnsWVC5aKORvjS+9vAelBvBvEddkwfuF64e32WUticDBtgZWDVh4WmceZiqZ2EXhpATsxrjS2gAWwVvnZJTWHIrlI3vBcwfFBjtZcMFVRrTLgFuSo4ryKnr+bEKLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979002; c=relaxed/simple;
	bh=xhCjMZZzg4deid40Duvu2YZT0o9SRYiV1LSDONDHcAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssApLJgiTIvsg6GzVSFcWbv5efoJ3/dCj4E1Eckj9USzPm3XgygfHAXKNiuSdq6ZPeUqavb3z+xWvJ6a/7Ef2VC/KsNIcb2jXjrjhMB8N6jXnwgRvXIG/wPq/nNKLh0FqhthPYxCay7d+nge8HIUpqa+HAtfbUlw41SWXObV+Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pefQLWDb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pefQLWDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4111F000E9;
	Mon, 17 Aug 2026 15:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979001;
	bh=/3iMF7IKd3U2km9OrMIwLAMQ/Ku2pcuoximvVDyrU54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pefQLWDbfCP245cPjWuHBeHDdZ97QX2/reFZhO8UfU0NV0oPXpzsw05a/0jon6aNJ
	 Jbuq0idtgPfb9moVle+NpdkCV76W7laGf5b33b2sQVnr0ViQ+jy7NV/OAx5h5D+K2h
	 RZP7enUfkDr2It0viWFI+j8vOunKpWE1fSL3qUaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.1 075/609] usb: chipidea: fix usage_count leak when autosuspend_delay is negative
Date: Mon, 17 Aug 2026 15:26:11 +0200
Message-ID: <20260817132546.033823261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
@@ -1251,6 +1251,7 @@ static int ci_hdrc_remove(struct platfor
 		usb_role_switch_unregister(ci->role_switch);
 
 	if (ci->supports_runtime_pm) {
+		pm_runtime_dont_use_autosuspend(&pdev->dev);
 		pm_runtime_get_sync(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_put_noidle(&pdev->dev);


