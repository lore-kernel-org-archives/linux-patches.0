Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DF4A59;
	Tue,  5 Dec 2023 03:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Do6Kev0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C84C433C7;
	Tue,  5 Dec 2023 03:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747496;
	bh=fysSgXQJbRmXrxSY8aQDmTwAwzXzfoHYsrcjWeVuiMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Do6Kev0YL6OHFCmDgtbpMK3EKEw4/mj5SZOYcnqlJ6CK2UWCPE2Wa9yE6r8qDYvMN
	 q7nuYNYQ2kKt0PzfIXvluw+jmgbvccZLIRNYzEKs7lKvQMsD+a0SWurEXnOWH/PXC2
	 H3+tJeJASbrEdN1I4yemzMnG/cbhjhOFiPOCSe8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/135] Revert "workqueue: remove unused cancel_work()"
Date: Tue,  5 Dec 2023 12:16:59 +0900
Message-ID: <20231205031536.851621539@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

[ Upstream commit 73b4b53276a1d6290cd4f47dbbc885b6e6e59ac6 ]

This reverts commit 6417250d3f894e66a68ba1cd93676143f2376a6f.

amdpgu need this function in order to prematurly stop pending
reset works when another reset work already in progress.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Lai Jiangshan<jiangshanlai@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 91d3d149978b ("r8169: prevent potential deadlock in rtl8169_close")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/workqueue.h | 1 +
 kernel/workqueue.c        | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 460c58fa011ae..0383fac637e19 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -460,6 +460,7 @@ extern int schedule_on_each_cpu(work_func_t func);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
 extern bool flush_work(struct work_struct *work);
+extern bool cancel_work(struct work_struct *work);
 extern bool cancel_work_sync(struct work_struct *work);
 
 extern bool flush_delayed_work(struct delayed_work *dwork);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 37d01e44d4837..63140e4dd5dfc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3240,6 +3240,15 @@ static bool __cancel_work(struct work_struct *work, bool is_dwork)
 	return ret;
 }
 
+/*
+ * See cancel_delayed_work()
+ */
+bool cancel_work(struct work_struct *work)
+{
+	return __cancel_work(work, false);
+}
+EXPORT_SYMBOL(cancel_work);
+
 /**
  * cancel_delayed_work - cancel a delayed work
  * @dwork: delayed_work to cancel
-- 
2.42.0



