Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B0D3D6CC2;
	Fri, 24 Apr 2026 13:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037547; cv=none; b=l02o5vlPEFXk3wfxbh+l7/j4ky7QFbObmb01YaPRsU0QOgg44N4bqerA6jj+GsTwg6e6+fl6eNJWoRKLlI6AVI9zDrM5PFGcSoDKRXvJ7TqRoOBrg10Kw63co24yaSsJKGPQFYuie+aqL8ZSvjXXDNI0xS3erXd6pWXqIHyKcd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037547; c=relaxed/simple;
	bh=bmMF0PxciaZMfnlDWjao9Xmw33ya6ol9CqplpYcwbac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=buuIa+Hjq+/UHUbzDwvcumzdDyRkhVk+X6vHXnAaZ+154o8DgmGDIYNYraha94fZ++NFon+p9RPtPhGjDkgiEhq6fro/69+3sF19h2pvJPQ3X4eaRBDWw3RdIUVsABN5XwoS3gDWCZ/2+D1p/Z7kCrXzY9m6Sk/v4DTeIo+aWN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spqTXqBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spqTXqBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6DAC2BCB6;
	Fri, 24 Apr 2026 13:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037546;
	bh=bmMF0PxciaZMfnlDWjao9Xmw33ya6ol9CqplpYcwbac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spqTXqBWZjD7vLnAyrL884+3vAWV7WWRtC1VqMFRDWXbnk61XrhoaMHCgau+AS1FM
	 IBbskFT9KjlxT+sfMKg28lvHlu1h6olDNMK4db1lwUMrL/MXJLuFCGLrkoOgTfK1a4
	 0xB2tOv1qCFWWZZaZIWMeA02ADgRRX1040nyQ+3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Michal Wilczynski <m.wilczynski@samsung.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 02/42] pwm: th1520: fix `CLIPPY=1` warning
Date: Fri, 24 Apr 2026 15:30:27 +0200
Message-ID: <20260424132420.891656628@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit aa8f35172ab66c57d4355a8c4e28d05b44c938e3 ]

The Rust kernel code should be kept `CLIPPY=1`-clean [1].

Clippy reports:

    error: this pattern reimplements `Option::unwrap_or`
      --> drivers/pwm/pwm_th1520.rs:64:5
       |
    64 | /     (match ns.checked_mul(rate_hz) {
    65 | |         Some(product) => product,
    66 | |         None => u64::MAX,
    67 | |     }) / NSEC_PER_SEC_U64
       | |______^ help: replace with: `ns.checked_mul(rate_hz).unwrap_or(u64::MAX)`
       |
       = help: for further information visit https://rust-lang.github.io/rust-clippy/rust-1.92.0/index.html#manual_unwrap_or
       = note: `-D clippy::manual-unwrap-or` implied by `-D warnings`
       = help: to override `-D warnings` add `#[allow(clippy::manual_unwrap_or)]`

Applying the suggestion then triggers:

    error: manual saturating arithmetic
      --> drivers/pwm/pwm_th1520.rs:64:5
       |
    64 |     ns.checked_mul(rate_hz).unwrap_or(u64::MAX) / NSEC_PER_SEC_U64
       |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ help: consider using `saturating_mul`: `ns.saturating_mul(rate_hz)`
       |
       = help: for further information visit https://rust-lang.github.io/rust-clippy/rust-1.92.0/index.html#manual_saturating_arithmetic
       = note: `-D clippy::manual-saturating-arithmetic` implied by `-D warnings`
       = help: to override `-D warnings` add `#[allow(clippy::manual_saturating_arithmetic)]`

Thus fix it by using saturating arithmetic, which simplifies the code
as well.

Link: https://rust-for-linux.com/contributing#submit-checklist-addendum [1]
Fixes: e03724aac758 ("pwm: Add Rust driver for T-HEAD TH1520 SoC")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Michal Wilczynski <m.wilczynski@samsung.com>
Link: https://patch.msgid.link/20260121183719.71659-1-ojeda@kernel.org
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm_th1520.rs | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/pwm/pwm_th1520.rs b/drivers/pwm/pwm_th1520.rs
index b0e24ee724e45..36567fc17dcc8 100644
--- a/drivers/pwm/pwm_th1520.rs
+++ b/drivers/pwm/pwm_th1520.rs
@@ -64,10 +64,7 @@ const fn th1520_pwm_fp(n: u32) -> usize {
 fn ns_to_cycles(ns: u64, rate_hz: u64) -> u64 {
     const NSEC_PER_SEC_U64: u64 = time::NSEC_PER_SEC as u64;
 
-    (match ns.checked_mul(rate_hz) {
-        Some(product) => product,
-        None => u64::MAX,
-    }) / NSEC_PER_SEC_U64
+    ns.saturating_mul(rate_hz) / NSEC_PER_SEC_U64
 }
 
 fn cycles_to_ns(cycles: u64, rate_hz: u64) -> u64 {
-- 
2.53.0



