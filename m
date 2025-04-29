Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120FA24113C;
	Tue, 29 Apr 2025 16:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945242; cv=none; b=dW38UpT/0/HO9CYxf3szlUfpfFE6i2dDkaQ0MjvOUTsDbtpbJctSdNoRPvstGyxregSAgJMeUn64zT87XsGl7Hx/0HcrXoQweilnIuOqebx/zJReuVP6SfdVSf210OfljhUnbwzEipIWq2hPNaA3ZNpJBISmYjMpqM55hh/bKuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945242; c=relaxed/simple;
	bh=NfHZ694NXGxJHDH5Ce6lCKqeov4toAm0Sk4miTAMu/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sax1CuccK75h1Leee7lzuu6wLfFzYL557P5YcIVaXw6szyBcv/fPVgAf/SkwjsA5JbWVhZs/Db+hDz8UWQRXwedGOGsiJwyqY1781oO7vGoF6vSuE60Q1z9nQdSRIZv9dg9baZ31VKPC9JZxW6Icd1XKyHSiGXt1zvPmbaCapj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvFeO4o8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvFeO4o8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C29CC4CEE3;
	Tue, 29 Apr 2025 16:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945241;
	bh=NfHZ694NXGxJHDH5Ce6lCKqeov4toAm0Sk4miTAMu/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvFeO4o872IEncqw8ovtUluRwjluLAyD8T0v8YSlafarz4JP+MUfzi07JlnO2V1ow
	 3z6E4vvQORWJV1qYEnopp58ryKFvovK+dWPOXXA1ks5qHyn+vi1H0d9kKw1w89xrWc
	 0L8oav0lyQ0zSErgUco4JN/Wjj2Pz7gBK8lv8lQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.4 047/179] media: siano: Fix error handling in smsdvb_module_init()
Date: Tue, 29 Apr 2025 18:39:48 +0200
Message-ID: <20250429161051.306603289@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1210,6 +1210,8 @@ static int __init smsdvb_module_init(voi
 	smsdvb_debugfs_register();
 
 	rc = smscore_register_hotplug(smsdvb_hotplug);
+	if (rc)
+		smsdvb_debugfs_unregister();
 
 	pr_debug("\n");
 


