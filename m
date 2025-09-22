Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A7E1FDA89;
	Mon, 22 Sep 2025 19:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569501; cv=none; b=gEhLHmOB1WvAc0KDGMouMLcWazeF42AKHXHGAjv4TrM+tdVXCJeLABqMwsthLOkiCQbwQ6oI0cHm0/cAGdxRK46aiQpszsTQNXlTExr6/0HW7u8WjKn3i2Bvxqhz3qVyQGFnEs1PDBx7Q8juCpk+W5vhNOaywHPJK3J+S5Gcc14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569501; c=relaxed/simple;
	bh=JLH0Bxfa1bdtWJZn32w0eCS7NX2mHEvJXR/Ou6LSQmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ER5gtNq62WpoCSIWV9ejw+WJQ35l/nawdXO+fS7MxQlOrL0WPhACbnpD+/8DN8rDqWxKHm13vMIDmq8oBfdNMw+UF/ESCRpAYTpcfPJ1JJ7WQn3AThAoaMmkiX2veaSckQh2Xx/f8OB/LUA4J8zMQLMKCyUFXc2uGmT2YhJYruk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6ivDMhV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6ivDMhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4626BC4CEF0;
	Mon, 22 Sep 2025 19:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569501;
	bh=JLH0Bxfa1bdtWJZn32w0eCS7NX2mHEvJXR/Ou6LSQmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6ivDMhVt1I6lR7D+iEFHUd9zCCG4ddOq/LqOYkATaJ8pajNKrUKGq9HIDI1oFmgF
	 rriggXMSPXXMD53ajS6/zM89BxFJZfI/WCG1BHQsWgPaMY0BHtkaXEMX/j7HjSWvu6
	 NG6DTPgM/iiqEICWPJq9M+oj3V6pfJESrH1JjZLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 07/61] um: virtio_uml: Fix use-after-free after put_device in probe
Date: Mon, 22 Sep 2025 21:29:00 +0200
Message-ID: <20250922192403.750599914@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 7ebf70cf181651fe3f2e44e95e7e5073d594c9c0 ]

When register_virtio_device() fails in virtio_uml_probe(),
the code sets vu_dev->registered = 1 even though
the device was not successfully registered.
This can lead to use-after-free or other issues.

Fixes: 04e5b1fb0183 ("um: virtio: Remove device on disconnect")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virtio_uml.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index ddd080f6dd82e..d288dbed5f5bc 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -1229,10 +1229,12 @@ static int virtio_uml_probe(struct platform_device *pdev)
 	device_set_wakeup_capable(&vu_dev->vdev.dev, true);
 
 	rc = register_virtio_device(&vu_dev->vdev);
-	if (rc)
+	if (rc) {
 		put_device(&vu_dev->vdev.dev);
+		return rc;
+	}
 	vu_dev->registered = 1;
-	return rc;
+	return 0;
 
 error_init:
 	os_close_file(vu_dev->sock);
-- 
2.51.0



