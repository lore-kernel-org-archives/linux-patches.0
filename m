Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEA52367C0;
	Mon, 12 May 2025 17:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072110; cv=none; b=cWUJvy+jLq/8UwFm7HZaeJ4HFPDQhTxvu4ySxabKJ86RVdngHTcQfMVUP7o3WwwOJkLkVbL/Bhy1pEHkIlXFfHn0Y/eHiF/NulwvMwT+q5wNvBJfkFUPcJSMMwTN8BDTqIUb221VO6FS0PXAmex0pQ2yA+fGXWfmlJ1PsVoWmrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072110; c=relaxed/simple;
	bh=hA7aX+I3PKVt7JFBtnmrkefDEiiddQ4+d+vQdJDp+B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOkY+B79bk2V2wBT4RpGuGYAiBu518pLPCZGAyNtH9PdzGLeyilUBQK2fIlvB/vZFZ5uKqd6YBv1rzViV0SjeBH75MwX60wZZM+kvMpVQ5QOl0829tgnIfM+T5WCpXWxOeR6i1I+DuYgYKi6C6OiANtoT8hwHlXStDLYYrFvGys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4R2nUYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4R2nUYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B70C4CEE7;
	Mon, 12 May 2025 17:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072110;
	bh=hA7aX+I3PKVt7JFBtnmrkefDEiiddQ4+d+vQdJDp+B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w4R2nUYuIooch3tIUazkPknhwMnkdxkW8vjGOc+kzhP+9FxMt62omK7S3aefnGQxM
	 DAY8TvinWWUqbLG65+rYdT7GYRAB/llRiXd1QoR/1tui35UnlszEdB865NN3Pshimf
	 qt832qv3DrmtaW4+XVfRytSyvK8HbRQG5MDTSN2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 6.14 144/197] usb: typec: ucsi: displayport: Fix NULL pointer access
Date: Mon, 12 May 2025 19:39:54 +0200
Message-ID: <20250512172050.256874554@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Kuchynski <akuchynski@chromium.org>

commit 312d79669e71283d05c05cc49a1a31e59e3d9e0e upstream.

This patch ensures that the UCSI driver waits for all pending tasks in the
ucsi_displayport_work workqueue to finish executing before proceeding with
the partner removal.

Cc: stable <stable@kernel.org>
Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20250424084429.3220757-3-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/displayport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -299,6 +299,8 @@ void ucsi_displayport_remove_partner(str
 	if (!dp)
 		return;
 
+	cancel_work_sync(&dp->work);
+
 	dp->data.conf = 0;
 	dp->data.status = 0;
 	dp->initialized = false;


