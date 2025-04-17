Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2F9259C8D;
	Thu, 17 Apr 2025 18:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914416; cv=none; b=eXO9m5Cjk48/+Y8tyoHqLB/Q+XTxPzQxe/vO5nb9lvX2pYwoZ6qGJ9VpYcGcc05dkURqZFQij4xcREFCUmDTA6YcMVnx5EnKzL/bmHKhE0X72+pieQj6KzFwUZa/7/OxUySRAU+LcDHcmb3jWberdYEyA4JjBEJS6+Xy9zu0HEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914416; c=relaxed/simple;
	bh=1XclEZB8O/6+UvvfPvFRjV5N51AWffIFR1odE26T0Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcEgXHBsW+6p0TsnUKXI/5EGn6NPPGI6sG7VbYzoj84u2KL8o3He7aJ8429XGwEDcouv0c4ZdV+HQdlByioKpJNx/rAtMMZ7fphlyOSrnQebUGpmrZPh5Wr5ij8A0DhhUeS+jTmCyDuwmS/sPG7U9eJr0ncrvD7PatOUv0VAbeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yK68MhVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yK68MhVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15220C4CEE4;
	Thu, 17 Apr 2025 18:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914416;
	bh=1XclEZB8O/6+UvvfPvFRjV5N51AWffIFR1odE26T0Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yK68MhVhyJyv5yB7/LyHVEAtuq2h3AuUMY4NlzdgXQgnvOuW62t8tonkJzDTrHoWZ
	 6REz5nV9So4IG52Uf/WMrtcEumBn3hFnvEvkyeOcOSvNy4ieB3Pihswvsg0QDEhG7M
	 vZfKwfaTzsJLvQxos4XR+dJnxP5UHjRzyti8S0sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 207/414] media: siano: Fix error handling in smsdvb_module_init()
Date: Thu, 17 Apr 2025 19:49:25 +0200
Message-ID: <20250417175119.769181414@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


