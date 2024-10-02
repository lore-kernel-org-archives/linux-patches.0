Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB831D04B4;
	Wed,  2 Oct 2024 13:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877065; cv=none; b=oYbsGPI3iW857R0DluUohwbwAFOUVNUb5vM62EcRLTn3c34aOQNcYMmmJCtpXTdRNIaGM/tXSTpylVoLVcnWvfOlK3EmAcm7JAmEKZu6xSKBBzAlZHopY3lLvqFZXFEMDc+HPWn2mRgTBqqz2W44cILvNX2NvVHERAa1syo82Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877065; c=relaxed/simple;
	bh=IIiY1fneqRkwvbNqRO8oODhUYkT5v+oRQhqAdz4hiKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBnsLHeCy6M9d1DLX1etVzXE8m36YXdgYMRrX05vuKvToj52irwnwZroIC8Y74E36kPyKj+8piedGU8lZQWjreBGGzDEAAyc+axWz+7Q6SlYScXG/uvwcFHJWQkm9it3Z9T12ReLiANKboAL5jJW5EYZCRoRoIHGvApNDUPXTLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdhDVN5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdhDVN5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD42C4CEC2;
	Wed,  2 Oct 2024 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877065;
	bh=IIiY1fneqRkwvbNqRO8oODhUYkT5v+oRQhqAdz4hiKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdhDVN5Ju3cIeUSXgSU+vVf1mhpetCpCUPWFk2AuwaXyIgyVI2/hTvrEj05WTtrz7
	 9c9C0Y7qj5Ro0vZaynTkcgpB5+gmy1ZkNgomafCMryzofQeVkgXra86rexJO6L5iyx
	 k7+IhIF3+VCI5H6FfYvToao3DpraR+1GrSsm/HUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.11 652/695] md: Dont flush sync_work in md_write_start()
Date: Wed,  2 Oct 2024 15:00:50 +0200
Message-ID: <20241002125848.536831252@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 86ad4cda79e0dade87d4bb0d32e1fe541d4a63e8 upstream.

Because flush sync_work may trigger mddev_suspend() if there are spares,
and this should never be done in IO path because mddev_suspend() is used
to wait for IO.

This problem is found by code review.

Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need reconfiguration")
Cc: stable@vger.kernel.org
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240801124746.242558-1-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8668,7 +8668,6 @@ void md_write_start(struct mddev *mddev,
 	BUG_ON(mddev->ro == MD_RDONLY);
 	if (mddev->ro == MD_AUTO_READ) {
 		/* need to switch to read/write */
-		flush_work(&mddev->sync_work);
 		mddev->ro = MD_RDWR;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);


