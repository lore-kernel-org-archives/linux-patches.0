Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C7741F7D5;
	Thu, 16 Jul 2026 13:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208991; cv=none; b=WnHAHpJRgdYWeaqxc35FyuPEmObHOtopoDvfc6DCX8g0KpG7kaNTXE2JaM2kvUaxt6t3a4GVllNG0WTTAKpZUvQ5B/DLxwdWrTfelSKJhaQmj48k7yGFsUrJ/SlLLUzsTYO95LyJ/c/9zM/SdQecFMq0EjA2euCr3l4ONeZmHU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208991; c=relaxed/simple;
	bh=8MHRpwezBIXIICCFOL7+P3hLSTbBErHsDDcZWuErmdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3aqa21exQjAcn9GvKNxnMZH1NrP9me+qzrF+7DeG4x7feiO7P2X/SQdBRjTXOmQI+pweei7MOGl3hOGlBe8NnYwCf9s1ldMKB1JGUiyHqswKj3m+hHz0evMWgDEbr1crN/2mHRiMH28/erW3GBI2kbbjtDLNeGrby5RtJikQq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmJYILjo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmJYILjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114A91F000E9;
	Thu, 16 Jul 2026 13:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784208989;
	bh=1c4lhQGadjnlWz+/S4cWQF9FtHrKZAXS1uu0fFuzYR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VmJYILjoqQaqpqIVisTL9PSwFfuMtx4x3NNoTgRziDriRTM+Bw15sCXSDCgxrtNeY
	 9zujopgrzYirKtHgVdtGC+mZ0+Fz1v8TLSHsRcekyS0XJFGYOhzKnCwwXmAwDvzSWt
	 qukiXITSMiKOR5WmSkcOzSHY1aG6+ADAaCyGt36c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Gary Guo <gary@garyguo.net>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.1 016/518] rust: cpufreq: clean new `clippy::map_or_identity` lint for Rust 1.98.0
Date: Thu, 16 Jul 2026 15:24:44 +0200
Message-ID: <20260716133048.132006117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Miguel Ojeda <ojeda@kernel.org>

commit 3473e0a219fdb2cb013da0a5d917e66fef052325 upstream.

Starting with Rust 1.98.0 (expected 2026-08-20), Clippy is likely
introducing a new lint `clippy::map_or_identity` [1][2], which currently
triggers in a single case:

    warning: expression can be simplified using `Result::unwrap_or()`
        --> rust/kernel/cpufreq.rs:1326:60
         |
    1326 |         PolicyCpu::from_cpu(cpu_id).map_or(0, |mut policy| T::get(&mut policy).map_or(0, |f| f))
         |                                                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
         |
         = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#map_or_identity
         = note: `-W clippy::map-or-identity` implied by `-W clippy::all`
         = help: to override `-W clippy::all` add `#[allow(clippy::map_or_identity)]`
    help: consider using `unwrap_or`
         |
    1326 -         PolicyCpu::from_cpu(cpu_id).map_or(0, |mut policy| T::get(&mut policy).map_or(0, |f| f))
    1326 +         PolicyCpu::from_cpu(cpu_id).map_or(0, |mut policy| T::get(&mut policy).unwrap_or(0))
         |

The suggestion is valid, thus clean it up.

Cc: stable@vger.kernel.org # Needed in 6.18.y and later.
Link: https://github.com/rust-lang/rust-clippy/issues/15801 [1]
Link: https://github.com/rust-lang/rust-clippy/pull/16052 [2]
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/20260530095809.213611-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/cpufreq.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/cpufreq.rs
+++ b/rust/kernel/cpufreq.rs
@@ -1323,7 +1323,7 @@ impl<T: Driver> Registration<T> {
         // SAFETY: The C API guarantees that `cpu` refers to a valid CPU number.
         let cpu_id = unsafe { CpuId::from_u32_unchecked(cpu) };
 
-        PolicyCpu::from_cpu(cpu_id).map_or(0, |mut policy| T::get(&mut policy).map_or(0, |f| f))
+        PolicyCpu::from_cpu(cpu_id).map_or(0, |mut policy| T::get(&mut policy).unwrap_or(0))
     }
 
     /// Driver's `update_limit` callback.


