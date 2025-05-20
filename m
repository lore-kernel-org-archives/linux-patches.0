Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF477242D9A;
	Tue, 20 May 2025 14:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750811; cv=none; b=JQNMnleK0dETiifdYVab3/defxp1g8pynE31xrYJLjhls602pFAgQ2Sx+W4U+PZY+n1kRP98/tle+IVmBE47D6GUzQhnEM+lIJP/YDVcpteo+BVEqUY/lnLPaVEY2DmWfE7oVERkNj7RsnqIKIdBd5z6UkkYOfvt35Do4KS7ZAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750811; c=relaxed/simple;
	bh=gyR0w+iubeZT+nTzpjAnAKBn+utI2cLX+w9a3MNrtNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJTZjqiWccRmLVK0QD7tjGznR4v3Q54je/aiiyDhZiG4X2MEV1Wjs1UG/mtPrrayybXUG6Js4aO7CbfkcLC4BKndzOQE/glOo1ZKvO/MhAXM47+Ktu+LJ7J0gQjQrhE5J0i3ct8SFL4qpowSnuKuMe6njBgi3AnCSdXEM3h9ZQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geBQRctZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geBQRctZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2DFC4CEE9;
	Tue, 20 May 2025 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750811;
	bh=gyR0w+iubeZT+nTzpjAnAKBn+utI2cLX+w9a3MNrtNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geBQRctZw5PUqx6ru11RKU4Ycm89uXWNFSyYSqkdBu/iNWvTndGXPGSjHjmXgVBQC
	 oqp7r468R21OuZI8/ASXV95rPogDpMOIkim6oMVWgMuNU2PiIqyTHmhuvdaeLLjzsy
	 gqLDA/3yJmKTBRzwcHBLLYSi+eiDxv/ENpfFmqeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.14 128/145] dmaengine: idxd: fix memory leak in error handling path of idxd_setup_engines
Date: Tue, 20 May 2025 15:51:38 +0200
Message-ID: <20250520125815.558925399@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 817bced19d1dbdd0b473580d026dc0983e30e17b upstream.

Memory allocated for engines is not freed if an error occurs during
idxd_setup_engines(). To fix it, free the allocated memory in the
reverse order of allocation before exiting the function in case of an
error.

Fixes: 75b911309060 ("dmaengine: idxd: fix engine conf_dev lifetime")
Cc: stable@vger.kernel.org
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Link: https://lore.kernel.org/r/20250404120217.48772-3-xueshuai@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -275,6 +275,7 @@ static int idxd_setup_engines(struct idx
 		rc = dev_set_name(conf_dev, "engine%d.%d", idxd->id, engine->id);
 		if (rc < 0) {
 			put_device(conf_dev);
+			kfree(engine);
 			goto err;
 		}
 
@@ -288,7 +289,10 @@ static int idxd_setup_engines(struct idx
 		engine = idxd->engines[i];
 		conf_dev = engine_confdev(engine);
 		put_device(conf_dev);
+		kfree(engine);
 	}
+	kfree(idxd->engines);
+
 	return rc;
 }
 


