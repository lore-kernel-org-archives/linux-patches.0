Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6371F330B30;
	Fri, 17 Oct 2025 15:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715324; cv=none; b=L1pJE2hFf6DbGjrFYHE3kDYdAnzZ2oQRLXeyYXTikSulqNQrl+0rLM0w8sEdhruRFl5IfHAEQSoC5UbMGZWA2pOoNwhR0EFaGVXebIpV/DXsRRsTDxoFIMTw+3v7Y5e8nYEb6o/3BfFp/5EosgLd1uDmPBJ3BktBqHFh2BnZ3A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715324; c=relaxed/simple;
	bh=JWwjR8Ci+jXCJ++AKXmiqhfhz1ligFl5w/Qbf7l0KYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYfOVFqjz285OvVn5qzEFf/EcMwZ6+WnX20uv2iF1om2ZQ7PjzDXi0h9hr8iNmS2QwKZNwRgGrNDxt6FSWZzpLP515zqiahkkcMNh8t2UzS6dGyhQhgl1QHgmLORN83t4lzd89SY4uvEzPF0YiC2PUU5tw0Zzah9W3jQEUW32IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyxaAX+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyxaAX+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16E8C4CEE7;
	Fri, 17 Oct 2025 15:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715324;
	bh=JWwjR8Ci+jXCJ++AKXmiqhfhz1ligFl5w/Qbf7l0KYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyxaAX+1sgdoWCXQ9/tSuk1xqchdPp2JCAwLZNE3r7vtaDmIldTNYjBUZq5+GkPx1
	 06lxw/fI5XdkYycXgdffbcnZ/c0dscF0FsXn9lunOui/3GxNRGw6O3lwpoNVkz5hPn
	 Sx0VTOjYpcg8Bo18dyVQiOGL9AdXX1b6uR27WH/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.17 177/371] media: staging/ipu7: fix isys device runtime PM usage in firmware closing
Date: Fri, 17 Oct 2025 16:52:32 +0200
Message-ID: <20251017145208.332485353@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bingbu Cao <bingbu.cao@intel.com>

commit 895d3b4b5832edefd2f1fbad9d75c0179f47fe0e upstream.

The PM usage counter of isys was bumped up when start camera stream
(opening firmware) but it was not dropped after stream stop(closing
firmware), it forbids system fail to suspend due to the wrong PM state
of ISYS. This patch drop the PM usage counter in firmware close to fix
it.

Cc: Stable@vger.kernel.org
Fixes: a516d36bdc3d ("media: staging/ipu7: add IPU7 input system device driver")
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/ipu7/ipu7-isys-video.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/media/ipu7/ipu7-isys-video.c
+++ b/drivers/staging/media/ipu7/ipu7-isys-video.c
@@ -946,6 +946,7 @@ void ipu7_isys_fw_close(struct ipu7_isys
 		ipu7_fw_isys_close(isys);
 
 	mutex_unlock(&isys->mutex);
+	pm_runtime_put(&isys->adev->auxdev.dev);
 }
 
 int ipu7_isys_setup_video(struct ipu7_isys_video *av,


