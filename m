Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C398271464;
	Sat, 12 Sep 2026 08:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202134; cv=none; b=SsTuXbJ8udwFPmEd1NXD6p3htfhF1l4cVWTim620E0D2iVDb+I+h2UB0fIKQ/uK2YOroOA/Z8Ria9zRE7KZK1wKsAjyly8obmJ7Jg5zbPfeeUzf6il//a9DjpdiK17pJb6Ecdz5gBSOwet2Z3DyMm6RGMBLqJIyaocnGIf3inss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202134; c=relaxed/simple;
	bh=GXlqTflvjGATgYXy6GGskhpgys4ULs8H6Pt2/bZ/Xb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRSEIdg/MkH9rnDdqsNZs2gxfVUQ7HaqLPqnmjr4OhdJMDcSqkIEj3t1QgBMYmmVwgzWFMfoA2UBMzhvBhDx1NT/aZ1aOHbXvt4uJ0psxzldFGXibMStIJ/uWwglmaiJQLw8TuE93DgzY8HUtJnMDVKFv3GiELx1PbPO2Oc4Grg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUGg+pHx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUGg+pHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D301F000FF;
	Sat, 12 Sep 2026 08:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202132;
	bh=KFg9vqH6iWZVRku89CvZ+6K0ESX50+Vvoni+XceNlS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUGg+pHxsQpHz7uqkrXDzUqA6lT+x+ZcHqvFihRvaptU7WcUCZ3xhTHS/r2aQhy7P
	 LiIusNFkWaMFYv8ozC4yTDwXSR2xZ8/dfIGC6XBSHWGY9GOWf8Pvmwqd/coxK99ZCl
	 yEK1DZL2jH74uZPx32i/FBnjm99N7OrHhw3NmdmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Zueck <dzueck@uci.edu>,
	Yuan Tan <ytan089@ucr.edu>,
	Priya Bala Govindasamy <pgovind2@uci.edu>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1138/1815] rust: cpufreq: Fix temporary write in Registration::bios_limit_callback
Date: Sat, 12 Sep 2026 08:48:08 +0200
Message-ID: <20260912065715.735876596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Priya Bala Govindasamy <pgovind2@uci.edu>

[ Upstream commit 19c76bdd3fc02475c73c8576f6f4a55ff07886f1 ]

In `Registration::bios_limit_callback`, the expression
`&mut (unsafe { *limit })` creates a reference to a temporary copy
of the value pointed to by `limit` on the stack.
Therefore, writes made by `T::bios_limit` go to this temporary
instead of the memory location pointed to by `limit`.

Additionally, `limit` may be uninitialized, such as when
`Registration::bios_limit_callback` is invoked by `show_bios_limit`
in drivers/cpufreq/cpufreq.c. Therefore creating a reference to
`limit` is unsound.

Fix this by changing the signature of `T::bios_limit` to return the limit
value.
`Registration::bios_limit_callback` can then update `limit` directly.

Fixes: c6af9a1191d042839e56abff69e8b0302d117988 ("rust: cpufreq: Extend abstractions for driver registration")
Reported-by: Dylan Zueck<dzueck@uci.edu>
Reported-by: Yuan Tan<ytan089@ucr.edu>
Assisted-by: ChatGPT:gpt-5.4
Signed-off-by: Priya Bala Govindasamy<pgovind2@uci.edu>
[ Viresh: Fix rustfmtcheck warning ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/cpufreq.rs | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/cpufreq.rs b/rust/kernel/cpufreq.rs
index f360eb9578f32..1158ef3a85f2f 100644
--- a/rust/kernel/cpufreq.rs
+++ b/rust/kernel/cpufreq.rs
@@ -822,7 +822,9 @@ pub trait Driver {
     }
 
     /// Driver's `bios_limit` callback.
-    fn bios_limit(_policy: &mut Policy, _limit: &mut u32) -> Result {
+    ///
+    /// Returns HW/BIOS max frequency limitations for the CPU.
+    fn bios_limit(_policy: &mut Policy) -> Result<u32> {
         build_error!(VTABLE_DEFAULT_ERROR)
     }
 
@@ -1357,9 +1359,12 @@ impl<T: Driver> Registration<T> {
 
         from_result(|| {
             let mut policy = PolicyCpu::from_cpu(cpu_id)?;
-
+            let val = T::bios_limit(&mut policy)?;
             // SAFETY: `limit` is guaranteed by the C code to be valid.
-            T::bios_limit(&mut policy, &mut (unsafe { *limit })).map(|()| 0)
+            unsafe {
+                *limit = val;
+            }
+            Ok(0)
         })
     }
 
-- 
2.53.0



