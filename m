Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704594;
	b=Iq+HCOKE2+6KklxN1HCbd+9K2KOBIIXXjOnJuSBwRJvs34UT2j0+2udcBdti5l/VxhFj
	 3/wYc028huSiD3iWV+NCWHlcVWvNHyUgHfWU58WzLzlv/qkYgFJa8hXnCFCkWMA4JYc+G
	 NICOzeS8nP8PewHMyA3xYLKUemAcSg80V7vZiAk6UVgW2CsEpM6LUMLyipll91bAm3cLg
	 fvNBH6p/pVljKGNj2HiGI6tIakF3/eK5JgNeBd9j76CX7D8Od8rnWavLYcMYlut9PYsBX
	 wKOPovZyjU9//Gnh6lhBSUiryMPk+5WMcDIAF5ZqDB3JFbDB6NNby32T7HJgl8FPHfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ExCPXbg7UVLK5Scsk4uKABkZQNnSS4OI+uXxlxfqdjA=;
	b=QR2mH09wP6ZYzUgckqWk3+x35O7CbOIQP6QUR7laH0/8yhjxQLYsK/BGbfCUW1xgAu9n
	 dToGEiJpgupqdWhKlGBJjKiWKFEsSFenBW2qm+VuyEeWMuPy8vfJtwMka8FkYNHt/S72D
	 deuleSQgVwGnESOwv49U+eltmWnaAVXHcSi6RnEyj2e4FLu7VkTuVbBSNW4I/JZ0s8UEr
	 e4Wt0LVTlhMpRG0JdOUCmcwATxV5AQEjzmBicpUIKkRDtSO/Srl9rlFJhstkYeWWoQWM3
	 Y1LbgeFTblHEDtHRyZSJ//ykuTnAi72qXc43J2d8h6q1oxKH02UJTYJkxvgQrLTI0hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9dWVIyx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F17606A321;
	Thu, 26 Nov 2026 14:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9dWVIyx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E6C1F000CA;
	Thu, 26 Nov 2026 14:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704594;
	bh=ExCPXbg7UVLK5Scsk4uKABkZQNnSS4OI+uXxlxfqdjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9dWVIyxFMeczIUNu5enuoqaJEtRRRyr7cTJGbnSwjPHwOzeBWYEm9+t8BAVzaITK
	 IaEK3cOpQqONujnbaZhZbNg3FtVIuv26bi+9kdzcrBYCPfOH7Z2b0R+PNSeW6DxrZJ
	 izHD9SrURnCewcQaeZ+9rEWc2yyztufgM97XJXQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 177/265] x86/mm: Ensure write visibility during LDT installation
Date: Thu, 26 Nov 2026 15:38:27 +0100
Message-ID: <20261126143617.556010402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave.hansen@linux.intel.com>

commit 0dc2a4dac3d04e9e4479aeb0b46172feab1cca0a upstream.

During LDT installation, the intent is to overwrite the old per-mm
LDT value, then send an IPI to the mm user CPUs to have each load
the new value.

But there is an ordering problem: a new mm user CPU sets itself in
mm_cpumask() and then reads mm->context.ldt. The LDT-installing CPU
writes mm->context.ldt and then reads mm_cpumask(). But, there is
nothing which orders the LDT installation side actions. The CPU
can read mm_cpumask() before its write becomes visible.

Ensure that new mm user CPUs see the new mm->context.ldt. Make
mm->context.ldt visible before reading mm_cpumask().

Also convert the smp_store_release() over to a WRITE_ONCE().
smp_store_release() has an internal barrier which is weaker than
the new smp_mb(). Avoid an extra barrier by converting it to
WRITE_ONCE().

Also refresh/correct misleading comments. READ/WRITE_ONCE() do not
"synchronize" anything themselves.

Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Acked-by: Linus Torvalds <torvalds@linuxfoundation.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/ldt.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -43,7 +43,7 @@ void load_mm_ldt(struct mm_struct *mm)
 {
 	struct ldt_struct *ldt;
 
-	/* READ_ONCE synchronizes with smp_store_release */
+	/* Pairs with WRITE_ONCE() in install_ldt() */
 	ldt = READ_ONCE(mm->context.ldt);
 
 	/*
@@ -414,8 +414,14 @@ static void install_ldt(struct mm_struct
 {
 	mutex_lock(&mm->context.lock);
 
-	/* Synchronizes with READ_ONCE in load_mm_ldt. */
-	smp_store_release(&mm->context.ldt, ldt);
+	/*
+	 * Ensure that new mm user CPUs either see the new LDT value
+	 * or get an IPI. Make the store visible before reading
+	 * mm_cpumask(). New mm users make their mm_cpumask() writes
+	 * visible before reading mm->context.ldt.
+	 */
+	WRITE_ONCE(mm->context.ldt, ldt);
+	smp_mb();
 
 	/* Activate the LDT for all CPUs using currents mm. */
 	on_each_cpu_mask(mm_cpumask(mm), flush_ldt, mm, true);


