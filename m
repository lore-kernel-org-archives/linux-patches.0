Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F46442118;
	Tue, 21 Jul 2026 22:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672580; cv=none; b=us7R7bsuI56Ds5qKGqRhOtBCu309NhMbJ902Y47Jqydg8yAL5X85F3+oja+dN+iWHJ/7lrJBVAZ8un/P8KpzjK1V1z7sMrlLG0Nzp3gdZYU+3h7ljjV826HSVZU7a3POuOVrPlSwtfoLIDMDmJ/lZCbZN9bLfpG/Xc6Nq0BiN4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672580; c=relaxed/simple;
	bh=pQ8fBxn7QK9G38QbsZ7DnrFErGwmHy1vavBalhRjcck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lC2Cfpyf77BlkIb+o0F90Idg3wYKicEPois+UTQTVOcbOpVKmM47q69i6K+nSsPUD8Ov6zr3TRs3dpFIjXWdTEAOmUMzd6OOYz06kPsFnOWYaHTVQOSMUjqvvwtRkFzeMhyQjRu539Gcixj2TXqJU9AhNq6tuon7LTVOXXPKZNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ra1HxOEp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ra1HxOEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C0F1F000E9;
	Tue, 21 Jul 2026 22:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672579;
	bh=ovfU5qO4vs2o8RcSdhZkTc2ueLEql4xV0sCEq4MY8B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ra1HxOEpKyb/zjuPNOmF0o0NsI1g3dg2t7EY1Y4fhCVm9nWyn8zmddbvK/1zgrOyK
	 8NF5OmqOEDfwMme5eRs8g0wkytyohDR1v3I4YOBuxoUPFYy0DG5Z9TIfsPNbxxo9Kz
	 PrScbQdv0xKZiolK1Cz1/Plthd/zCiUE5yoccqK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 5.15 676/843] cpu: hotplug: Preserve per instance callback errors
Date: Tue, 21 Jul 2026 17:25:11 +0200
Message-ID: <20260721152421.266153388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -171,7 +171,7 @@ static int cpuhp_invoke_callback(unsigne
 	struct cpuhp_step *step = cpuhp_get_step(state);
 	int (*cbm)(unsigned int cpu, struct hlist_node *node);
 	int (*cb)(unsigned int cpu);
-	int ret, cnt;
+	int ret, cnt, rollback_ret;
 
 	if (st->fail == state) {
 		st->fail = CPUHP_INVALID;
@@ -235,12 +235,12 @@ err:
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


