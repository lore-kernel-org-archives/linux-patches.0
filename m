Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018129;
	b=TWXfc84ADGNYaAUUaidYFw6PIViuJP1a0Tgx1PenWwmRjk3uACurY9zLnRecIGy9tF/o
	 Og4/Gr0RdL1Iin0QEL7G+mexNGeMMrw+DsdHtkaJ7xV9Rb2fPKx3H5vTjK1kdHCjSiyB+
	 vDu3RPDxSTcA3D5UxsQli3igrngcAY/h+BLM0nbxNblQRY/0n1S5Y9QyBGxegc2VMyJLt
	 Q88Fb12An2z0Tf9OCRXDOCPq5sPeYtYwzqaRf51PhX5ybOYnWKY5SjuVQq+fIMNgWGAXs
	 x63AFHQAWrTIYujg3jwuzCgCFw5gt8FuwfpO9iYLVWzYqdRaYvVXldzLHCznB+v8s0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Al4hWfSG10afvkV+AKLkMxEoKX8TT/F7UluzmUXXKc=;
	b=BKsGLGzfqnj9q76kqJoZslI23xhux0uDPI9pKozqWyWmIIUEglVjGfMv2ku9nH58mbIs
	 kUeKBeqRFAYiQIDeq+vbxjL/9E6WnmXCo+tv/E0EPI2qjjZKam39tDijj2mbQ+vExQfRa
	 yhdphMRWzcyloZRsY518Qez5kZvF8mrcF6C4U5LM9qQhaYWmbrxbEB6yS0Imlk0aUPiPo
	 m431O4Edo+mYgfnSHmmEk4mxIuLqHvY5yU1EcW6mzettz2F59U/QwkLJxHDB4v2JtntM3
	 vBk8YwUUzSGNOVTE4sDFusseqx1hqs7HyWrs/E5tP+rlHgf7QynVg+L/OMOklFrjUkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MOHIweTv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8F6606A320;
	Wed, 18 Nov 2026 16:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MOHIweTv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16DC1F000C5;
	Wed, 18 Nov 2026 16:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018129;
	bh=4Al4hWfSG10afvkV+AKLkMxEoKX8TT/F7UluzmUXXKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MOHIweTvYKdIYCDnOXv5WzVw67qcqQSHjlAX0sYoPGvGPJKhDk9OqKbLyi0pqYCt9
	 Inj9S2Z9+xDp3TV/g2Lo0+bMoALSv3sqCJhR+QUoNuu9TPJx0WN75TdHICFASd4WfN
	 FNgSKZOIYG4CDdnsEq9BYjxLsVBrGYJXeY07KM/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1116/2651] misc: enclosure: fix UAF on device_register() failure
Date: Wed, 18 Nov 2026 15:39:16 +0100
Message-ID: <20261118150328.183526024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit 0f3b12bab74e13a2b8686a49c5b83099da61e032 ]

After device_register() fails, the embedded struct device has already been
initialized and must be released with put_device() so that
enclosure_release() can drop the parent reference and free edev.

The error path currently does put_device(parent) + kfree(edev), which
skips the device lifetime rules and can free the object while the device
core still owns a reference (use-after-free).

Fixes: d569d5bb3fd9 ("[SCSI] enclosure: add support for enclosure services")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Link: https://patch.msgid.link/20260806070358.1599627-1-gonglinkai@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/enclosure.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index de457378c5014..bdbff5178ec70 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -148,8 +148,7 @@ enclosure_register(struct device *dev, const char *name, int components,
 	return edev;
 
  err:
-	put_device(edev->edev.parent);
-	kfree(edev);
+	put_device(&edev->edev);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(enclosure_register);
-- 
2.53.0



