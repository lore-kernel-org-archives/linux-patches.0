Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E571991C1;
	Thu,  6 Jun 2024 14:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683161; cv=none; b=LXFhye5ITWV3gsjpUA4ibBNHerLjv0Wqk98YsfiBfxpyHO++VSez+qCnvUGiLw3dQoJCFFw2IwcZpHAc7E2Rzze7RYuaPdp7nwdI7C2UU6EpcBBLe5d3InnzTXO5WKTZqbcusEGDZ0dzbc5sHyE4GcxxbMfo4gxyD4hGN4loTz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683161; c=relaxed/simple;
	bh=R/Mdd7Kl4ew6HznYWAYcZl9Vu8FKrb1lCFcqx8uMggI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juI/S12Szw6uubxa8FfhPLfE4yqMTuI2hS15MAVGwtXdjG7teo/POUCTZGUPyWzrgeB0i7OYNJTl5r6er9ojvSPeSZDEeAY14SMoqFO/N9uIrC0UDUJuiqf32Cz0lQ+wI2ksMNch04FT5X+RbqR/KrSE+MBN3EEdYYqmlu0wGRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=miO2UJYy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="miO2UJYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2838C32781;
	Thu,  6 Jun 2024 14:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683161;
	bh=R/Mdd7Kl4ew6HznYWAYcZl9Vu8FKrb1lCFcqx8uMggI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=miO2UJYyMeafVVZMT0VjITgY757EjEcBG8iYtiep9srOrQj+F6gWSAeJSBIorhDWc
	 nxBHUph+eerUcP4si8v3tQ6PlHBGXvsYZOcdWkjsDtWQeSMkSqVRx2FIKJOkwV7ogx
	 8T72Q/S2wgTWsArpVXlUWLrqY9ItYz0X98VenHCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/744] rcu-tasks: Fix show_rcu_tasks_trace_gp_kthread buffer overflow
Date: Thu,  6 Jun 2024 15:56:18 +0200
Message-ID: <20240606131735.790546221@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 65e000ca332cc..305e960c08ac5 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1938,7 +1938,7 @@ void show_rcu_tasks_trace_gp_kthread(void)
 {
 	char buf[64];
 
-	sprintf(buf, "N%lu h:%lu/%lu/%lu",
+	snprintf(buf, sizeof(buf), "N%lu h:%lu/%lu/%lu",
 		data_race(n_trc_holdouts),
 		data_race(n_heavy_reader_ofl_updates),
 		data_race(n_heavy_reader_updates),
-- 
2.43.0



