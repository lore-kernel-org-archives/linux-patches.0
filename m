Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F09405845;
	Tue, 21 Jul 2026 17:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655064; cv=none; b=ipyhfdn1/UwSQArpdYSQkSaUhTkEOxI+6MUg7RpDWKaZSB57O2xpUMUyjuSSUzBJc3DMSZH+tiO7qqNIPpxgSrdcOwQASNJUSxUbk8Q/+dLSubmIA/qnWvnZVjUQMEz0A+C/cxg2NmS694J6y+TSLwRiK8Pe+bpKQVsXiHOxh6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655064; c=relaxed/simple;
	bh=1y04H2la9YlU7GAUgTF08QI3Jz+Fg33xfOLIp04dcTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3P1snX+H6PtEZEhC3n3nxUQb/5gWSTWTZCj1LZzotfo5acESbdDld0qkCz0Yk+WnnSPkw//7wjq0kR9GLG/fasVvFo3bjAx/h2Y3zDIXS4FpK+i3urMwvBWyN9dVjduuRD8dDlzPFYs+4pVwqt3V7Bp87nibCzo6agoNmqjlhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fag7bZfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fag7bZfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141321F000E9;
	Tue, 21 Jul 2026 17:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655063;
	bh=voSI3hYKIuudOsdb4e76b+g+7kDfLoyE6//W8nEsafk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fag7bZfoWTnx0hzb8Ot75DQOAWeMHtSM6+Yv6ot53SLuj1sDlsiPHWpHZ2qRMDkMz
	 TehsM1mjAb3fdswK2OqQG3uKfnzG3Nd+xZNWVmZodUgmIyHsC0YltTOJsyxCYLc5dx
	 lxA2thQrOc2S5pMf6/W2KmVj8GKZpmB+bX98WZkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.1 1899/2077] cpu: hotplug: Preserve per instance callback errors
Date: Tue, 21 Jul 2026 17:26:12 +0200
Message-ID: <20260721152637.510843236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -174,7 +174,7 @@ static int cpuhp_invoke_callback(unsigne
 	struct cpuhp_step *step = cpuhp_get_step(state);
 	int (*cbm)(unsigned int cpu, struct hlist_node *node);
 	int (*cb)(unsigned int cpu);
-	int ret, cnt;
+	int ret, cnt, rollback_ret;
 
 	if (st->fail == state) {
 		st->fail = CPUHP_INVALID;
@@ -238,12 +238,12 @@ err:
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


