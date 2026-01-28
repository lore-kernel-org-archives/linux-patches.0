Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0C723EAB7;
	Wed, 28 Jan 2026 15:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614296; cv=none; b=D+0ldyhGiVBFSMUc1AA27skz0TRc1eu9dzzzoFuwLoQXXOpeWue22+3N17DXK5TYrYEYUxDaOStgNXGgbFPaw+g6wZgO9GWRgNYCui+tQN8qGyo3RM6TmRhm8XiCKpfBmCyhWqP7iM69tIVZR2Bzuw0dly/FlhlynDf9MqKeyRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614296; c=relaxed/simple;
	bh=amKYw3QpffiPMJ5mdy8dtv6E91vLuHRVn7X7PtNuCbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1QJsgdKtbwalC0tE1jXv63tgxMvW82IgCrS2HD2N+lGRBlzAQs2xNzokoTh07wGJ4qRK7hfqfJTBGJS2SIptxqhv92r9tlnEbLqtBUhNx6H7AJJH7OryRVCKKGKEPSLDYoKWEo8Unermv05TcFv827vp0j4KfNKxSjy1a8p5+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gW5eDavs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gW5eDavs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E6FC4CEF1;
	Wed, 28 Jan 2026 15:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614296;
	bh=amKYw3QpffiPMJ5mdy8dtv6E91vLuHRVn7X7PtNuCbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gW5eDavsDgPgU14T+LCHbgIRiVi133oW5YCOs3278gOBmo4fpd2KRprxgjMLxo/4U
	 obtkFF0vLMqEbQFS4/xtx1ioEw3GgnqTpVnVtvBceB2ijTBjWQzcIAxfJFdIAMRNSK
	 knr/aegyirANFwFdUENykfu9dgRfoEqzsS6edsn8=
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
Subject: [PATCH 6.6 093/254] posix-clock: Store file pointer in struct posix_clock_context
Date: Wed, 28 Jan 2026 16:21:09 +0100
Message-ID: <20260128145348.174456760@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



