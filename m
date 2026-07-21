Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA5E399015;
	Tue, 21 Jul 2026 22:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674401; cv=none; b=SaIOtEzOP11JxE9sNkQd2ebJ7aAOsIOEqzYSSWucWi53RHDhnyft2R6hZdeHsfTzz9gW+tQmZbvY472a2AOcsfOtiWbZUjVpYtOLc97VQuqK8K/eUFaq4ZK1WuMqoN2S14Q0E/Aa/xRmBExjbWYiqZbmLsOTSGUmR5V8aPUbPtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674401; c=relaxed/simple;
	bh=KcVMVd9HBrLpj9jM0cUF+y7K9A3PB18KI7t+5FmyJso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7IXCBzPSwISP7peeYlld0nJ4icfiUKOvIf2oEaKxLoK9Qy3yTVVPKEg78zcYapbVWdE22zRbNK2iziG6TSmMWPowQSjEPKgRnPWdbaj1LWEXu7NIboXMX70UmjxhOKyQzXMjdtmVMFrByksWrQbw/QNpMKnHtqTq9Xq4lMTHc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9rNNPoJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9rNNPoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D522B1F000E9;
	Tue, 21 Jul 2026 22:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674400;
	bh=Gw0HQaQFbw7N6ZFb4ABQOOGGW1hKiEz1z5SelbHHTSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9rNNPoJF/i1sUz60OeMHl4NsEmmh3FwzkAJ8Mshutn97YpKsXOGNVX/PRchCU2Di
	 b67axHKtzBadgRyoRgwgR3sA/P2mzm4Nxs9bvBEl8mC5dg5jxzlpRUmzslojga2QHx
	 iPNZ/l1kjXHfKyfSOWFKN2CUAjbROqsaTOHzkbSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 5.10 526/699] cpu: hotplug: Preserve per instance callback errors
Date: Tue, 21 Jul 2026 17:24:45 +0200
Message-ID: <20260721152407.560474860@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bradley Morgan <include@grrlz.net>

commit 673db10729fb121ea1b16fe57791a0cb9eac1eb5 upstream.

cpuhp_invoke_callback() unwinds earlier callbacks for the same
hotplug state when one instance fails. The rollback path currently
reuses ret, so a successful rollback can hide the original error and
make the failed transition look successful.

Keep the rollback result separate from the original error.

Fixes: 724a86881d03 ("smp/hotplug: Callback vs state-machine consistency")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260619163719.12103-1-include@grrlz.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cpu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -156,7 +156,7 @@ static int cpuhp_invoke_callback(unsigne
 	struct cpuhp_step *step = cpuhp_get_step(state);
 	int (*cbm)(unsigned int cpu, struct hlist_node *node);
 	int (*cb)(unsigned int cpu);
-	int ret, cnt;
+	int ret, cnt, rollback_ret;
 
 	if (st->fail == state) {
 		st->fail = CPUHP_INVALID;
@@ -222,12 +222,12 @@ err:
 			break;
 
 		trace_cpuhp_multi_enter(cpu, st->target, state, cbm, node);
-		ret = cbm(cpu, node);
-		trace_cpuhp_exit(cpu, st->state, state, ret);
+		rollback_ret = cbm(cpu, node);
+		trace_cpuhp_exit(cpu, st->state, state, rollback_ret);
 		/*
 		 * Rollback must not fail,
 		 */
-		WARN_ON_ONCE(ret);
+		WARN_ON_ONCE(rollback_ret);
 	}
 	return ret;
 }


