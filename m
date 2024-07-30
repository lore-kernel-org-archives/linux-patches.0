Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7631C1A76A7;
	Tue, 30 Jul 2024 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359856; cv=none; b=d2bRBLJ91PNSJq05ROXskBEniG55y3a1CI1Fksc8A4kdidBh//ivgBV7YWe0dTMO9lDxfG5Xfwa19RVaRx4trTw0gkbbzj1C5oUg406JpyVlXLNuGJqCtGA/11gDcSv4wyMoaoobWyrYy091Iw+kszJxuKfpuaByqIYlREH0oys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359856; c=relaxed/simple;
	bh=QZIZgJtC2q40qNDSSKFU+he35Q6cKp/dXYKLuSa3kzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luyVM0sYDpDWRT8XnvLz1mizejyPjZFGpunxKu1JzjncU51ECX9S+VQUuApj24X8CZAb6+mfVQA/yscRJ+svdeGdkfrix8MdVTnVAfGPNLFLF4YzBLPfjyYaVPvhKzVuLu9USOJm5sO8o09q8xDfYJv72j4mBUGBRN9hyi7f4KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciSNaLlD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciSNaLlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE18DC32782;
	Tue, 30 Jul 2024 17:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359856;
	bh=QZIZgJtC2q40qNDSSKFU+he35Q6cKp/dXYKLuSa3kzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciSNaLlD3hB7iUvx+oDK8DBEGysF33bIbWN4kkYtq65a0oFuZF4mZj3dGB7cVy0rm
	 nicB/MVXEKOzHhQHVpZWNxFudkacYox/sZuQuEnGAFs5WMRq/YsqxU9vx70tjzH49K
	 hH95mBc8BfjQDp/F7mE1Gglz4vUnBoGVGC3jEq3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 547/568] lirc: rc_dev_get_from_fd(): fix file leak
Date: Tue, 30 Jul 2024 17:50:54 +0200
Message-ID: <20240730151701.541006380@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index caad59f76793f..f8901d6fbe9bf 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -828,8 +828,10 @@ struct rc_dev *rc_dev_get_from_fd(int fd, bool write)
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



