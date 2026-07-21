Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627A63B994F;
	Tue, 21 Jul 2026 21:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670281; cv=none; b=RsxuC8uSLtu9GHCk85qWOK9QgYnnWpZKhS5myQB6hAPcnZ5xD0OHEmhZruoKYJmNmOdkhUup3BbvC0ZDD+92tpfqEeNCLOmCIduH71F3ftaqyAtEh9kpjXIoWvtW08J3+v8DhKNjYTGS4Fz8/7DGB33bqJFJBdSLZj5BJ9+V7n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670281; c=relaxed/simple;
	bh=xacelSAqbi0WHP0d4irfR+C/UZVmv+vy3N4XckiF4xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/bC3l6vmTO3YfJsSKqLUuEKzQ8qrhq2E3iwFWsaQgCxbHw4dyhWbkjXgwNpPs4fPqduwB6ljLOoF7p51RsEB8PlZPJscSRZ3D7wGwJ4AXk/SxgiJoAVPVBvUb8p8/wDtcRs8TI0mEegRV+5oqXcpR/ET+VGLpYHfj4TY0pPc3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5jxfTK8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5jxfTK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75081F00A3A;
	Tue, 21 Jul 2026 21:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670280;
	bh=0vxoWY5LgzQpfwA0AcOhTMIqbM7BOaty1RMw/S1HLT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R5jxfTK8tJEOPvzES/gw8HYv//wMeklIOwYZfTRCx7dPVK4vS881K8J/v1iYed+Nu
	 mxbYpqok+Zdrb1SXUf7Ug7GZwYPgMU9KqXqaWmecWtFl3oN+xcu96Dc/W+8DD0xE4q
	 I9yyyrH/UQUBTxrtty2oPpRW8lJytvWwar4gRWc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.1 0872/1067] cpu: hotplug: Preserve per instance callback errors
Date: Tue, 21 Jul 2026 17:24:33 +0200
Message-ID: <20260721152444.040919346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -172,7 +172,7 @@ static int cpuhp_invoke_callback(unsigne
 	struct cpuhp_step *step = cpuhp_get_step(state);
 	int (*cbm)(unsigned int cpu, struct hlist_node *node);
 	int (*cb)(unsigned int cpu);
-	int ret, cnt;
+	int ret, cnt, rollback_ret;
 
 	if (st->fail == state) {
 		st->fail = CPUHP_INVALID;
@@ -236,12 +236,12 @@ err:
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


