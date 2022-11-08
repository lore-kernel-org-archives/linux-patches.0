Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAA215CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30ADC433C1;
	Tue,  8 Nov 2022 14:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916816;
	bh=T9AFVs8vMFGnW8jGvpY3W4TT2wKhYQK33+Dc1yd52lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zt2KlfYiSVOaAUI1S4Mj7dD7bIRFM7ULhwMDbXzU9Ti8qpL22ysTmLPyie2mZskTQ
	 v4vxiEx1ltTmOYUcuJ2CcOqQ4AzjBQa8BEm0uoUq+UeOmdzeK16kbyeNaMho0ZRBqT
	 fXVOKi8T/f7n3tP1pw6AcuNvJnskcW71DisPCwlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liq3ea@163.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.0 142/197] kprobe: reverse kp->flags when arm_kprobe failed
Date: Tue,  8 Nov 2022 14:39:40 +0100
Message-Id: <20221108133401.395171539@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Qiang <liq3ea@163.com>

commit 4a6f316d6855a434f56dbbeba05e14c01acde8f8 upstream.

In aggregate kprobe case, when arm_kprobe failed,
we need set the kp->flags with KPROBE_FLAG_DISABLED again.
If not, the 'kp' kprobe will been considered as enabled
but it actually not enabled.

Link: https://lore.kernel.org/all/20220902155820.34755-1-liq3ea@163.com/

Fixes: 12310e343755 ("kprobes: Propagate error from arm_kprobe_ftrace()")
Cc: stable@vger.kernel.org
Signed-off-by: Li Qiang <liq3ea@163.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2425,8 +2425,11 @@ int enable_kprobe(struct kprobe *kp)
 	if (!kprobes_all_disarmed && kprobe_disabled(p)) {
 		p->flags &= ~KPROBE_FLAG_DISABLED;
 		ret = arm_kprobe(p);
-		if (ret)
+		if (ret) {
 			p->flags |= KPROBE_FLAG_DISABLED;
+			if (p != kp)
+				kp->flags |= KPROBE_FLAG_DISABLED;
+		}
 	}
 out:
 	mutex_unlock(&kprobe_mutex);


