Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5833C3C1E;
	Tue, 16 Jun 2026 17:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632052; cv=none; b=oTmE8xBqXWBh2g/S9MOi/92YgTBP4wu2nYQEBbPihDAHvuVnT0yGOP/gmRCgo6khb+yd70gYIVS7rirzQkJHqkDpefKiCfPRuRZ8NWRn4zLeRlaVU0wf/GCRKW4qYrjMzPGribuN974Wzd5K2SJU2UP3YBqeDBIy7v2rgGBzkAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632052; c=relaxed/simple;
	bh=q0X6o+FnIXBn6LFAekxvP41fNk/58gQ3r5TyBxv6DX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjR1Pkuopg45HkFW1v7yni90tdm99cXm8RuipkFMOU3UbK1RMavpnGFZKLgiJWcm8Hsm1B1Jhe7EQsQuDI/ExetIPBckDp+2oTOx4VfX9JwSLB4SIOjJjLF+n40r5lncP1aO5TQ3OXIjicZhO9BDecB5h7AUQNRd8eCn9p/k+ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDa2T1nn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDa2T1nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A1E1F000E9;
	Tue, 16 Jun 2026 17:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632051;
	bh=bJwEV2k8Wkullli2am+AaDN9/MTtZtTwES+kIJ7rSYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yDa2T1nnlh1GL6sC6zDxho6ERBQOtCO7aCoWZ1AaWbwQaY9dxg8GhA4Wxz7KGEWTB
	 KeL1KBbnEmV+v2Iy265ikChzHM1oogGykvlHw7pRcLV7Lz0xUapM0tJlZev+PYDlOi
	 JmgVmn86C+LWR0Y23t+zrlnkq04vencyTkhoRg38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Md Haris Iqbal <haris.iqbal@linux.dev>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 304/522] net/mlx5: Reorder completion before putting command entry in cmd_work_handler
Date: Tue, 16 Jun 2026 20:27:31 +0530
Message-ID: <20260616145140.108962155@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -986,12 +986,13 @@ static void cmd_work_handler(struct work
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
@@ -1001,13 +1002,14 @@ static void cmd_work_handler(struct work
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


