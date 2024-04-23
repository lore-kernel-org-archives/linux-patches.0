Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA4D20B3E;
	Tue, 23 Apr 2024 21:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908546; cv=none; b=Ft4+Jdy4fmBTWJLy56GR+tzcD//amrEHyIuxeif2BOcW/Fc8Sge7YBB+pxqI2bmKGnJ7ZucEhQiftpfQq9dkuGh1qy0GIIW6OQN2IBUO5/fWRVOb5u3nIxCF555o3tHB6fvXPBCsLIHwEBXZuFBnMEDueJoXZ/FDhfmbpqwhR20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908546; c=relaxed/simple;
	bh=H+5Xx386DlhUpJgLTP5wzuoJNEfRyNk3xdC71yzMjQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SisXl//P9nWuMw8v9ScLirvVGzZU4Ef1K26TWVjuksaw6BORaQqj7QkvEsj+Bj3iUR7ZZVHxNO2XvpZS+lq4Nogbe9ZnC6YLaSCKlORdJT75tS7oeXllxTZK5S7WKI4DgLQLIf6GC6gLXvX8LHfiktlzOkQ/m0wKrX0dsVwQqJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5LNTsVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5LNTsVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A3FC116B1;
	Tue, 23 Apr 2024 21:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908546;
	bh=H+5Xx386DlhUpJgLTP5wzuoJNEfRyNk3xdC71yzMjQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5LNTsVfq3ABC8f4kH8Mosq1yMw7mosmXc+qlX4QyGroXnIE1N3+2uxlvuZdIjWWC
	 gY0U7GuAOhtJ36+v+zRz3UbjkginYmaptzj8xHciOD+pqu27ltlvFsQBxwkFQH36Ol
	 up+QxligEvZNeQ6wjEk5KZzgppV2ZAndOw7+ldrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6.8 116/158] Revert "mei: vsc: Call wake_up() in the threaded IRQ handler"
Date: Tue, 23 Apr 2024 14:38:58 -0700
Message-ID: <20240423213859.700888956@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit e3dc66d998d2b0c2734db9ca1d6c94c97349529a upstream.

This reverts commit 058a38acba15fd8e7b262ec6e17c4204cb15f984.

It's not necessary to avoid a spinlock, a sleeping lock on PREEMPT_RT, in
an interrupt handler as the interrupt handler itself would be called in a
process context if PREEMPT_RT is enabled. So revert the patch.

Cc: stable@vger.kernel.org # for 6.8
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240403051341.3534650-1-wentong.wu@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/vsc-tp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -419,6 +419,8 @@ static irqreturn_t vsc_tp_isr(int irq, v
 
 	atomic_inc(&tp->assert_cnt);
 
+	wake_up(&tp->xfer_wait);
+
 	return IRQ_WAKE_THREAD;
 }
 
@@ -426,8 +428,6 @@ static irqreturn_t vsc_tp_thread_isr(int
 {
 	struct vsc_tp *tp = data;
 
-	wake_up(&tp->xfer_wait);
-
 	if (tp->event_notify)
 		tp->event_notify(tp->event_notify_context);
 


