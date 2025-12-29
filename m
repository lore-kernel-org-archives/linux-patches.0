Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364F19460;
	Mon, 29 Dec 2025 16:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025341; cv=none; b=tBdNfellE4TzG/w0PefkI0QWeLFL/jy8yoscDL0/JtuaiaXol90H7/IcuAJ+U7ubOUrkrACdnR84avP5SUBefmZ/SwuMOV0hIt9fekqdRPzLaGe6x+9xwGnRrmOZJS9HbUBQd2j6SS2iCRT3GbkO+bkmhzkP932lsYrTUJF6DaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025341; c=relaxed/simple;
	bh=+hq+90oqPmFW43dddgj9EpkZjiqgfnbgvJfEdescztU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LE5FnEznCDd2C74vVGwOKr74Z/H21yUPW4XA4/dvexJE1AUfXDY3BeRO8OOvywL0pOVsApAPNXDRw0kUCNkBN4NluzgYIVoNEsY5QlCBc9yQyUmB66fjPuBLo/m7FZitZT+HS3NqrDpVaoKN9jOWgrelfyMbdqLU8awVlYBEcUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hV2zwS6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hV2zwS6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6F8C4CEF7;
	Mon, 29 Dec 2025 16:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025341;
	bh=+hq+90oqPmFW43dddgj9EpkZjiqgfnbgvJfEdescztU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hV2zwS6d8lxlE8x4prz9gc8qzXsezhlcCu6qssDViTY/i3eyUOpy5uKYY6BowmgUW
	 BKiiBIzlmwtUmxAkp+DPh6q+w0FSLKqMrvsYMfY41mKlI5TNw1o6m5vx1PcRuAA3+L
	 +qELiPilU6sLpgsOthsOMptBbrK+7kosUQVSbkv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 180/430] um: init cpu_tasks[] earlier
Date: Mon, 29 Dec 2025 17:09:42 +0100
Message-ID: <20251229160730.982684817@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7b5d4416964c07c902163822a30a622111172b01 ]

This is currently done in uml_finishsetup(), but e.g. with
KCOV enabled we'll crash because some init code can call
into e.g. memparse(), which has coverage annotations, and
then the checks in check_kcov_mode() crash because current
is NULL.

Simply initialize the cpu_tasks[] array statically, which
fixes the crash. For the later SMP work, it seems to have
not really caused any problems yet, but initialize all of
the entries anyway.

Link: https://patch.msgid.link/20250924113214.c76cd74d0583.I974f691ebb1a2b47915bd2b04cc38e5263b9447f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/process.c | 4 +++-
 arch/um/kernel/um_arch.c | 2 --
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 9c9c66dc45f0..13d461712c99 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -43,7 +43,9 @@
  * cares about its entry, so it's OK if another processor is modifying its
  * entry.
  */
-struct task_struct *cpu_tasks[NR_CPUS];
+struct task_struct *cpu_tasks[NR_CPUS] = {
+	[0 ... NR_CPUS - 1] = &init_task,
+};
 EXPORT_SYMBOL(cpu_tasks);
 
 void free_stack(unsigned long stack, int order)
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index cfbbbf8500c3..ed2f67848a50 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -239,8 +239,6 @@ static struct notifier_block panic_exit_notifier = {
 
 void uml_finishsetup(void)
 {
-	cpu_tasks[0] = &init_task;
-
 	atomic_notifier_chain_register(&panic_notifier_list,
 				       &panic_exit_notifier);
 
-- 
2.51.0



