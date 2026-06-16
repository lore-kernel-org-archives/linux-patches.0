Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1AC1A6803;
	Tue, 16 Jun 2026 17:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629799; cv=none; b=ELYuif7v69N81WUQ12XPN3R1y03njKSd2Gq+hxZN38KXAEY94XWcO9JQbwAIrlO0QeiroBE1IbMfU2KEgL63Qp95GTOEO9OtgIxtjMTmlF4PiQnw3vCTPYnh1p8qWxo1bu0Hc/tUVth0mxyDa8K8ynPTvG6ZjcCKCOqvJwpWn2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629799; c=relaxed/simple;
	bh=lfyBDrVCB4sekq2iz044xATwWmU1/JBb2kjqH578MEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=em0S3xZ95wHzn1Ce/S2djGU9+4FPJ1GkhqfnWZ28Wkhq/sjNfNWAgOPyOKn/tGR5WnS++Oe9EFYn+zMazGyOsO6wXeD0dBTZtEZjaXZZJmRZLv3IX72nViWW6aKkdvdh6/d9Z0eGjWuY/7BfoDvUCY4h6bfA1IhXQHqlOUEHYZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeIoXz1L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeIoXz1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC721F000E9;
	Tue, 16 Jun 2026 17:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629797;
	bh=L9LV+TJVu4yiYkipv9+GpQaqf+Upsn6l32176YhYiok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BeIoXz1LAC9HeN4GQkReQSXlJ/S0sbNF/b4EZT5Et+qLocFl8BK4o3Qh3wTznhIH4
	 pXEx/On7he9OYhxYgzmH+IOXuIfuSwVAeRjZVuuXXzlEo2E0LZkrb7wMZ3kM0aTQ+V
	 wJl6tMqpPnbbpw2nJJkBG22ZZ6GnIiPr9EjppIhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Md Haris Iqbal <haris.iqbal@linux.dev>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 337/452] net/mlx5: Reorder completion before putting command entry in cmd_work_handler
Date: Tue, 16 Jun 2026 20:29:24 +0530
Message-ID: <20260616145135.029083358@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
@@ -989,12 +989,13 @@ static void cmd_work_handler(struct work
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
@@ -1004,13 +1005,14 @@ static void cmd_work_handler(struct work
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


