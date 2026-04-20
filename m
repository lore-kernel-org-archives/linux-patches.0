Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B440332E696;
	Mon, 20 Apr 2026 15:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700312; cv=none; b=BoeCR7x9o7YJcbvqDQyES1OcrTAGxP5uaiixR5NOZ4tfa+bvKHwewN2RtdAzZlo2he4xX5ncl2VZ72kkwzJXmYcAYNSEv4SwnoyxebodMFcubGaUbZsOTVe7bSInWhVCmddlX4IPxtyrv79Q/k8l96O+Z+TbcAAMdiisxETOf48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700312; c=relaxed/simple;
	bh=8rgzU5yaCIMrqgV646aWUqUJmSfh/MM72M2gRh456iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxY65vmudFirv1zjCINN2/d1q8bXOkYP6xUQ53W5nFXnrugANOofh9Obxzot8Lb0QBTN/wOOJHuxoQwT23ooFZKx5YHu/sGGh9zIei7OJGKxBDDAXVV7RjtWjkFR4u/ikvMM5+lLATdj90Zc/QaJRYJYqXM/tFeeEAH8ApVN7JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZmkm9xW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZmkm9xW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4AFC19425;
	Mon, 20 Apr 2026 15:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700312;
	bh=8rgzU5yaCIMrqgV646aWUqUJmSfh/MM72M2gRh456iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZmkm9xWR1zBB8NjOMox7ltHvhdtGmnDSd1qr9JqFFvibMDiGzhNqwaeCWob4SO0z
	 ZizboZXJD1y/KVAd5c8gmiAtjUVkaFlFLotUH3YEB10qLwhXUhrjPz0aRES491XPce
	 m2w+Slam0gZgP43u8c20vPzfHBSSEez87GuhawnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 106/220] vsock/test: fix send_buf()/recv_buf() EINTR handling
Date: Mon, 20 Apr 2026 17:40:47 +0200
Message-ID: <20260420153937.850458592@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 24ad7ff668896325591fa0b570f2cca6c55f136f ]

When send() or recv() returns -1 with errno == EINTR, the code skips
the break but still adds the return value to nwritten/nread, making it
decrease by 1. This leads to wrong buffer offsets and wrong bytes count.

Fix it by explicitly continuing the loop on EINTR, so the return value
is only added when it is positive.

Fixes: a8ed71a27ef5 ("vsock/test: add recv_buf() utility function")
Fixes: 12329bd51fdc ("vsock/test: add send_buf() utility function")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Link: https://patch.msgid.link/20260403093251.30662-1-sgarzare@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/vsock/util.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 9430ef5b8bc3e..1fe1338c79cd1 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -344,7 +344,9 @@ void send_buf(int fd, const void *buf, size_t len, int flags,
 		ret = send(fd, buf + nwritten, len - nwritten, flags);
 		timeout_check("send");
 
-		if (ret == 0 || (ret < 0 && errno != EINTR))
+		if (ret < 0 && errno == EINTR)
+			continue;
+		if (ret <= 0)
 			break;
 
 		nwritten += ret;
@@ -396,7 +398,9 @@ void recv_buf(int fd, void *buf, size_t len, int flags, ssize_t expected_ret)
 		ret = recv(fd, buf + nread, len - nread, flags);
 		timeout_check("recv");
 
-		if (ret == 0 || (ret < 0 && errno != EINTR))
+		if (ret < 0 && errno == EINTR)
+			continue;
+		if (ret <= 0)
 			break;
 
 		nread += ret;
-- 
2.53.0



