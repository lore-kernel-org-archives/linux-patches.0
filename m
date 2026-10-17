Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C99C385D7B;
	Sat, 17 Oct 2026 17:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258867; cv=none; b=uKqcxGH46j8jmoCXhdliYCKMB31T33NHLBl3OyJyQqzj9tuCFFgv+vQGhXuf3Spo/7dRIX/vdvIJ534hmo21YlHNXRj93q1790O4yHLaNhLSj/zuSHN9fguhG6xQ7vUS43ZMO5iXnA3Qe2TDvQrqmwsq5T8WIivjN7VYuKl7zLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258867; c=relaxed/simple;
	bh=tMW1F+sFLZxksCo1x41bqRm4r69KPqXmY1EFDhxM90Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtSN0N928hVHYymlXCdd8mU+xm8hvtyI+OBmCPsIhfqnaOeRRc7M48m+PBqJtkeHMu5RqscD9iRIHbKFSW6LmE3kOmIddZ9sQwbBz/KrT7SJ6qnZ4S20CnuTnW11eQxjjcauc33fmyGkFThIqoGgXg7+EjbBZESYvizZfNd6hUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLNs76a6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLNs76a6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0FF1F000C4;
	Sat, 17 Oct 2026 17:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258866;
	bh=UHKbSyCaNbTwITcuo+Dity6MnnoLU6nyhEUsumOspd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLNs76a6guZlR7W8JEICV3CLvLTLWyw2gsjMCA1wtAWSizMlZOVQiUwuBH2Qtd5Rk
	 t1spURGNhK6TsbHh/jkCXwTXWRy2KlqByTiBzplJCQtNwaanFd1sog9KVI47MR+4Xl
	 pMuDdaZxMTa6oio/LiP3puP2Wy+sVzXUW2mXimT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1026/1674] net: mana: Guard mana_remove against double invocation
Date: Sat, 17 Oct 2026 17:54:58 +0200
Message-ID: <20261017160457.469673185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit 50271d7ec95144d26808025b508f463780517d3c ]

If PM resume fails (e.g., mana_attach() returns an error), mana_probe()
calls mana_remove(), which tears down the device and sets
gd->gdma_context = NULL and gd->driver_data = NULL.

However, a failed resume callback does not automatically unbind the
driver. When the device is eventually unbound, mana_remove() is invoked
a second time. Without a NULL check, it dereferences gc->dev with
gc == NULL, causing a kernel panic.

Add an early return if gdma_context or driver_data is NULL so the second
invocation is harmless. Move the dev = gc->dev assignment after the
guard so it cannot dereference NULL.

Fixes: 635096a86edb ("net: mana: Support hibernation and kexec")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Link: https://patch.msgid.link/20260420124741.1056179-4-ernis@linux.microsoft.com
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 5ec3396200384..d4a37341534d1 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2921,11 +2921,16 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 {
 	struct gdma_context *gc = gd->gdma_context;
 	struct mana_context *ac = gd->driver_data;
-	struct device *dev = gc->dev;
+	struct device *dev;
 	struct net_device *ndev;
 	int err;
 	int i;
 
+	if (!gc || !ac)
+		return;
+
+	dev = gc->dev;
+
 	/* adev currently doesn't support suspending, always remove it */
 	if (gd->adev)
 		remove_adev(gd);
-- 
2.53.0



