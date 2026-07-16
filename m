Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3691400973;
	Thu, 16 Jul 2026 14:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210414; cv=none; b=fhvsFTwT/qEjqYzUjxeTwqCePhHKbtHsG41V0fBujAnGkKTrJH/EVaFNJSngA0vnopjYNMzs+WZ6xD/Iz1Bws4da6Re8+mOXzKf087JLVg94phL6so2g9vlw5HfqiPijI/8Ttj5vpXN5Lhfqp+MNF9VmzbUztP2cGDujwK346RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210414; c=relaxed/simple;
	bh=HlItblnNQ4MIF60u/uCAS9Jo02rkYcsuNuTYDRQZCgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTmaDfK38C2bBZhCSHBFHQJqlUpMMf2ogcD6qlahVAwIn/TZDA3rwG7a9GYMmjynNkbcv3/M5ubNQW6S1hK68HyD8GlWtdXqTJfJe+8IaTahaQpsP63/vTwtCjQ3NGaKw312MOaOlCd8VrrrcB1jhAI6MzGmk3t5Y2kgrOHnE/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZLfAx1+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZLfAx1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E9C1F000E9;
	Thu, 16 Jul 2026 14:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210413;
	bh=YNMhqzGjjf9gds7VTjz7EKauIBvKs4+BXfu01MzB3iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZLfAx1+eBdG31FRGWYYFOtBbk3rLEC7tXa8nTPXFbVtp7bdbnw3nXhnTyIXiKeES
	 F/nFAt8KP3ZVsVwXHvTlyXXqmL7/9KljxLiv/DU7bXvRffngniIqhdYdzF9YoNjmc7
	 IbV/mENthwCBQL+4C7proFciLTpy34NCu3ri01X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Gary Guo <gary@garyguo.net>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 037/480] rust: cpufreq: clean new `clippy::map_or_identity` lint for Rust 1.98.0
Date: Thu, 16 Jul 2026 15:26:24 +0200
Message-ID: <20260716133045.503461247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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


