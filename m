Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D53143880;
	Tue, 10 Sep 2024 10:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963517; cv=none; b=fBcWMrMzMmRkvigQQDhvwr6GKI+TFTRWD7lVE9VYqluaiuPXRj21YmK8rJt1K07cDW8lJsJP25J5X+FD/HPVfWGiHSdAs9/CQxIiq4T5YgVDmjn97ytjZ+S+UNHGxxDtPH7aueh0SdBWJzu6e3rpMWy9vUWxuMtp+HJz0gJjR/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963517; c=relaxed/simple;
	bh=jiB71eZ2UY4cXQ07Z/J3mk5u4L7/mvnmXYrgeIHcn6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+RIJpj1sg6zRLIJXmmQ3td8060UvhpHrchKN2z8uYMvlSHpdYSHWr7PRttpoATbrm+uUtPhUZR1fLvOK4p5YnrvYc1GPeHUZ7TlJxzbZJeZJSN0hvuGFHCTyoJwtVm0XHyh5Wm1VeCcgL5686Vx/I/pQmfcQmrGLDZ8f5Q2Vfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSJ1mx35; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSJ1mx35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E8AC4CEC3;
	Tue, 10 Sep 2024 10:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963517;
	bh=jiB71eZ2UY4cXQ07Z/J3mk5u4L7/mvnmXYrgeIHcn6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSJ1mx35eF07j3t8aDPQ5C20YSNST+EURAsIsxDkYWyVbJK2Hp6fNj80KzLm7Wbed
	 JqjGPM6iMJ5KZuE2kNsIPyZqH73aMUsDzPiCP9EsHpsszYV+F06JFgdxq5OefUaeqB
	 sIasxXdYpPcJoIcEexuwBqUZ/JAjvwAVTbpmi80I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Vamsi Krishna Brahmajosyula <vamsi-krishna.brahmajosyula@broadcom.com>
Subject: [PATCH 5.15 057/214] rcu-tasks: Fix show_rcu_tasks_trace_gp_kthread buffer overflow
Date: Tue, 10 Sep 2024 11:31:19 +0200
Message-ID: <20240910092601.093140586@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Kiryushin <kiryushin@ancud.ru>

commit cc5645fddb0ce28492b15520306d092730dffa48 upstream.

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
Signed-off-by: Vamsi Krishna Brahmajosyula <vamsi-krishna.brahmajosyula@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tasks.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1323,7 +1323,7 @@ void show_rcu_tasks_trace_gp_kthread(voi
 {
 	char buf[64];
 
-	sprintf(buf, "N%d h:%lu/%lu/%lu", atomic_read(&trc_n_readers_need_end),
+	snprintf(buf, sizeof(buf), "N%d h:%lu/%lu/%lu", atomic_read(&trc_n_readers_need_end),
 		data_race(n_heavy_reader_ofl_updates),
 		data_race(n_heavy_reader_updates),
 		data_race(n_heavy_reader_attempts));


