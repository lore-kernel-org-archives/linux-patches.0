Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88DC45DF4E;
	Tue, 21 Jul 2026 20:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667481; cv=none; b=p2gVCgR+fLfmH0ZsJ/QSnWhBBHq9K/lRnN9kldBBodqY84nc/i12pWROQjw3Z+WFxnBqs0zIFERz6wlp4K90I/FaS2O1ujLb1mOJspzmmRdsCIV1afxodfKNHJ2rDndo3UZBmBuw5mSjo4plOyPUWbBxWjRKtTN3oVpbEdFgp7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667481; c=relaxed/simple;
	bh=IwAxh4WunEZ1JbfqOYFKHals0w3+nIxq/y0YLQX4S/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mB/Fp0ZHqaliWDUZpbyBX6GTP5cv25cdrkDEAK+6Kzfx2LGoWuZckJ4YQXq4/djin/3bfB5C/knaC1a2sF5MuKYX6qV0gvpJFLh+G1LKUxgO9/GaTLh57QEiD0dyaNdKIGNz3ze7ANOs9YttLCVe8cctoPJRgsPobFcRPv/EtPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBZVzV8e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBZVzV8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F7F1F000E9;
	Tue, 21 Jul 2026 20:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667474;
	bh=2os/h1c9uLwwPpKxaUZ62oB+iAt6y42bP5Ldab3lItg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XBZVzV8e9BBGX7hNFqNTfyrbvDc1PClc1OZiqldoUlxmpt6kIGsgAGhj2p1TeGXKe
	 TUst5tIK2h+GBiXhlbIMC9fbMYf8yPYWb8E5A/TSkEKyRY1w+7NxLAWS2ZZqLmKGD7
	 GNQ1l/k+k814ga94OZK0/KIWI5V3rQ5SqUJuC738=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.6 1076/1266] cpu: hotplug: Preserve per instance callback errors
Date: Tue, 21 Jul 2026 17:25:13 +0200
Message-ID: <20260721152505.895636454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -175,7 +175,7 @@ static int cpuhp_invoke_callback(unsigne
 	struct cpuhp_step *step = cpuhp_get_step(state);
 	int (*cbm)(unsigned int cpu, struct hlist_node *node);
 	int (*cb)(unsigned int cpu);
-	int ret, cnt;
+	int ret, cnt, rollback_ret;
 
 	if (st->fail == state) {
 		st->fail = CPUHP_INVALID;
@@ -239,12 +239,12 @@ err:
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


