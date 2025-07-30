Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A700293B5F;
	Wed, 30 Jul 2025 09:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869192; cv=none; b=SodhmB5ofMW/9CYfwlTWqG+V/2u2ju8W3kJJJw5sFQEUaw3MU9SzoeXG957BkiwpwxcVM8Z7vXFjGu1Og5u5BGpTNOAkn9geoz8Ra8HY9mUKKIXUVQy36Vj+3PN4QORwg/WiQkfTUMzXghi9ORExlqKtH7lbbb6ZiUOp6LMmqY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869192; c=relaxed/simple;
	bh=AAliCyxLB9K1ZWzG50HkJ59O92jpjCyl+UkZgc0XOms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0ixkyl25SQM3yGrRKAo4fW1o1v8z3MwkHvtBvFUOTMF434rwgP8BYIVun7sM1/yHQTR66QPkIrMJtW6IjjNBhpZ56iLNjIbh7LEs3/5dTP3jQ9hC9H2XUt3JlG0I3pkjjWt28pvQTM0t8+q9/Howj5IzkvsNny2KLauueKuLpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T93Yen1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T93Yen1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383FFC4CEF5;
	Wed, 30 Jul 2025 09:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869192;
	bh=AAliCyxLB9K1ZWzG50HkJ59O92jpjCyl+UkZgc0XOms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T93Yen1qFOa+yy4X2WIt1sf15aMt7CDovtGkFIXmv+/kZlAghl46bgKQ+v1hqFCI0
	 4AWilxcV8JrEzPx1N1rIQWYZvdTZEsKlMOxABIOVj8Jqtbt8cON4nRHYm9C/m5xgGQ
	 1FTKNyB3rlHTzV+xcowPUr8nmyxqTZdD6jWmh7c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.15 58/92] i2c: virtio: Avoid hang by using interruptible completion wait
Date: Wed, 30 Jul 2025 11:36:06 +0200
Message-ID: <20250730093232.996441104@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


