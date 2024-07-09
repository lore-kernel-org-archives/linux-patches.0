Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7E4153812;
	Tue,  9 Jul 2024 11:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523813; cv=none; b=RI2c0vpPkW83u2fSj2S5hLa4TrBtxodqg9GmOUbCVagfhumY2Z0OVhP2JWEmcGoZ120MMTLwgjbJbYFCEYI6CLO/opluTIvw7oR+Ydswn2lEdwWSY4BpiW++Kopczo1QIeC+YHHtGBYiiqVEB2rZ4JCUtnKbyxihl5c0wWbXv4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523813; c=relaxed/simple;
	bh=iWb9zfHmY5qQH9s+m/AdsKnxivCUUpZo8m+/DM3j1M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihXiNc+T1EH5t0T/6ZgVzt46DTE+91OXL9uyfMRKYhCVzvNz4jNAwiKwc+QQDUzEyflcpoF5uHqliYYXPyL7R5fnRpwWTncBpovf6xqKy7jUiuP8Mx/NjyMogxStuyt5OJsGdHRIkVXrGPxSDUVddiwBciN6y9yY+k55kVA8xBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAIrCq4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAIrCq4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CDCC3277B;
	Tue,  9 Jul 2024 11:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523813;
	bh=iWb9zfHmY5qQH9s+m/AdsKnxivCUUpZo8m+/DM3j1M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAIrCq4fJhV+wQBssy7Vp9g5I15Lmml0kPIPWllTWB5rQtfG0bN2NER4hbNTAHPZD
	 0BAivAUDdBgUtigVnkOzsR+fon+GCkXmfXFcze2VicAALuL68OYAEjms4wGnYfv0Sj
	 WFYOJeBwjmxbAlWKGZZfpeZLh+/wpU4PCcGfMFtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 087/139] cpu: Fix broken cmdline "nosmp" and "maxcpus=0"
Date: Tue,  9 Jul 2024 13:09:47 +0200
Message-ID: <20240709110701.537530900@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 6ef8eb5125722c241fd60d7b0c872d5c2e5dd4ca upstream.

After the rework of "Parallel CPU bringup", the cmdline "nosmp" and
"maxcpus=0" parameters are not working anymore. These parameters set
setup_max_cpus to zero and that's handed to bringup_nonboot_cpus().

The code there does a decrement before checking for zero, which brings it
into the negative space and brings up all CPUs.

Add a zero check at the beginning of the function to prevent this.

[ tglx: Massaged change log ]

Fixes: 18415f33e2ac4ab382 ("cpu/hotplug: Allow "parallel" bringup up to CPUHP_BP_KICK_AP_STATE")
Fixes: 06c6796e0304234da6 ("cpu/hotplug: Fix off by one in cpuhp_bringup_mask()")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240618081336.3996825-1-chenhuacai@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cpu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1907,6 +1907,9 @@ static inline bool cpuhp_bringup_cpus_pa
 
 void __init bringup_nonboot_cpus(unsigned int setup_max_cpus)
 {
+	if (!setup_max_cpus)
+		return;
+
 	/* Try parallel bringup optimization if enabled */
 	if (cpuhp_bringup_cpus_parallel(setup_max_cpus))
 		return;


