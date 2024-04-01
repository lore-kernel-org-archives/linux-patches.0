Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F292EB0B;
	Mon,  1 Apr 2024 16:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990611; cv=none; b=TPV0ZkfhFN4ARKoCwpq4VmA7gdmMkC05uoQUJcHvuXvDjLubqv6C3NyCO9S6IgHGyOgFGJ7TaNiK48QUz1Srp+4YInDTMFXhmBZIE26T3Wi7Iyst4RCVDkKPVxoz8mrUAMLnA+aPOHTyeXl/AkAfFZzT++a1dbhg6/MB4KINutM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990611; c=relaxed/simple;
	bh=xTIjC541EgTtDHOGNGOTDEuMJ/rQuZaYHE6LsQKy4lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvi6oJlZWrixvXNOKMh0cuWbAMrrTNrcPnR9SIA7oSr1BdkEQt14zpS9jbwvuQCAYP7QuZeCqVhU5hCAxZ42ify1y5r3wYctQXjCnsx00vJSoUW5/aVHQwjpv/dxZdPQw7HQcVhGym3nvuV83Ql9BPnToR4y5B590tIlcbEzJiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXqJekMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXqJekMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D22C433C7;
	Mon,  1 Apr 2024 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990611;
	bh=xTIjC541EgTtDHOGNGOTDEuMJ/rQuZaYHE6LsQKy4lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXqJekMwa5ViIMSxN49dT0mEQobtvRQwru/qadm1YUzOYDejPgb8gaRGidYhHglvm
	 QXkXNO8is4DxjibxULbMzY/Zo447xFQatWuZ9s4bM32JVXT8JshQrYuXV6S+zZPgtd
	 OU+Ebke7em41IOYmqliDFPwSgV8UvptfWDeluRpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/272] remoteproc: virtio: Fix wdg cannot recovery remote processor
Date: Mon,  1 Apr 2024 17:43:22 +0200
Message-ID: <20240401152530.678005556@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Joakim Zhang <joakim.zhang@cixtech.com>

[ Upstream commit b327c72753d6a78de37aed6c35756f2ef62897ee ]

Recovery remote processor failed when wdg irq received:
[    0.842574] remoteproc remoteproc0: crash detected in cix-dsp-rproc: type watchdog
[    0.842750] remoteproc remoteproc0: handling crash #1 in cix-dsp-rproc
[    0.842824] remoteproc remoteproc0: recovering cix-dsp-rproc
[    0.843342] remoteproc remoteproc0: stopped remote processor cix-dsp-rproc
[    0.847901] rproc-virtio rproc-virtio.0.auto: Failed to associate buffer
[    0.847979] remoteproc remoteproc0: failed to probe subdevices for cix-dsp-rproc: -16

The reason is that dma coherent mem would not be released when
recovering the remote processor, due to rproc_virtio_remove()
would not be called, where the mem released. It will fail when
it try to allocate and associate buffer again.

Releasing reserved memory from rproc_virtio_dev_release(), instead of
rproc_virtio_remove().

Fixes: 1d7b61c06dc3 ("remoteproc: virtio: Create platform device for the remoteproc_virtio")
Signed-off-by: Joakim Zhang <joakim.zhang@cixtech.com>
Acked-by: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231217053659.3245745-1-joakim.zhang@cixtech.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_virtio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 0e95525c11581..ab5e4f02ab225 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -351,6 +351,9 @@ static void rproc_virtio_dev_release(struct device *dev)
 
 	kfree(vdev);
 
+	of_reserved_mem_device_release(&rvdev->pdev->dev);
+	dma_release_coherent_memory(&rvdev->pdev->dev);
+
 	put_device(&rvdev->pdev->dev);
 }
 
@@ -584,9 +587,6 @@ static int rproc_virtio_remove(struct platform_device *pdev)
 	rproc_remove_subdev(rproc, &rvdev->subdev);
 	rproc_remove_rvdev(rvdev);
 
-	of_reserved_mem_device_release(&pdev->dev);
-	dma_release_coherent_memory(&pdev->dev);
-
 	put_device(&rproc->dev);
 
 	return 0;
-- 
2.43.0



