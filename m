Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499541D86FF;
	Tue, 11 Nov 2025 01:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824707; cv=none; b=Sd+aTK01GA+ngzY8VTg728m1nY+a8LBJRgxj8v2zPZd7vRCLnkLTvA0mylh3V2BXmjO3j//GulaxbrBPvjU6inOrbNP41NHA7tKY+SkEQJrQvNxG9TOOhyaJnjaY1hCQ0ilcQLoAYP0YlfDfX0Zm7X8LjTzEwT+aQ26e2TIDXUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824707; c=relaxed/simple;
	bh=klSHM/jm5EcPVefNCW850AihEpDiIA1VlMH3bz7GNb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVmiczAANyd9bwID0wfeW54WmyaFMViaa+/+Dfx/Nu2nPm0tiRG7Es1Xor0CY1wWlWq+nv7FFHqEI5YpwkmkarjIFntjUdfBlW9o5F/rkoB+s4EyqtZ7hRaS/jo4ruCZizdybMhfug7nhSGDc3KZtZfgLZGlpdA9T5pVRlCmGE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtQ9JfFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtQ9JfFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8008C19422;
	Tue, 11 Nov 2025 01:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824707;
	bh=klSHM/jm5EcPVefNCW850AihEpDiIA1VlMH3bz7GNb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtQ9JfFgUn/R0jltPMHa2Yv9iJ7LFoFhX4wj1+r5JO9fU2gd83VgZUNni8GWzWdmQ
	 A5SDH16NL/lQNKdV74hnkCrg6AnJFQBZWQofh1gQF9bFjv84+v9pIpD6F9lWs8iTmU
	 ldMtQ5fFJVaMSmd0Z32/EOtYadF+jbcpHLwm5DzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <SJB7183@psu.edu>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 502/565] media: videobuf2: forbid remove_bufs when legacy fileio is active
Date: Tue, 11 Nov 2025 09:45:58 +0900
Message-ID: <20251111004538.236283810@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 27afd6e066cfd80ddbe22a4a11b99174ac89cced upstream.

vb2_ioctl_remove_bufs() call manipulates queue internal buffer list,
potentially overwriting some pointers used by the legacy fileio access
mode. Forbid that ioctl when fileio is active to protect internal queue
state between subsequent read/write calls.

CC: stable@vger.kernel.org
Fixes: a3293a85381e ("media: v4l2: Add REMOVE_BUFS ioctl")
Reported-by: Shuangpeng Bai <SJB7183@psu.edu>
Closes: https://lore.kernel.org/linux-media/5317B590-AAB4-4F17-8EA1-621965886D49@psu.edu/
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -1015,6 +1015,11 @@ int vb2_ioctl_remove_bufs(struct file *f
 	if (vb2_queue_is_busy(vdev->queue, file))
 		return -EBUSY;
 
+	if (vb2_fileio_is_active(vdev->queue)) {
+		dprintk(vdev->queue, 1, "file io in progress\n");
+		return -EBUSY;
+	}
+
 	return vb2_core_remove_bufs(vdev->queue, d->index, d->count);
 }
 EXPORT_SYMBOL_GPL(vb2_ioctl_remove_bufs);


