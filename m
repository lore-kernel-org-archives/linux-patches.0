Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEED22332E;
	Thu, 12 Dec 2024 17:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023695; cv=none; b=A7xNHUFLwedaq+Rv6FH1dAcuA5ZPqfk/FJb3fDgGQFYRbXpGF3nAUO0GHziIzBNzsv2JESpzFE1wL8lMwagc8sC5uthSfbaPa32bl1ECsMf/EnB2gSOQCqoBo8eBs0i/w9HX24WdySRzYSToLy8fkc4woMgP20S2iBcpCyx0XHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023695; c=relaxed/simple;
	bh=Ygk9ijJtZxCCDHEvLRTBaMM0XwsyRSv9qq2DTG7qHcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMHG6GsMCnhM2CUDGI8xr6D7nl/I2t9QC81V4KHJNPBnC63LTF0xqfusNx+BF20eRiUH5biV9vVlCAKE3D0LDaClooGFQwvEr6nkdAr/o5NJBLo513f3UY6wAsjfXbEw6nVJa0OS6Yw6/v7Cyy13pNnpC9lVA8jB1eRPquUklGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npwn1hDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npwn1hDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E58C4CECE;
	Thu, 12 Dec 2024 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023695;
	bh=Ygk9ijJtZxCCDHEvLRTBaMM0XwsyRSv9qq2DTG7qHcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npwn1hDxw4SkrS+mNCGtnYzUfdKwm1OsneWVBanIoKsvpgS/ozrBwUX57OMT4zJGB
	 YdfBNx8S7SmCmPf6AP+MxMGPljAcwuGlCh597f+IeVOYoB3eVUnVwYanjVC782SiBi
	 9FMK5O+MGyaDmMcVYYF38iPfs0+ZAzhEs3UmbyzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Eric Dumazet <edumazet@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <kafai@fb.com>,
	KP Singh <kpsingh@kernel.org>,
	Krister Johansen <kjlx@templeofstupid.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/459] rcu-tasks: Idle tasks on offline CPUs are in quiescent states
Date: Thu, 12 Dec 2024 15:56:28 +0100
Message-ID: <20241212144255.498259854@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

commit 5c9a9ca44fda41c5e82f50efced5297a9c19760d upstream.

Any idle task corresponding to an offline CPU is in an RCU Tasks Trace
quiescent state.  This commit causes rcu_tasks_trace_postscan() to ignore
idle tasks for offline CPUs, which it can do safely due to CPU-hotplug
operations being disabled.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: KP Singh <kpsingh@kernel.org>
Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index bede3a4f108e3..ea45a2d53a99e 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1007,7 +1007,7 @@ static void rcu_tasks_trace_postscan(struct list_head *hop)
 {
 	int cpu;
 
-	for_each_possible_cpu(cpu)
+	for_each_online_cpu(cpu)
 		rcu_tasks_trace_pertask(idle_task(cpu), hop);
 
 	// Re-enable CPU hotplug now that the tasklist scan has completed.
-- 
2.43.0



