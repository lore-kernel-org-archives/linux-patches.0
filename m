Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A48147798F;
	Tue, 16 Jun 2026 16:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627726; cv=none; b=itK+eYJWIqsYSJxVJtvSj8Ws+69Larz9KO9DDoo3JygeCojIRYTtI1vo8kGkq4JBJ2ZBwbEFcQynyLt5HS9GV2AUbYqCvemiim3zoasdPgjw3JlDTNKFJGQoPaozhFsWkxPE9OZuy9wRv5uqfW88d7L1vOWKGZ5mwjQetgD0iak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627726; c=relaxed/simple;
	bh=93gfqrv6zGnb5eRizuUnSVJoTYejEGWYUJEMdL2N/+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tq9PmJF5iBwQz4UWfMx7M1fW/w8lsDen8l1ibGbipBpAfVoRa1+FcQ4WXdiMvVKtc3cVWtdvNGwrX2mcJPiUsit3valCMkU7HzByIaIOHNiWnsZ8dkogRMMO9ozPder0ExB1BPEAiAqYLOO4nsJ2zmgasWObr6l7sc53J4hB7Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtBzdKeB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtBzdKeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501ED1F000E9;
	Tue, 16 Jun 2026 16:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627725;
	bh=7/eMxMzP71CW0NQJltLSK9GEW0/KFTmmeiBbWAHx+h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QtBzdKeBNygtY5GEDIgEymECkyMCaVcp9aYoloQLGKvxsELgfMiOOU1bPCxZY+RIi
	 yxGOUvXe89o/NLv2PrUcQOOZm+PQxVHzyMTNrPywJYw0rruVFIwNuTfVT20oZ3DK0t
	 s8Agtu5pGUDZfFGr3hdi3n61+dvan/PRAWX3K2Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Md Haris Iqbal <haris.iqbal@linux.dev>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 182/261] net/mlx5: Reorder completion before putting command entry in cmd_work_handler
Date: Tue, 16 Jun 2026 20:30:20 +0530
Message-ID: <20260616145053.503875900@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Nikolay Kuratov <kniv@yandex-team.ru>

commit 02896a7fa4cd3ec61d60ba30136841e4f04bdeac upstream.

Assuming callback != NULL && !page_queue, cmd_work_handler takes
command entry with refcnt == 1 from mlx5_cmd_invoke.
If either semaphore timeout or index allocation error happens,
it does final cmd_ent_put(ent). To avoid access to freed memory,
notify slotted completion before cmd_ent_put.

This is theoretical issue found by Svace static analyser.

Cc: stable@vger.kernel.org
Fixes: 485d65e135712 ("net/mlx5: Add a timeout to acquire the command queue semaphore")
Fixes: 0e2909c6bec90 ("net/mlx5: Fix variable not being completed when function returns")
Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>
Reviewed-by: Md Haris Iqbal <haris.iqbal@linux.dev>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260526162932.501584-1-kniv@yandex-team.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -996,12 +996,13 @@ static void cmd_work_handler(struct work
 				ent->callback(-EBUSY, ent->context);
 				mlx5_free_cmd_msg(dev, ent->out);
 				free_msg(dev, ent->in);
+				complete(&ent->slotted);
 				cmd_ent_put(ent);
 			} else {
 				ent->ret = -EBUSY;
 				complete(&ent->done);
+				complete(&ent->slotted);
 			}
-			complete(&ent->slotted);
 			return;
 		}
 		alloc_ret = cmd_alloc_index(cmd, ent);
@@ -1011,13 +1012,14 @@ static void cmd_work_handler(struct work
 				ent->callback(-EAGAIN, ent->context);
 				mlx5_free_cmd_msg(dev, ent->out);
 				free_msg(dev, ent->in);
+				complete(&ent->slotted);
 				cmd_ent_put(ent);
 			} else {
 				ent->ret = -EAGAIN;
 				complete(&ent->done);
+				complete(&ent->slotted);
 			}
 			up(&cmd->vars.sem);
-			complete(&ent->slotted);
 			return;
 		}
 	} else {


