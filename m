Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7083FE375;
	Sat, 12 Sep 2026 09:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206644; cv=none; b=c6FU3yDW0eWSfEDfFfoAQUBNzPuUGN6mVn9aTpBjGVEI1danr5qvHp9EQWiRtUr6UQ43/b2TbjhrpSQLzWgN+iBPbGoxuTgHnYUPzqje2H/41uUrYiJEwkFnPWuFTDgCqJEFczYQTKLbM4fLDOPf9owa8bXB74fpCcCsUhS3yPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206644; c=relaxed/simple;
	bh=Ik2Cfk2ju7azxfpy4JS7redpvMz5z1CRcv/O/egn9/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cpw85QnqEzNxUr4c3n8ZZrfoYy6lGBpwj7OCCUpysXnkUc6NHvDUme+5n0lieKgodwJLjsVs3B5h/butdu8V6WuKinyuD1L36V6ElNoNy6WjjziGzowL5Mll5oe+UEkamvUeCEvtMsOqGqs4YVVooDH/VtOSVQJrcSLYp2J+3A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FExBmy+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FExBmy+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3060E1F000FF;
	Sat, 12 Sep 2026 09:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206643;
	bh=1ufAmW+whQNAoZb37WgNESd5C6SKcZ9LQy8KFwcRA8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FExBmy+cIIrtmOe+aukug09TCyor4r3sfw7LPfCJNEwARBM0WdiWaauXmhtxHg0R0
	 mMebXUhQkX9z6N2Wv13ltLz0wjknFqjii7znpckLnw6+U8aAO/rS0h46hSW37EMwN7
	 UsZ9hK9bUF7xXEq1DNtRgiMd/mV3T2OTevthp+uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0249/1518] timens: Add a __free() wrapper for put_time_ns()
Date: Sat, 12 Sep 2026 08:40:18 +0200
Message-ID: <20260912065629.116673616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit c2de5a5be4d60af5f928a2dd2b0f73e17358e346 ]

The wrapper will be used to simplify cleanups of 'struct time_namespace'.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260330-timens-cleanup-v1-1-936e91c9dd30@linutronix.de
Stable-dep-of: 06aba58e5849 ("time/namespace: Validate nanosecond field in proc_timens_set_offset()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/time_namespace.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
index c1de21a27c340..58bd9728df583 100644
--- a/include/linux/time_namespace.h
+++ b/include/linux/time_namespace.h
@@ -8,6 +8,7 @@
 #include <linux/ns_common.h>
 #include <linux/err.h>
 #include <linux/time64.h>
+#include <linux/cleanup.h>
 
 struct user_namespace;
 extern struct user_namespace init_user_ns;
@@ -171,4 +172,6 @@ static inline struct page *find_timens_vvar_page(struct vm_area_struct *vma)
 }
 #endif /* CONFIG_TIME_NS_VDSO */
 
+DEFINE_FREE(time_ns, struct time_namespace *, if (_T) put_time_ns(_T))
+
 #endif /* _LINUX_TIMENS_H */
-- 
2.53.0



