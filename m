Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962654718E5;
	Sat, 12 Sep 2026 11:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211761; cv=none; b=L1Wgp3ltIYAyNfxiePB21tHLeco3AeAIJOzZTNUTbcCTg/V/WM4Bg88s5kTg380IAVmhZp/BmGGYqW+RCwnx5C1mxb+XmQpYSwPIxpfiqt7wgwLCyXcE/MtCcW4QAZelw6mZ7BDrW96VUe4hpQ6wyzE31iEU+d0CJFxEO8tyvbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211761; c=relaxed/simple;
	bh=hjtyzdoGueu36f7kZORTiZHUl2DdI4gD59I67wDEzYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MHWsRyrax5XYYCaC17jLqZ4jI0dtjH0VFvfhariRS5Io3A6zyz5xxpLJhJ3ZSt5yHQN3p77ULhX+roDtq6JGYbnN38xY6CF6r5+ScY1dia/ukb+XrOMRxahEIoY4L7evV3EA4qXxDDri98M7cDXr8b0OAQCyOYcoaZEncH/ynYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxgJ0otJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxgJ0otJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBED1F00893;
	Sat, 12 Sep 2026 11:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211760;
	bh=QTg9FWWNPLGbOno/goJ77HLjhVLLwsgnMfcqOmSDIoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxgJ0otJGjjoUb+BOGvDsznQGCkYtg098mNIkzTJvt34y15fLcMC4vTHlrar1Am4t
	 eGE73Jx6ZOwJLjDK8M47FQnxzdUdOHBhNk9sTStNGZtdHxY7Uh687JKSZ1yZim/rHK
	 MSQp64IoncJKHTxTyOsCd8x2B6ck66neTOqLyn3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1298/1518] vdpa/mlx5: fix wrong list iterated in add_direct_chain error path
Date: Sat, 12 Sep 2026 08:57:47 +0200
Message-ID: <20260912065652.880082990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 23ae56d9e74c122f95cae71ae3b9fc259fb88446 ]

In add_direct_chain(), newly allocated direct MR entries are added to
the local list 'tmp', which is spliced into mr->head only on success.
On the error path, the cleanup loop was incorrectly iterating over
mr->head instead of tmp.

Fix by iterating over 'tmp' in the err_alloc cleanup path.

Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260701113608.1972-1-lirongqing@baidu.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/core/mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 2450440dae2e1..5ec01d6724815 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -482,7 +482,7 @@ static int add_direct_chain(struct mlx5_vdpa_dev *mvdev,
 	return 0;
 
 err_alloc:
-	list_for_each_entry_safe(dmr, n, &mr->head, list) {
+	list_for_each_entry_safe(dmr, n, &tmp, list) {
 		list_del_init(&dmr->list);
 		unmap_direct_mr(mvdev, dmr);
 		kfree(dmr);
-- 
2.53.0



