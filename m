Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D526117BEC0;
	Thu, 15 Aug 2024 14:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732526; cv=none; b=b1THP74oK5coUm5qSEhnIT9HJk2clNsraJlEHjoilXwezf4k7MVxBRVrvXAofIfXTVJ1ckW7RFt73CemEsq+HrobQ96HR5sVhVEt8fOcTjmxwZXNSbaUsOOYIce9K4BSPwpjD8/RV3Dt8t0gS4eoKj/25Vky6f6gbqNwYI4VVfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732526; c=relaxed/simple;
	bh=+7FmUXAD/PTkkDxGAXeBuWnXH1e37DeIbTddjrWgbHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZxt0qeuUXjVPnEDGROAO0zNBoJaA+Ou7CTvoMc9zCoTiGUv2E5zsh3c+mCrSQRJH73j0RaI8dFhofGEpBUkHlwueDutTZn1HAQlckX2otbWViGudWVDcJZRLsnSKSLYDoF7ti+9fpA31vERnQsx/x64wAwc4LGliCdAl2U66lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2PmwIKmi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2PmwIKmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57163C32786;
	Thu, 15 Aug 2024 14:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732526;
	bh=+7FmUXAD/PTkkDxGAXeBuWnXH1e37DeIbTddjrWgbHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2PmwIKmiaz03QzvxjPi1UBUAB+YsCOG2SECe1r4hEOzlb0WhbkeTKs7M09NzEDAoo
	 Uys+dZVQlW8h7g0s/giDgDYbd+WXGHUpobRXFIbogHokDROJ38exX44mszbEz4wcNa
	 DLCfzz1CkMA/MeEL5NCEHVBHhBIAnQ1wDkrIuEjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 206/352] lirc: rc_dev_get_from_fd(): fix file leak
Date: Thu, 15 Aug 2024 15:24:32 +0200
Message-ID: <20240815131927.241120158@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit bba1f6758a9ec90c1adac5dcf78f8a15f1bad65b ]

missing fdput() on a failure exit

Fixes: 6a9d552483d50 "media: rc: bpf attach/detach requires write permission" # v6.9
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/lirc_dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 14243ce03b46e..c59601487334c 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -840,8 +840,10 @@ struct rc_dev *rc_dev_get_from_fd(int fd, bool write)
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (write && !(f.file->f_mode & FMODE_WRITE))
+	if (write && !(f.file->f_mode & FMODE_WRITE)) {
+		fdput(f);
 		return ERR_PTR(-EPERM);
+	}
 
 	fh = f.file->private_data;
 	dev = fh->rc;
-- 
2.43.0



