Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380B23F0A94;
	Fri,  7 Aug 2026 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116664; cv=none; b=bOhuNdtPxXND0JVQ3eY/JOEvvFu4/6+on8CHxJyG+6h5Tzec0+ETI+VTfhNspD5yq6KjdLTEyqIDYgTp559mDe0cRRJRi+rE5J0Edbo/dPioU83yA9evEOd6YlrfekKdykC3toYe1vJsvyVj90u9alnArqb+Lk/mCPJFgATJxpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116664; c=relaxed/simple;
	bh=4R6D5IYA75KWDJF2E9xsk53H6V0raZXZ948cfwBZWAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CxL/J1nIUdgdPgRMMjqypt8xFCLY4mog9omRTSiZxJKzBtBE5UL5m7JoQ17i/S0+WlMWWjsL8zroR/DUkH8urFnYgCvOtCeNm9TabN/T6+XRAyOzRBaBe++akR+jgFh5n7t3s3oiAgELnno5OaoxsdZSaeb0O27kBDgL/ckqpXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBJa8tra; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBJa8tra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4117C1F000E9;
	Fri,  7 Aug 2026 15:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116662;
	bh=bJ6HnK/3Clsr8tnOf9EpzsDgWLXVFp+eeO0atwE9u9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dBJa8tra+3qsZidVKAJqgR4T7vE7LlK1Ppfb5BwdFEPC953Rlodq1G1ChK4/pkX6m
	 pg5seaFnt1zt99ae+//ztl+29vR5TvnmdrANqI6TJwiUkLEVcxQIKyoeCrhhgJ8nY5
	 eQUzm9yYd7KTBV0BdrmJOKSjq3HGoC7pJy0JJgRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH 7.1 047/438] KVM: arm64: Fix hyp_trace clock disabling
Date: Fri,  7 Aug 2026 16:34:03 +0200
Message-ID: <20260807143428.998358135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit bbece712cfc7f286b2908ac120dcf700279d87eb ]

Fix the disable path in hyp_trace_clock_enable(), which fell through to
re-initialize and reschedule the clock after cancelling the work. Return
early instead.

While at it, cleanup hyp_trace_clock::lock which is unused and
hyp_trace_clock::running which is redundant: the trace_remote framework
already serializes calls to the callback enable_tracing.

Fixes: b22888917fa4 ("KVM: arm64: Sync boot clock with the nVHE/pKVM hyp")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev> (✓ DKIM/linux.dev)
Link: https://patch.msgid.link/20260715105100.3178255-1-vdonnefort@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp_trace.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index c4b3ee5521313..ac6a2db317323 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -37,8 +37,6 @@ static struct hyp_trace_clock {
 	u32			shift;
 	struct delayed_work	work;
 	struct completion	ready;
-	struct mutex		lock;
-	bool			running;
 } hyp_clock;
 
 static void __hyp_clock_work(struct work_struct *work)
@@ -110,12 +108,9 @@ static void hyp_trace_clock_enable(struct hyp_trace_clock *hyp_clock, bool enabl
 {
 	struct system_time_snapshot snap;
 
-	if (hyp_clock->running == enable)
-		return;
-
 	if (!enable) {
 		cancel_delayed_work_sync(&hyp_clock->work);
-		hyp_clock->running = false;
+		return;
 	}
 
 	ktime_get_snapshot(&snap);
@@ -128,7 +123,6 @@ static void hyp_trace_clock_enable(struct hyp_trace_clock *hyp_clock, bool enabl
 	INIT_DELAYED_WORK(&hyp_clock->work, __hyp_clock_work);
 	schedule_delayed_work(&hyp_clock->work, msecs_to_jiffies(CLOCK_INIT_MS));
 	wait_for_completion(&hyp_clock->ready);
-	hyp_clock->running = true;
 }
 
 /* Access to this struct within the trace_remote_callbacks are protected by the trace_remote lock */
@@ -304,9 +298,15 @@ static void hyp_trace_unload(struct trace_buffer_desc *desc, void *priv)
 
 static int hyp_trace_enable_tracing(bool enable, void *priv)
 {
+	int ret;
+
 	hyp_trace_clock_enable(&hyp_clock, enable);
 
-	return kvm_call_hyp_nvhe(__tracing_enable, enable);
+	ret = kvm_call_hyp_nvhe(__tracing_enable, enable);
+	if (ret)
+		hyp_trace_clock_enable(&hyp_clock, !enable);
+
+	return ret;
 }
 
 static int hyp_trace_swap_reader_page(unsigned int cpu, void *priv)
-- 
2.53.0



