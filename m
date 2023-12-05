Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED926AC2;
	Tue,  5 Dec 2023 03:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRmXMwRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC6CC433C8;
	Tue,  5 Dec 2023 03:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747772;
	bh=O94ghMHhdccr3JLfRxULUy38emkdU7VgphL76WjikOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRmXMwRrvhofOLRQlSR8BjSatkp3EpBig87HdJDCCApiUe7ZjOuLv0a4VC1NXSnM1
	 wJ3aTp8lmiLpSN56rzuQMzMlHeu0iQVEFkohEfzXGDl0K2B5LoHiQcf7cdwdsVGdEX
	 CTyytAHOdnMBlanFlI4RamrXvwzjt1Qds5B5c5JQ=
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
Subject: [PATCH 5.15 38/67] Revert "workqueue: remove unused cancel_work()"
Date: Tue,  5 Dec 2023 12:17:23 +0900
Message-ID: <20231205031522.013585645@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1e96680f50230..5f2e531d0a80d 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -462,6 +462,7 @@ extern int schedule_on_each_cpu(work_func_t func);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
 extern bool flush_work(struct work_struct *work);
+extern bool cancel_work(struct work_struct *work);
 extern bool cancel_work_sync(struct work_struct *work);
 
 extern bool flush_delayed_work(struct delayed_work *dwork);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 962ee27ec7d70..d5f30b610217e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3277,6 +3277,15 @@ static bool __cancel_work(struct work_struct *work, bool is_dwork)
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



