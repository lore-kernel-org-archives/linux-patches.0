Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2347E110;
	Tue, 11 Mar 2025 15:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706202; cv=none; b=VUUsJpw6reaAWQMEF8x6nPNZ5oUK+saP7mYXC1dF1wOuUVtiBFyTc+8jXOxTLOadWw2XzZevgWRVsormsoNZycM6XvTa3/zDaZ1upooZCJd66KTKL564wcz66BgACcMTAp6rBdkDg7g8bNCiBmtZqa8CyIYd/GX+w3aOrCA7OvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706202; c=relaxed/simple;
	bh=BHuHcowgLtJNbHlGjIbna8/USrirFUwhQ/b9EbZFdVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMjGjXRrUTejLHcg7UkWLFcO5LVm9MpjwLnSYpHQsAhsqZQ61PfKTrBYFVe8SH+Qd95sPufLt8BSXc5mK1gOsj88TxHHoZUSh0yXAtfWA0iF2EMQqWjXmpvuRpha8zMP22aw3ZtEcfD7ln7k9nZq27O14GTkRYiwd/5V8xP58q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiNocJIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiNocJIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DB3C4CEE9;
	Tue, 11 Mar 2025 15:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706202;
	bh=BHuHcowgLtJNbHlGjIbna8/USrirFUwhQ/b9EbZFdVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HiNocJIpAQnXlky0XF97vNBHb8oskMP7thRP5TZTrsr1pJsIu7yPJ2/PHDZ7FvJp2
	 tznACW8IdhrAxpYAyib2gqXK7JrGtyVZ+pX+gy1/8yxEMrELYyBE/bJHHkTQ8Ji7WH
	 AdmzLuFJPj2M73dNhq6x2uugJds6xxBWNcVkweME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 297/328] caif_virtio: fix wrong pointer check in cfv_probe()
Date: Tue, 11 Mar 2025 16:01:07 +0100
Message-ID: <20250311145726.710220291@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>

[ Upstream commit a466fd7e9fafd975949e5945e2f70c33a94b1a70 ]

del_vqs() frees virtqueues, therefore cfv->vq_tx pointer should be checked
for NULL before calling it, not cfv->vdev. Also the current implementation
is redundant because the pointer cfv->vdev is dereferenced before it is
checked for NULL.

Fix this by checking cfv->vq_tx for NULL instead of cfv->vdev before
calling del_vqs().

Fixes: 0d2e1a2926b1 ("caif_virtio: Introduce caif over virtio")
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Link: https://patch.msgid.link/20250227184716.4715-1-v.shevtsov@mt-integration.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/caif/caif_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index 7f2c551e5d690..41c096c2af5bd 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -746,7 +746,7 @@ static int cfv_probe(struct virtio_device *vdev)
 
 	if (cfv->vr_rx)
 		vdev->vringh_config->del_vrhs(cfv->vdev);
-	if (cfv->vdev)
+	if (cfv->vq_tx)
 		vdev->config->del_vqs(cfv->vdev);
 	free_netdev(netdev);
 	return err;
-- 
2.39.5



