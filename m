Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFCD21A420;
	Tue, 26 Aug 2025 13:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215590; cv=none; b=kP0LoCj9yLKjVHEic0uOZKhnSVHoVb0ruJMNT++GaV8VcjgILBSRqUiuNkE1Rb0qyWuZ/BNUs16URSnQvV3pOAirjOs3qNS5OE28oTwLuMau5C1uUHJ5eBHqhZG5s1sTr7iRnYGJWXfubhxRiA2SL9bgpx6uktUk5Ll/Adws+EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215590; c=relaxed/simple;
	bh=LKybsQZKx4EhQfeXtnPrStZq1nlTVYXgcqW33GyX4f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsUZxANnRmArt+8WOwnusCKRvqG5r8CjZAx6E4Z85TBbCZbpzXBQRnlNiUu1Z407Kz7yaWPcTAjWnC8O4XV9yDLhmDxr22zkxxlhW/rR1eADQfIkSnCZL/eD0pFIY4tjtn2c2Yxcx7SZ6tcnAvUriDF/s12d/d+OJMdZqrvihow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqHdLj2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqHdLj2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB13C4CEF1;
	Tue, 26 Aug 2025 13:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215590;
	bh=LKybsQZKx4EhQfeXtnPrStZq1nlTVYXgcqW33GyX4f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqHdLj2+VoAhjkDKJ7aKy4Ppf4K5KIBLFwmyWJhgsvHJDqQ1pQtrO4EgDyW5wAFhD
	 vCrb7WzOMEN9OTwb4Z3syVuD0B/AagKd9qZcZ9572MN6rYgPDdq+aPxuFpKVhMat8e
	 NADEamlRzlt86Na1wBaVBFMs3YHBV1hMyKZaviBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 090/644] i2c: virtio: Avoid hang by using interruptible completion wait
Date: Tue, 26 Aug 2025 13:03:01 +0200
Message-ID: <20250826110948.731085535@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -118,15 +118,16 @@ static int virtio_i2c_complete_reqs(stru
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


