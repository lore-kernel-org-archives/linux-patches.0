Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD2533C198;
	Sat, 12 Sep 2026 10:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209999; cv=none; b=NpolGwCmcUYuEW2BbpTWR9U52w5ALu5ddmOa1HhsE4xgcxlwENW7Q2BntiNo41d8qyyKDOkQ+rMtDG1gr7Pw620JJvX3TeTH8wUXTS1woJSTe1RoTp4h6YtJYOd2YCML/AByrEcmdv2PbBXOemOPIkC7NQuxYjvHrc6ML+TPKR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209999; c=relaxed/simple;
	bh=jneC2SATkoMvf8RmB2Qe109ZImxMi+QvkxCZMZTD4cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtl996ZYHRijxa6Nytlnp2QqXW+SwrA0J5TntsXY2VU1O7Ac9rFq2rAKlxnf7IEF11hrGyqs32CyHsa9Uit9bJ1qnEViSeQ5herHs7GZzDB5FeJwASzZIoFvTW7ZxQobLz3GeKT8s819XWUNzJNqB6cp2UpM/lKvkGak7VjbDvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2QwVIt+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QwVIt+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADB31F000FF;
	Sat, 12 Sep 2026 10:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209998;
	bh=JnQL0b0+KuLp/1fdVUWPE1tJ8qRpqvXCzYlPrD1n5SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2QwVIt+0u/xGs3VOpGr0SWJRx2WZcJ/2G7g4v6TapklYrQt0KzGMHuSGXO/FRpGPP
	 kGsUCu1uXp4tGpWLN84u9Q9UfJw0XvgBEbszhIJx5OtjCjDK5UxlHlYO/MU11mFusc
	 Kw2b+/7uKflUBjQ6m787OUwQECqlRsUiRRfo/OXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Zueck <dzueck@uci.edu>,
	Yuan Tan <ytan089@ucr.edu>,
	Priya Bala Govindasamy <pgovind2@uci.edu>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0919/1518] rust: cpufreq: Add CPUFREQ_TABLE_END as last table entry in TableBuilder::to_table
Date: Sat, 12 Sep 2026 08:51:28 +0200
Message-ID: <20260912065644.239454629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Priya Bala Govindasamy <pgovind2@uci.edu>

[ Upstream commit b5e4771f20a37fdf19eac0824bf062dffb4e291f ]

The `TableBuilder::to_table` function adds `Hertz(c_ulong::MAX).as_khz()`
as the last frequency entry in the frequency table.
But the C API expects the last entry to have frequency set to
`CPUFREQ_TABLE_END` which is `~1u` as per include/linux/cpufreq.h.

Fix this by setting the last frequency entry to `CPUFREQ_TABLE_END`
instead of `Hertz(c_ulong::MAX).as_khz()`.

Fixes: 2207856ff0bc8d953d6e89bda70b8978c2de8bab ("rust: cpufreq: Add initial abstractions for cpufreq framework")
Reported-by: Dylan Zueck<dzueck@uci.edu>
Reported-by: Yuan Tan<ytan089@ucr.edu>
Assisted-by: ChatGPT:gpt-5.6-terra
Signed-off-by: Priya Bala Govindasamy<pgovind2@uci.edu>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/cpufreq.rs | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/cpufreq.rs b/rust/kernel/cpufreq.rs
index a509d09ca4523..ccf22811c9f6c 100644
--- a/rust/kernel/cpufreq.rs
+++ b/rust/kernel/cpufreq.rs
@@ -361,23 +361,28 @@ impl TableBuilder {
         }
     }
 
-    /// Adds a new entry to the table.
-    pub fn add(&mut self, freq: Hertz, flags: u32, driver_data: u32) -> Result {
+    /// Adds a raw frequency-table entry.
+    fn push(&mut self, frequency: u32, flags: u32, driver_data: u32) -> Result {
         // Adds the new entry at the end of the vector.
         Ok(self.entries.push(
             bindings::cpufreq_frequency_table {
                 flags,
                 driver_data,
-                frequency: freq.as_khz() as u32,
+                frequency,
             },
             GFP_KERNEL,
         )?)
     }
 
+    /// Adds a new entry to the table.
+    pub fn add(&mut self, freq: Hertz, flags: u32, driver_data: u32) -> Result {
+        self.push(freq.as_khz() as u32, flags, driver_data)
+    }
+
     /// Consumes the [`TableBuilder`] and returns [`TableBox`].
     pub fn to_table(mut self) -> Result<TableBox> {
         // Add last entry to the table.
-        self.add(Hertz(c_ulong::MAX), 0, 0)?;
+        self.push(bindings::CPUFREQ_TABLE_END as u32, 0, 0)?;
 
         TableBox::new(self.entries)
     }
-- 
2.53.0



