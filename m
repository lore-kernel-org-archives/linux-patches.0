Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B1F412294;
	Fri,  4 Sep 2026 05:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500434; cv=none; b=Wb1Jpg5uN0HaKc7pewImBM9BrhWD8ZCOKbUroWO5spAMNdRrw99U7H1NAPOZXp51jR037hrHOWVL1DH5GorkZDYEEZvyz5w2ud6sP63UryaPH3M6H55x/THUmDsAq+dvam9kHOZtaPgJ4hYGhd1+TcmHghtcngnSmrbIg9JprY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500434; c=relaxed/simple;
	bh=C81G8wiVXtcMwH6qplELhaV0lvbclAyDoDjYVsVeAws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2ql06SmNscjYasaS8GuUl34KqlHPcdbVAlZ1Kv5iGw9GBFMySA8bbn0HaMyILwKSzkUKXLeqBy6AX5k9Fqdoq1ZX39CM6CcXqR81wriIHWUmhZekQTBUIPUgZKpXSnZV26IJqVrbgncma0werAspE7cAlQ6JYP+57FukYnujBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/jGpc9a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/jGpc9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34A11F00A3D;
	Fri,  4 Sep 2026 05:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500433;
	bh=uBj6XaSFJd2eDhTN5VJfUBlbPKOrdXT8dqkjaAUl13g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D/jGpc9aONYYt5BZNb2vbwrUiSpn56XXwHL8PXrI9W0R9xV1RrkpNhE7kknmAtrz+
	 947NQeZEFoaTpKgJfWMZYbCGzYw/nq3qiEHLijNrHIHC9Fhns8wCr5YXA0izWXQmRK
	 rSkPDg7FFYYY4fdi3fF+GcQdNGuJNgFwJ2PfbcKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <me@ziyao.cc>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.18 054/552] x86/locking: Use sfence for wmb() if SSE is available
Date: Fri,  4 Sep 2026 06:53:31 +0200
Message-ID: <20260904045749.065640413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Yao Zi <me@ziyao.cc>

commit d824ed1307680dd482f607b0e707c575f70668c4 upstream.

When adding cc clobber to wmb()'s definition, the alternative()
condition to use sfence was incorrectly raised from X86_FEATURE_XMM to
X86_FEATURE_XMM2.

Restore the correct constraint for potential better performance on
machines without SSE2.

Fixes: bd922477d935 ("locking/x86: Add cc clobber for ADDL")
Signed-off-by: Yao Zi <me@ziyao.cc>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260801182953.15069-1-me@ziyao.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/barrier.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -17,7 +17,7 @@
 #define rmb() asm volatile(ALTERNATIVE("lock addl $0,-4(%%esp)", "lfence", \
 				       X86_FEATURE_XMM2) ::: "memory", "cc")
 #define wmb() asm volatile(ALTERNATIVE("lock addl $0,-4(%%esp)", "sfence", \
-				       X86_FEATURE_XMM2) ::: "memory", "cc")
+				       X86_FEATURE_XMM) ::: "memory", "cc")
 #else
 #define __mb()	asm volatile("mfence":::"memory")
 #define __rmb()	asm volatile("lfence":::"memory")


