Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85AD11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AF5C433C7;
	Mon, 28 Aug 2023 10:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218062;
	bh=+GSGEvjgsPL1S9q9U/zBn6utlVHKo14X9NGvJyfD1NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBjLLo31GIi7pdSBo8/3ZKkLWMULwOzzpLPL/31Ys3nZowcFiy7BAw+0R3jlpftMp
	 AnvcHTbdkBcJfMGpY9RstTYWoCIebp+LUvgPAVkDLYdBKvil2OCFa0xxBrIijmRqjO
	 gjJEbfwskRJsmuD3tfsJa3vUEwWEl5P6bt7sfsDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Qais Yousef (Google)" <qyousef@layalina.io>,
	Juri Lelli <juri.lelli@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.4 082/129] cgroup/cpuset: Iterate only if DEADLINE tasks are present
Date: Mon, 28 Aug 2023 12:12:41 +0200
Message-ID: <20230828101200.067831348@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juri Lelli <juri.lelli@redhat.com>

commit c0f78fd5edcf29b2822ac165f9248a6c165e8554 upstream.

update_tasks_root_domain currently iterates over all tasks even if no
DEADLINE task is present on the cpuset/root domain for which bandwidth
accounting is being rebuilt. This has been reported to introduce 10+ ms
delays on suspend-resume operations.

Skip the costly iteration for cpusets that don't contain DEADLINE tasks.

Reported-by: Qais Yousef (Google) <qyousef@layalina.io>
Link: https://lore.kernel.org/lkml/20230206221428.2125324-1-qyousef@layalina.io/
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1092,6 +1092,9 @@ static void dl_update_tasks_root_domain(
 	struct css_task_iter it;
 	struct task_struct *task;
 
+	if (cs->nr_deadline_tasks == 0)
+		return;
+
 	css_task_iter_start(&cs->css, 0, &it);
 
 	while ((task = css_task_iter_next(&it)))


