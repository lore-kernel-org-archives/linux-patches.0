Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D76130AAA6;
	Mon, 13 Oct 2025 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369459; cv=none; b=E85FE6W4Nz1tewcVHjjuioFHq5ZJH9Z53w31jyzn/vTz7YFcXuTQRVXjVCp14pgwmWs81dRvNcO77tpQqwGVtcVR99STXz6fj/mbwhI/jOX+RFkrT2nqir8acl5TH5uUmxsqXZKHmdsPwYBDCuIqNYkxHU5YEi93gZamCupX3K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369459; c=relaxed/simple;
	bh=Klsk9RR4RElSc+q+qiP/+JRZIKjgVLYZNUNTpY3RsUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkJBtwsO1O/3cFnAi6Hu074VVr6BNxesyVTkl/Y5yPFfOaf0RG0VXutjPBJVC3dgK7cTCdWRPWvFEuYwRT24h8lOuH5HrvqtEu3pbZnqdp2qmPwW6DxcJt6Z5qH4M8xryqGVAuV1k6l5T/MJ8yk6FHEudz9cWU5Yv/3ITK65QEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiqk6dSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiqk6dSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B32C4CEE7;
	Mon, 13 Oct 2025 15:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369458;
	bh=Klsk9RR4RElSc+q+qiP/+JRZIKjgVLYZNUNTpY3RsUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xiqk6dSw8Onj/p/D6Jn4+1qGQvOV50wMPhn+8SHD7KGOpDoA9/g28xepBGYVXxgnH
	 f1egYAVI+KvkPEPA7Dzz1Bx4RqHt/eXqoqX5TDwSpng1n8WaRShMwmd/yfgbchlLVI
	 dZjTa7Ty4wMTJmt3z0d2BL5dVe0sexe4d2iHIpZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 253/563] f2fs: fix to clear unusable_cap for checkpoint=enable
Date: Mon, 13 Oct 2025 16:41:54 +0200
Message-ID: <20251013144420.446577500@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 2e8f4c2b2bb12fc3d40762f1bb778e95c6ddbc93 ]

mount -t f2fs -o checkpoint=disable:10% /dev/vdb /mnt/f2fs/
mount -t f2fs -o remount,checkpoint=enable /dev/vdb /mnt/f2fs/

kernel log:
F2FS-fs (vdb): Adjust unusable cap for checkpoint=disable = 204440 / 10%

If we has assigned checkpoint=enable mount option, unusable_cap{,_perc}
parameters of checkpoint=disable should be reset, then calculation and
log print could be avoid in adjust_unusable_cap_perc().

Fixes: 1ae18f71cb52 ("f2fs: fix checkpoint=disable:%u%%")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index e16c4e2830c29..9f2ae3ac6078e 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -988,6 +988,10 @@ static int f2fs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			ctx_set_opt(ctx, F2FS_MOUNT_DISABLE_CHECKPOINT);
 			break;
 		case Opt_checkpoint_enable:
+			F2FS_CTX_INFO(ctx).unusable_cap_perc = 0;
+			ctx->spec_mask |= F2FS_SPEC_checkpoint_disable_cap_perc;
+			F2FS_CTX_INFO(ctx).unusable_cap = 0;
+			ctx->spec_mask |= F2FS_SPEC_checkpoint_disable_cap;
 			ctx_clear_opt(ctx, F2FS_MOUNT_DISABLE_CHECKPOINT);
 			break;
 		default:
-- 
2.51.0



