Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB62E2C21ED;
	Wed,  4 Feb 2026 15:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217664; cv=none; b=nq5IoPaYlzquMXanftyUDxOVVVm6vcLAj5JUbNnI5brpVNcI36gfQAT9PHkOY2fRJwy/zmjiSnT4Q/g8Zc9stTEk9EFpOY7fl8C0Na3iS0c9A0raABsL84mmkD7GQgJq1jvawQ4KZpBqcsBZ9DfDNMy/d+xsnKwOSalqgZJGZaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217664; c=relaxed/simple;
	bh=ExQPEfmxo033Y29hLiCtj4r39Z0c59SDL93nBJeDOpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGyEKP+cM7uz/+MtpWM4nayYLxOlFwIZLDCzczv/ACWsg3kVceKGFJNDPe+cSd/3JbHGWtGXqMmoINmeMBL3o8E8nzmsgEV2eBVUsVSxwBwwh2PCgoSQZROBqp23kVIbFYXn3xyRFqfnkJr2/RHtS45chCZztSiISPAiAtplKl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCoZ1VQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCoZ1VQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8A9C4CEF7;
	Wed,  4 Feb 2026 15:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217663;
	bh=ExQPEfmxo033Y29hLiCtj4r39Z0c59SDL93nBJeDOpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCoZ1VQkR63pKqGyN6ss+xxbWu3vNlBrUyxPMFrE2ewjQGPACvEPuRY2t3+lNmeBK
	 56z0G5j4DRkM7IpDQrr5tCSWTptXY4fCrdCidpNsJJVAeyjFE1yhIkeyWwvJ6Sl3Yz
	 H+jtpjp2wF/Q6Sy7JOMZOyZ8dxnixNHXKnagr1Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Thomas Gleixner <tglx@linutronix.de>,
	Wojtek Wasko <wwasko@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/280] posix-clock: Store file pointer in struct posix_clock_context
Date: Wed,  4 Feb 2026 15:37:35 +0100
Message-ID: <20260204143912.573688570@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wojtek Wasko <wwasko@nvidia.com>

[ Upstream commit e859d375d1694488015e6804bfeea527a0b25b9f ]

File descriptor based pc_clock_*() operations of dynamic posix clocks
have access to the file pointer and implement permission checks in the
generic code before invoking the relevant dynamic clock callback.

Character device operations (open, read, poll, ioctl) do not implement a
generic permission control and the dynamic clock callbacks have no
access to the file pointer to implement them.

Extend struct posix_clock_context with a struct file pointer and
initialize it in posix_clock_open(), so that all dynamic clock callbacks
can access it.

Acked-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Wojtek Wasko <wwasko@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/posix-clock.h | 6 +++++-
 kernel/time/posix-clock.c   | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/posix-clock.h b/include/linux/posix-clock.h
index ef8619f489203..a500d3160fe8c 100644
--- a/include/linux/posix-clock.h
+++ b/include/linux/posix-clock.h
@@ -95,10 +95,13 @@ struct posix_clock {
  * struct posix_clock_context - represents clock file operations context
  *
  * @clk:              Pointer to the clock
+ * @fp:               Pointer to the file used to open the clock
  * @private_clkdata:  Pointer to user data
  *
  * Drivers should use struct posix_clock_context during specific character
- * device file operation methods to access the posix clock.
+ * device file operation methods to access the posix clock. In particular,
+ * the file pointer can be used to verify correct access mode for ioctl()
+ * calls.
  *
  * Drivers can store a private data structure during the open operation
  * if they have specific information that is required in other file
@@ -106,6 +109,7 @@ struct posix_clock {
  */
 struct posix_clock_context {
 	struct posix_clock *clk;
+	struct file *fp;
 	void *private_clkdata;
 };
 
diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index a6487a9d60853..b130bb56cc4e0 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -129,6 +129,7 @@ static int posix_clock_open(struct inode *inode, struct file *fp)
 		goto out;
 	}
 	pccontext->clk = clk;
+	pccontext->fp = fp;
 	if (clk->ops.open) {
 		err = clk->ops.open(pccontext, fp->f_mode);
 		if (err) {
-- 
2.51.0



