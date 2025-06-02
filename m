Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ABA22A804;
	Mon,  2 Jun 2025 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875238; cv=none; b=pFsoVWLGmkTIkNiqayp+/MtuopktX9ALGnRj2KC1jtawdTijVbfCvZvYaT5plhZk/3qGqnjSZ5Lq+/nJNFNq/NOoJzBAmxMwXiFb41qkM3EctdJEkbyes0sNtSYc2w2AIEFUp0RQ5TvV88zSujVUQXrMbup6u2VPpHkf9wwbFq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875238; c=relaxed/simple;
	bh=4IQJTkr2a6uvdWEXrzM+0SljnCPjv0QzIBVWkv3zJRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwmwVr+eGewPwOPV3QX8NyP28XEPQhQwcZeVtkhvqcGO+l/OVoDPUxwzxMtR0f3hbaAnXGtqmTBvV+dKDchN7qsQU4gi2bgWw5RWoObpY0N0bfUdQIQlJt0XSQ1f7/mrMVAVFnRYbadXfGIN0h+ixkyozsglD8WOFnyA89C9MAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ml/+LWwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ml/+LWwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2D6C4CEEB;
	Mon,  2 Jun 2025 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875238;
	bh=4IQJTkr2a6uvdWEXrzM+0SljnCPjv0QzIBVWkv3zJRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ml/+LWwxIkklNGYP9frbirZ9MDNcPaCg2azZN4pOsn0sTyHqSFpR+HiBvOsX+TE62
	 BgNvz8sAKfGJDkBZY7U303knSeG9W67jddWDmNYrg9DDGMOHwuPH8DG8ipyVjboOQ0
	 W8dHyfNCRAwlgr49EKxiHtuHablXUUdklMKlhtjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 5.10 072/270] usb: typec: ucsi: displayport: Fix NULL pointer access
Date: Mon,  2 Jun 2025 15:45:57 +0200
Message-ID: <20250602134310.128431453@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -270,6 +270,8 @@ void ucsi_displayport_remove_partner(str
 	if (!dp)
 		return;
 
+	cancel_work_sync(&dp->work);
+
 	dp->data.conf = 0;
 	dp->data.status = 0;
 	dp->initialized = false;


