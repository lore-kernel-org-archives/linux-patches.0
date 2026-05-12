Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A416C34405B;
	Tue, 12 May 2026 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609401; cv=none; b=V97Hhe7/09syNZv/O/wPCFuEJdGZctBhMPn+GD8dZB+6RtDiKuWwtCnVzN2TkjRNeTr0G6FodQqdmvlZrMG6/+zF2/YpTbT8cvIqCexAdSGrcmSa4hyMem5pY+GkRh4jaPhqPslz5D0Bpb+Z92QHrrSPumG87fmxhciLyZNTCWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609401; c=relaxed/simple;
	bh=G854uHYYAYF+pHInoGbECKPQD6ydTkjzb9NRiDMjz9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McbA5jNsncwjX8v/BIeHP1MTfURgHAjgCA+X63OuOGNP8xwi9LSHZDUHLom/NvnVUY1JGbnsBl7F0/ZxBigIOjEUtQAiIE9G1du40rdZmOorUC8lyUltQo9VyzHw8cN2XjG9P7Xl5FfhFtAgCPJLjlxc8C9nVp7E2pWYUA1mzsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCtHsv2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCtHsv2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7C6C2BCB0;
	Tue, 12 May 2026 18:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609401;
	bh=G854uHYYAYF+pHInoGbECKPQD6ydTkjzb9NRiDMjz9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCtHsv2vTrjQ46wkKwzBh5z9tdplYtDkm0F0TlaEc/PTBKzIFgSrTlbAZF91SKOCu
	 8+BbN4d0jvNEN6oVkL37PwVj2K+qbBBryGe25CuFw+fE0WnOYnBONya8RVg7fvWnkG
	 1JhuVr69kxeGUU7uq5Tw+4TEdflr1FzTt6ylLniE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 7.0 181/307] dm: dont report warning when doing deferred remove
Date: Tue, 12 May 2026 19:39:36 +0200
Message-ID: <20260512173943.936866236@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit b7cce3e2cca9cd78418f3c3784474b778e7996fe upstream.

If dm_hash_remove_all was called from dm_deferred_remove, it would write
a warning "remove_all left %d open device(s)" if there are some other
devices active.

The warning is bogus, so let's disable it in this case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 2c140a246dc0 ("dm: allow remove to be deferred")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -384,7 +384,7 @@ retry:
 
 	up_write(&_hash_lock);
 
-	if (dev_skipped)
+	if (dev_skipped && !only_deferred)
 		DMWARN("remove_all left %d open device(s)", dev_skipped);
 }
 


