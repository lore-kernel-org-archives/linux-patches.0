Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB683BB9F1;
	Sat, 17 Oct 2026 17:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259085; cv=none; b=RNxyhPEc/Li0YWz4Nq4vi5pMR2TL+O9hZuBdJeKGCuip+mTMFIewtDgEzcdKxVtwtlp8y4fNMB8xk9rtSdgbNWfEce3CBc6ge0+xxJH0307IrjuqNieqO3s898E0clppx+J8H/l9weUYtLtna/HE66x1c03FNrw14dCZZMuZjtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259085; c=relaxed/simple;
	bh=OXMSht0wE/vjtP0uOODxIXfMGNS6sz98ZbuVwqn2swk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKth3LO5mdI5fpJl5vF4VRF59mKtozjOTQd3Iquv4+RETlUCI+qAgJE5wDNsHjQPhqcjrou2IdTH1YO19M/tjlaHBRDc3l8770UN69maPcqASpEaoBX2HcdbTOicP7jEmdkLnumHpt3Ky5yNDoZ3O6qiZjZQCAInYoicXHgJwfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvZ0LJxK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvZ0LJxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6C11F000C4;
	Sat, 17 Oct 2026 17:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259084;
	bh=9OYjmrttXuiMTf1ekrB/xPoYXlJFJDslhuZFu6t5QC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GvZ0LJxKfxBT4sfasLeAL2IuMi5i2QRD6nIhYdNX3+DNtPW4UE6BxqplaYXCzSoLW
	 lSVI+TUFZeyta5HlM1YrWsrkpOuoD1F90TQ7hDt6qzigxi/QrGQtGzoVPrf0jmZhaB
	 7EhjBG0krWZriHITtsk3RIKCQrh28Ij7ehO2Qu+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1096/1674] rcu: add rcu_read_lock_dont_migrate()
Date: Sat, 17 Oct 2026 17:56:08 +0200
Message-ID: <20261017160459.265499630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit 1b93c03fb319d72a1f5f4723abd5df15ce40f4e2 ]

migrate_disable() is called to disable migration in the kernel, and it is
often used together with rcu_read_lock().

However, with PREEMPT_RCU disabled, it's unnecessary, as rcu_read_lock()
will always disable preemption, which will also disable migration.

Introduce rcu_read_lock_dont_migrate() and rcu_read_unlock_migrate(),
which will do the migration enable and disable only when PREEMPT_RCU.

Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/r/20250821090609.42508-2-dongml2@chinatelecom.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 7cbd0c4cebe4 ("bpf: Fix UAF in sock clone early bailouts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 27531a0b3a6e7..95f783de1fbb7 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -908,6 +908,20 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 	preempt_enable_notrace();
 }
 
+static __always_inline void rcu_read_lock_dont_migrate(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPT_RCU))
+		migrate_disable();
+	rcu_read_lock();
+}
+
+static inline void rcu_read_unlock_migrate(void)
+{
+	rcu_read_unlock();
+	if (IS_ENABLED(CONFIG_PREEMPT_RCU))
+		migrate_enable();
+}
+
 /**
  * RCU_INIT_POINTER() - initialize an RCU protected pointer
  * @p: The pointer to be initialized.
-- 
2.53.0



