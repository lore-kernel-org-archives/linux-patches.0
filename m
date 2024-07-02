Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EB215218A;
	Tue,  2 Jul 2024 17:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941103; cv=none; b=qHO5zoR+eyZAoEyMarACYrtj5kuzOwL0sqNodFiSI1vHPwkScvk+HOKx8/un/MzLLhyPPlhfUtp7N+1t8Ie42kaLPMH7cl6sfEChQU85M/uAb/KiHs6aFX4FLXVxBE8whh0hGgvutqCqC0bimXnzOjxDK5RDgurgQ7aN+1rTTn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941103; c=relaxed/simple;
	bh=4gd+f/Awi64kZKeajVqo1SJX8UzaT4fGXVT+bTN8w2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGxMXFNZPAavhg4k4F9DAK53CljULew/COJunE09Bj1yj+8ny4V9dLJYIlJcpP8Zvxx06TAo3uVfgOlOAjPVxxqgo/twxSvQ1+CFW5gZTMUmj8Ro61a++ZiYZe3iD9SKQDENwfRJHYh4eBy1csdYQ3Obe4a/fN2axh1hF87E/X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TX9mjiNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TX9mjiNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD79EC116B1;
	Tue,  2 Jul 2024 17:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941103;
	bh=4gd+f/Awi64kZKeajVqo1SJX8UzaT4fGXVT+bTN8w2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TX9mjiNCfQQ1flefUULhtjTtqV92NUqwlNO8CAeuY7xxDpRYXxyD14JEIx8L5/dYS
	 uXCTV9cecP5Dk02Mq83EUg+dOX4BxHEMWtZm+Nj1oLZlIiT1raDxee9zYgUtBDy1aF
	 hEWHuS6C/Eb9pET2WrlEK6mveVK/LAWNuAsLCRFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <ytcoode@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 128/163] cpu/hotplug: Fix dynstate assignment in __cpuhp_setup_state_cpuslocked()
Date: Tue,  2 Jul 2024 19:04:02 +0200
Message-ID: <20240702170237.895539631@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Yuntao Wang <ytcoode@gmail.com>

commit 932d8476399f622aa0767a4a0a9e78e5341dc0e1 upstream.

Commit 4205e4786d0b ("cpu/hotplug: Provide dynamic range for prepare
stage") added a dynamic range for the prepare states, but did not handle
the assignment of the dynstate variable in __cpuhp_setup_state_cpuslocked().

This causes the corresponding startup callback not to be invoked when
calling __cpuhp_setup_state_cpuslocked() with the CPUHP_BP_PREPARE_DYN
parameter, even though it should be.

Currently, the users of __cpuhp_setup_state_cpuslocked(), for one reason or
another, have not triggered this bug.

Fixes: 4205e4786d0b ("cpu/hotplug: Provide dynamic range for prepare stage")
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240515134554.427071-1-ytcoode@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cpu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2495,7 +2495,7 @@ EXPORT_SYMBOL_GPL(__cpuhp_state_add_inst
  * The caller needs to hold cpus read locked while calling this function.
  * Return:
  *   On success:
- *      Positive state number if @state is CPUHP_AP_ONLINE_DYN;
+ *      Positive state number if @state is CPUHP_AP_ONLINE_DYN or CPUHP_BP_PREPARE_DYN;
  *      0 for all other states
  *   On failure: proper (negative) error code
  */
@@ -2518,7 +2518,7 @@ int __cpuhp_setup_state_cpuslocked(enum
 	ret = cpuhp_store_callbacks(state, name, startup, teardown,
 				    multi_instance);
 
-	dynstate = state == CPUHP_AP_ONLINE_DYN;
+	dynstate = state == CPUHP_AP_ONLINE_DYN || state == CPUHP_BP_PREPARE_DYN;
 	if (ret > 0 && dynstate) {
 		state = ret;
 		ret = 0;
@@ -2549,8 +2549,8 @@ int __cpuhp_setup_state_cpuslocked(enum
 out:
 	mutex_unlock(&cpuhp_state_mutex);
 	/*
-	 * If the requested state is CPUHP_AP_ONLINE_DYN, return the
-	 * dynamically allocated state in case of success.
+	 * If the requested state is CPUHP_AP_ONLINE_DYN or CPUHP_BP_PREPARE_DYN,
+	 * return the dynamically allocated state in case of success.
 	 */
 	if (!ret && dynstate)
 		return state;


