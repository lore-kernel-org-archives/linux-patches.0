Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C70B3F12D3;
	Mon, 17 Aug 2026 13:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974618; cv=none; b=nMuylid0HJbhrOtXrAnjIFpyZzCUNFxAEjWUNEeEoF91F5zcNpNI+Vyu/KRKp2C4FhcOv/2siv8GKwXxvEbXObyaLGycgk9NHtM4kwXEnnj+lyEpAmSjAkmFDnZViY4l3IvcN+NbL6NuySTqxJl1aWRrjozSCuD4u/R6+TuR0yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974618; c=relaxed/simple;
	bh=5MF/QRmjxbqjkrFOZ8DGYglSbmuv1BLvOW7pJh85iaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSZNfnndIJ9ZmXQh9JP32eJ7c1fEGLrqx7yTEZ73rgoq4xSnzGNBBDBJQFQvaMpXu7kjobUnM5CAVD9G/8wpvtVdFjV0gYFMxbLYUfKvUekTimsLwQaoZqNjKkuLUtMhjCZ01x4Om4SY7R2XlEXD25nD9nIhnM91stjFu2JwuxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Syd6A++w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Syd6A++w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176E01F000E9;
	Mon, 17 Aug 2026 13:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974611;
	bh=hA4JItOGb5Kmc6nZHoOAQmnEAQoS+ZcAs6UXhvp8rHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Syd6A++wDwDxc7JIgUrwk0cJXVyLoFgQo8smoSy+6Bt5FRecIFKiIp8yBk1Cz5ZMc
	 uSNTbj0bMGPXFsgtf+0oy60B3xJP7gpWNi7uVZ3iyVDc880Xzo0fk09CYEID73CwAg
	 AjnAQB0rgCWvrP01Z9NSKA1ojP3x/TUbQSYHFDlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.1 266/271] scsi: scsi_debug: Negate wrapped memcmp() result
Date: Mon, 17 Aug 2026 15:33:11 +0200
Message-ID: <20260817132547.659181900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit c4f6916a99cf105c3ff340b6210fcbba3fa66b35 upstream.

comp_write_worker() returns true when the compared data matches.
memcmp() returns zero for equal data and non-zero for different data, so
its result must be negated before it is stored in a bool.

The first segment already uses !memcmp(), but the wrapped segment uses
memcmp() directly, reversing the match result. Use !memcmp() there as
well.

Fixes: 38d5c8336e60 ("scsi_debug: add Report supported opcodes+tmfs; Compare and write")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/E5AD42E9C0E18633+20260803095328.3445311-1-raoxu@uniontech.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4318,8 +4318,8 @@ static bool comp_write_worker(struct sde
 	if (!res)
 		return res;
 	if (rest)
-		res = memcmp(fsp, arr + ((num - rest) * lb_size),
-			     rest * lb_size);
+		res = !memcmp(fsp, arr + ((num - rest) * lb_size),
+			      rest * lb_size);
 	if (!res)
 		return res;
 	if (compare_only)


