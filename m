Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B7E1EEA3E;
	Wed, 23 Apr 2025 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420803; cv=none; b=nTw5e4Sjwd4rsCliQuVKRW6dtnT19uEsIH87OED/qN3fg+BlICXqSpqlAV6fZf/00sZC7M4zdXMHMnF4yE7BAvPAiOxzp10yBlY1083lNII9LgTBXJm91+zp0bjzW32ec4WjZvy4brtr1ZlMN9hejPOFYAlIKw/1fzJrW0HXIqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420803; c=relaxed/simple;
	bh=06+K//Art929cgv+Zim5H8SLCl52FHd6Mtp2LuHJFRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azl+kXE+w8/FGiYu8E6qsjnhO+RcdXRg4TNdjUONg+90iWuT1hPscr0cu/yErRicCLynkV5bAjc3wWrx8a1ZDTmohK5p5HAoBlSWg4nTlTj7qMVtsZGTHgbjof39W1pDPnZ9Lb3MjQ9Y95+x3r9ASgU8y9zn9TIz4WKE/x/fsIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBG5gxg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBG5gxg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A94C4CEE2;
	Wed, 23 Apr 2025 15:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420803;
	bh=06+K//Art929cgv+Zim5H8SLCl52FHd6Mtp2LuHJFRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBG5gxg+cJApuWv+DlHCrTjQANOkIfeLFK1ByA1jmCPlIB1zoHIuLZAO1nHwt0YSB
	 qKIKSbHnHi0t8leKCLiuWpbDJtRAbaewoOujY2Ha7hQnBJjf/BhwjUFIAb1oYslAQN
	 vLAmplXXGlr0EGN+bGmrK+8pCOstBQ/ZKzRA+jMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 082/291] media: siano: Fix error handling in smsdvb_module_init()
Date: Wed, 23 Apr 2025 16:41:11 +0200
Message-ID: <20250423142627.719569463@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

commit 734ac57e47b3bdd140a1119e2c4e8e6f8ef8b33d upstream.

The smsdvb_module_init() returns without checking the retval from
smscore_register_hotplug().
If the smscore_register_hotplug() failed, the module failed to install,
leaving the smsdvb_debugfs not unregistered.

Fixes: 3f6b87cff66b ("[media] siano: allow showing the complete statistics via debugfs")
Cc: stable@vger.kernel.org
Signed-off-by: Yuan Can <yuancan@huawei.com>
Acked-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/common/siano/smsdvb-main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1243,6 +1243,8 @@ static int __init smsdvb_module_init(voi
 	smsdvb_debugfs_register();
 
 	rc = smscore_register_hotplug(smsdvb_hotplug);
+	if (rc)
+		smsdvb_debugfs_unregister();
 
 	pr_debug("\n");
 


