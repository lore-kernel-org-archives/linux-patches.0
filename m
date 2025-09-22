Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63D52820D1;
	Mon, 22 Sep 2025 19:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569834; cv=none; b=JsTof7HEOyNr+sZ9yOUwNEf1g4fLroqQEMVRZpGPtX0YcXNU4Bg4dASKlgrdFmI47qxpDd2VhVRWc4DvXX3m4BBtO0bxDqH+sC/k5uSvLBL617jxMFGkko+OgYxDs/RiIRI46rbAa0pHdHUfac93VTOAN4HkqYQ3KNr75JNaAH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569834; c=relaxed/simple;
	bh=DEtt31B0JPviNAsgYD0ZMzG/KO1Q/uqAspSVFVKxYls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbnHq0O1s9xET34ISxya+nM+zLCLL2dDiLeZtc1qX2NabgCC5u/Vh7y4srkjqVwHnLNyzTHYYd0+OLNNfVLPiTxPeJwZlFgUZo9zLfHVlj6b4b6Y4jPKdZKbcsXDy6kQ95UMLmkvX6ndcv+LYU1xPtB+xBxf3UJDL0c1WzYVkL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6Vjh7tR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6Vjh7tR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD18C4CEF5;
	Mon, 22 Sep 2025 19:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569834;
	bh=DEtt31B0JPviNAsgYD0ZMzG/KO1Q/uqAspSVFVKxYls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6Vjh7tRNmy1ob99BbNDbrlgddBOGd7ibBmp//F5gdgU4hV6pulsX2JA54/L03XVA
	 d/TNS0FXaeMXhcygJdQ5WO1HQ0mUqTfwIf2J1KYhu6Cv4ssxAUWoeIaJ6lLic3A3j8
	 zgKHeXeJ60tz1zfq04Y3+LZD5eyqc8h3BIdRQstQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/105] um: virtio_uml: Fix use-after-free after put_device in probe
Date: Mon, 22 Sep 2025 21:28:52 +0200
Message-ID: <20250922192409.145888296@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2b6e701776b6b..e2cba5117fd25 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -1231,10 +1231,12 @@ static int virtio_uml_probe(struct platform_device *pdev)
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



