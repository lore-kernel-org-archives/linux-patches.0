Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B13B168C4;
	Mon, 27 May 2024 19:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837740; cv=none; b=k3HdWcgdsgnTWDSntHB6iKE13NRg2RiQoAzSYFlzgAuNcUxLwTnyW3f/t3P5PSIPb+7XasswZ3a200lPYGeB2ogRnel1cQ64gYVh+g5Lj9ntYwBV5WVmR5BYT57tyaKzli44uSE0axNdWiHT1P6G6lLw3Pl7lXcoRPA7rPWm34k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837740; c=relaxed/simple;
	bh=gj4N5BEjFiSgJ/dQx+RhkgoivyZ66a2IA2f42kLYCeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtwnifO4RamMquyJTTBNwGajmImbiEOMWQT4GLO59uLU+ppxKpwIqyq0Dzi6X9llpK3hSbrSHjWuEbVKE4Fpl43fH3I7cYFi0RJf2L0BU5ZTa7d9LaFqOkKP0xN00lofYlo9g+vT8FSufmtJWkfiT0gs3oZp50d8oNnuakuT4sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfqaWFiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfqaWFiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C626BC2BBFC;
	Mon, 27 May 2024 19:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837740;
	bh=gj4N5BEjFiSgJ/dQx+RhkgoivyZ66a2IA2f42kLYCeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfqaWFiTtb2Iuum3RJW6U7qTmv41AmhlBRIKSmanmvKK579sArqRvogJoJ1gW0Tpl
	 eas8skAG0wMpQ2aVxelfvJ76TLPXEA9/zHhbfv1mpzo4E4N2V4pQx0c+lWfqgiHIqR
	 +FfVg6TrFMCPbPkBdWyCMbiY1qiHdxCaQsVs8pgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 124/493] rcu-tasks: Fix show_rcu_tasks_trace_gp_kthread buffer overflow
Date: Mon, 27 May 2024 20:52:06 +0200
Message-ID: <20240527185634.548995409@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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
index 732ad5b39946a..3f64268fe9ead 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1941,7 +1941,7 @@ void show_rcu_tasks_trace_gp_kthread(void)
 {
 	char buf[64];
 
-	sprintf(buf, "N%lu h:%lu/%lu/%lu",
+	snprintf(buf, sizeof(buf), "N%lu h:%lu/%lu/%lu",
 		data_race(n_trc_holdouts),
 		data_race(n_heavy_reader_ofl_updates),
 		data_race(n_heavy_reader_updates),
-- 
2.43.0



