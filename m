Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644181DFED;
	Mon, 27 May 2024 19:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836444; cv=none; b=TzbLmiEmNXvIjLOD8vtfDIUD6Yl7mKGvai9yJyDLT1UHvn/9sHg2SgwhWmrBEy+CNJigFRSZY3j8zpw1+XXdGOwn/TWGtLj59Gf8xjmm6/KSC3SnRQLvPVImzTDxaTFChZJEQqR/tUeVfJwa4spCaiWuvSaOwwCFBz7Y6AVCZ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836444; c=relaxed/simple;
	bh=3tnjLJMLBbvmDL4Oapln8FAZkVm4to83uZCttaz/6d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ks9u73D8eymkEILngNfharmaFVjhv+uHO7IANw5PIggy/pXqwFAH9whyYWRmtiU+xs6rU85Mu/iuwb9RZKoNAhq8XNCKaMq+/oX8OApbGvN7HDdsioqq1JdtblKLyeYI6PKNFKAll+THUp8cdTMFIXWI4xrSU8eSCYHcp5rfdjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmevPges; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmevPges"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE17C2BBFC;
	Mon, 27 May 2024 19:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836444;
	bh=3tnjLJMLBbvmDL4Oapln8FAZkVm4to83uZCttaz/6d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmevPgesVtYoJ0E7Z3a46fiHfIKG+oYf5RQ0MW/95W3Dz9GqNlMQ7HVOcKVPifeFe
	 s2X6ZyhZrmx3NNtzCuRD4SLILpmC9nfIUXgld4XqIjWUerbF1/0N1aj1l6tomL/HSE
	 wc4F9lNlrLYuhzEmI/ZscX9RWSM6OvtyOJy29QPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 057/427] rcu-tasks: Fix show_rcu_tasks_trace_gp_kthread buffer overflow
Date: Mon, 27 May 2024 20:51:44 +0200
Message-ID: <20240527185607.160668410@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Kiryushin <kiryushin@ancud.ru>

[ Upstream commit cc5645fddb0ce28492b15520306d092730dffa48 ]

There is a possibility of buffer overflow in
show_rcu_tasks_trace_gp_kthread() if counters, passed
to sprintf() are huge. Counter numbers, needed for this
are unrealistically high, but buffer overflow is still
possible.

Use snprintf() with buffer size instead of sprintf().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: edf3775f0ad6 ("rcu-tasks: Add count for idle tasks on offline CPUs")
Signed-off-by: Nikita Kiryushin <kiryushin@ancud.ru>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 147b5945d67a0..2a453de9f3d95 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1994,7 +1994,7 @@ void show_rcu_tasks_trace_gp_kthread(void)
 {
 	char buf[64];
 
-	sprintf(buf, "N%lu h:%lu/%lu/%lu",
+	snprintf(buf, sizeof(buf), "N%lu h:%lu/%lu/%lu",
 		data_race(n_trc_holdouts),
 		data_race(n_heavy_reader_ofl_updates),
 		data_race(n_heavy_reader_updates),
-- 
2.43.0



