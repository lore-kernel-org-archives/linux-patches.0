Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBE336124;
	Wed, 30 Jul 2025 09:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868440; cv=none; b=VcK3K+SXHv7cf7sd0e2LH4f1b5RsSk+CiiC3QLsD6SW//QNno9fYnKQur6iaclFSh5EgyjR/WFUTKxMhoJw5AFokewL58Bx5RA+po8IDIo5bUmEKjzIU1I7VRMi0XPClloxqZcCLDz9r5AYSmdO0N9TpjQ8eb48HOSZyYTyXDeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868440; c=relaxed/simple;
	bh=nuZbxIZ/uGYNaoj+EMW8gDKSAZryP61W82N4Ajxb+tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScDYqLvg4/WWxRqMmE1ANR6WTpUsN+YXgw7mdfbFGIBY0TUysvI5yqZvOp2FFk2nZLmDRi7gwqhs61LUWvrAJIO61LyQMGG/xZ++8GOIrmhAleZNkTpDujEj0PiSs8x+FiXyN8IAYBcqAftUbBVusyYOLrOgG87vI4lJ1vdFlfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q50y6LdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q50y6LdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8050DC4CEF9;
	Wed, 30 Jul 2025 09:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868438;
	bh=nuZbxIZ/uGYNaoj+EMW8gDKSAZryP61W82N4Ajxb+tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q50y6LdHpETga4x7s3CHAxrftNxt06R2/GI94Xw2h3qRTZ42Ojz3hTA4cnpLVS3J9
	 M1tbIKns4qHOq56He59E8j1gFQ8Y9BBmMEw+oAYdPh4tASfiUzNygSDJXtM6qEYFcj
	 gkGasdrzgD6Og8l0p0MPxES4iGiGgWvD0qx7G/64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 31/76] i2c: virtio: Avoid hang by using interruptible completion wait
Date: Wed, 30 Jul 2025 11:35:24 +0200
Message-ID: <20250730093228.049161251@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Viresh Kumar <viresh.kumar@linaro.org>

commit a663b3c47ab10f66130818cf94eb59c971541c3f upstream.

The current implementation uses wait_for_completion(), which can cause
the caller to hang indefinitely if the transfer never completes.

Switch to wait_for_completion_interruptible() so that the operation can
be interrupted by signals.

Fixes: 84e1d0bf1d71 ("i2c: virtio: disable timeout handling")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: <stable@vger.kernel.org> # v5.16+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/b8944e9cab8eb959d888ae80add6f2a686159ba2.1751541962.git.viresh.kumar@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-virtio.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/i2c/busses/i2c-virtio.c
+++ b/drivers/i2c/busses/i2c-virtio.c
@@ -116,15 +116,16 @@ static int virtio_i2c_complete_reqs(stru
 	for (i = 0; i < num; i++) {
 		struct virtio_i2c_req *req = &reqs[i];
 
-		wait_for_completion(&req->completion);
-
-		if (!failed && req->in_hdr.status != VIRTIO_I2C_MSG_OK)
-			failed = true;
+		if (!failed) {
+			if (wait_for_completion_interruptible(&req->completion))
+				failed = true;
+			else if (req->in_hdr.status != VIRTIO_I2C_MSG_OK)
+				failed = true;
+			else
+				j++;
+		}
 
 		i2c_put_dma_safe_msg_buf(reqs[i].buf, &msgs[i], !failed);
-
-		if (!failed)
-			j++;
 	}
 
 	return j;


