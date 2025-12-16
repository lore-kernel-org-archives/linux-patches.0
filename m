Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F66361DD8;
	Tue, 16 Dec 2025 12:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888215; cv=none; b=PTPAxg7pKfvCp32ZLv+j7CcXgbHXaEg3Ix8JpEBmh7hyGPHnQadxjKATojjiJfQW7iWUlTdLX9St1ZPsiOiGWP8qaNSU5FPwvRIXxMZt7YkUwn6r5nhKv+CTfZz5TUEEzG+RUWuRxGYC9sDDC/PJRZ+xqV8jcIDsAV9R5SwPWQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888215; c=relaxed/simple;
	bh=nBGjGo8Hjn137JZGYVI71r/2rVXmHLUVOaqQ4zWAGM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVhmxkqPNg4bVS6u7M4TeR4sx+4BMmf3jh92XSP1gickbSX8lNawCgIlW0GK+IQimReZ08rTPoWU/S6w0fQ/vp6vqyen7UclaMKFMolDIZaIZ+ENgn6V7jNDoTBRslFL+7Kp58rO9lsf0J035nR51ranh/8MUxxfg07witM4p/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/usxdVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/usxdVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8A9C4CEF5;
	Tue, 16 Dec 2025 12:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888214;
	bh=nBGjGo8Hjn137JZGYVI71r/2rVXmHLUVOaqQ4zWAGM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/usxdVkJlQnrXqVI06fDJq4YrOLe+2oUnm6VLSfheXA/89jp+3uwm3E6CRPwyOEf
	 c8rsnrSvwRqp9lSPSRILitccF7FNHp8f/s1wivuehZcJVF8+eSqDSQ1Qw0GoAdBvJm
	 XY7cHcjqhB2fvygpnXGUHEjoX7jJ1GFq55cUESX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jason Wang <jasowang@redhat.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 467/614] vdpa/mlx5: Fix incorrect error code reporting in query_virtqueues
Date: Tue, 16 Dec 2025 12:13:54 +0100
Message-ID: <20251216111418.291484056@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit f0ea2e91093ac979d07ebd033e0f45869b1d2608 ]

When query_virtqueues() fails, the error log prints the variable err
instead of cmd->err. Since err may still be zero at this point, the
log message can misleadingly report a success value 0 even though the
command actually failed.

Even worse, once err is set to the first failure, subsequent logs
print that same stale value. This makes the error reporting appear
one step behind the actual failing queue index, which is confusing
and misleading.

Fix the log to report cmd->err, which reflects the real failure code
returned by the firmware.

Fixes: 1fcdf43ea69e ("vdpa/mlx5: Use async API for vq query command")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20250929134258.80956-1-alok.a.tiwari@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index a7936bd1aabe1..ddaa1366704bb 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1256,7 +1256,7 @@ static int query_virtqueues(struct mlx5_vdpa_net *ndev,
 		int vq_idx = start_vq + i;
 
 		if (cmd->err) {
-			mlx5_vdpa_err(mvdev, "query vq %d failed, err: %d\n", vq_idx, err);
+			mlx5_vdpa_err(mvdev, "query vq %d failed, err: %d\n", vq_idx, cmd->err);
 			if (!err)
 				err = cmd->err;
 			continue;
-- 
2.51.0



