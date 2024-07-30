Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75DD17D8BB;
	Tue, 30 Jul 2024 16:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358779; cv=none; b=YT0r7vjgC4BWUCxIJnjh/YqoKe9iUgDiuqnaZHyS8J7QEI+JlFCDMt/eZDGzNgENVKKbRWt5npubVBlhiuoskantLZhfDF6iVP6qGHaNiV1hMtzbzvmKsyVO7SGGNjKRXgGjtVDGvDp+VIsYdxJKQI9THpn9Tc1PSqic++1jeC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358779; c=relaxed/simple;
	bh=iuL6HEedJ9TRsfjzDhDCF59ItMF5NelpbvEZvcYbGKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MftW1GzHNN/qg5u4gNbM+MlfLxD1d7n97Ii8Cpc7tUTigo5O/2mH9DK7JPTijm6p8LtGRl3h9pUSi4p2fl9xXKNAO1p4cyef6kw/IYBf8tkqsU1ayJNbsQnC90Bz7zbvEcKedlcQh5FIcr+6eYGDO4TlpEtrIh5licnwQtUDx2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Od5qPCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Od5qPCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF03C32782;
	Tue, 30 Jul 2024 16:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358779;
	bh=iuL6HEedJ9TRsfjzDhDCF59ItMF5NelpbvEZvcYbGKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Od5qPCkTdtFpMERIGAfrHn/QkfpMRM/seDafT+VomA0viE69MuXwYnzZC4tYHNKz
	 zBEcA3mxTxSm2jkfxbZs9KdZ54qoFFgI3PpIUPwNQ/UqwgIHpXzKRlPSipNSJtn9Y9
	 elxRxMb65rvz8AWaen92KO2Jxjnl9k6uckQYVeyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 421/440] lirc: rc_dev_get_from_fd(): fix file leak
Date: Tue, 30 Jul 2024 17:50:54 +0200
Message-ID: <20240730151632.228259940@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index adb8c794a2d7b..d9a9017b96eaa 100644
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



