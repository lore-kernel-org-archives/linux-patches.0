Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6204F19004A;
	Sat, 14 Feb 2026 01:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031095; cv=none; b=ozZf05fh9LvMaNPj2o60j9wpTIl+7RJ4Uc/Y/8lGsBbt9x2nH5zhr/03REOszfEdJPljfIuSMOM2F3wyxwsct6Qc937ylkrHCUp7qfZvOchX2IxZk7qOQB/vDWiQc4o2uxkl4T7GqYURoPWe711tUzTaOXRw/ZZW0ooIbF9FS1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031095; c=relaxed/simple;
	bh=K0RHdhb85AGX3NTk3JN8BCHnVTm2XLyO2NxEyhx2MrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bh0VrAld302DtEnkWy/E4DmaJ+yJMss6v+AZE9XpUqb9sHxxQNNKnhENrExVMpYoulPo6i6HT4PvEfHsHjv34Sieh+pEAUL85drK46acibYBVP6OG3/Od6G39MlrI5xx5RN5Rw8mU2/Sw/F0WbhwZZnAM2JJwXpDgUJFNDdz2t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtNLGchE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtNLGchE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A848C16AAE;
	Sat, 14 Feb 2026 01:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031095;
	bh=K0RHdhb85AGX3NTk3JN8BCHnVTm2XLyO2NxEyhx2MrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtNLGchEDT/k8TJGpB+GUrzqE/+TEFigkHYtpSQywEP1pyrkl8mLvKjhz1BOyrSvh
	 p2nk545VRGdL9fSTfXmOs1bpxVlcr5FUI9w3bW24QgA2M4jUKIcJNElmr34RHn+gyo
	 ozhNnDWavXTCkqQ0oRE3y92t9yxArOzKE/8Tf1nwKGNz5e4Aqih/5h2dEq4XJewTzI
	 N0UU1RAEsgtjjPmK7W43jkVfaR2kA7kf+wy78Jicg0dkKHppGmRI+EKHeaVKwxrN9n
	 9iyxytVnzzgV8s8ux8jI7U/kX/K3Ir0mRPFRS4qA4xeA0PMKwcmh+pD1qDBEo2iMEp
	 mDlCryNBDru1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tuo Li <islituo@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.19-6.12] drm/panel: Fix a possible null-pointer dereference in jdi_panel_dsi_remove()
Date: Fri, 13 Feb 2026 19:58:59 -0500
Message-ID: <20260214010245.3671907-59-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tuo Li <islituo@gmail.com>

[ Upstream commit 95eed73b871111123a8b1d31cb1fce7e902e49ea ]

In jdi_panel_dsi_remove(), jdi is explicitly checked, indicating that it
may be NULL:

  if (!jdi)
    mipi_dsi_detach(dsi);

However, when jdi is NULL, the function does not return and continues by
calling jdi_panel_disable():

  err = jdi_panel_disable(&jdi->base);

Inside jdi_panel_disable(), jdi is dereferenced unconditionally, which can
lead to a NULL-pointer dereference:

  struct jdi_panel *jdi = to_panel_jdi(panel);
  backlight_disable(jdi->backlight);

To prevent such a potential NULL-pointer dereference, return early from
jdi_panel_dsi_remove() when jdi is NULL.

Signed-off-by: Tuo Li <islituo@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20251218120955.11185-1-islituo@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

The commit message is clear and well-structured. It identifies a **null
pointer dereference** in `jdi_panel_dsi_remove()`. The existing code
checks `if (!jdi)` but only calls `mipi_dsi_detach(dsi)` without
returning, so execution falls through to `jdi_panel_disable(&jdi->base)`
which dereferences the NULL `jdi` pointer. This is a classic missing-
return-after-early-check bug.

The commit has been **Reviewed-by** a subsystem maintainer (Neil
Armstrong), lending credibility.

### Code Change Analysis

The fix is extremely small and surgical — it adds braces around the
existing `if (!jdi)` block and inserts a `return;` statement:

```c
- if (!jdi)
+       if (!jdi) {
                mipi_dsi_detach(dsi);
+               return;
+       }
```

This is a textbook null-pointer dereference fix. The original code
intended to handle the `jdi == NULL` case (DSI-LINK2 interface that only
needs detach), but forgot to return early, causing the function to
continue and dereference `jdi` through `jdi_panel_disable(&jdi->base)`.

### Bug Classification

- **Type**: NULL pointer dereference
- **Trigger**: When `jdi_panel_dsi_remove()` is called for the DSI-LINK2
  interface where `mipi_dsi_get_drvdata(dsi)` returns NULL
- **Consequence**: Kernel oops/crash due to dereferencing a NULL pointer
- **Severity**: Medium-High — this is a crash in a driver removal path,
  triggered during device unbind or module unload

### Scope and Risk Assessment

- **Lines changed**: 3 lines (add braces and a `return`)
- **Files changed**: 1 file
- **Risk**: Extremely low — the fix is obviously correct and cannot
  introduce regressions. It only adds an early return when `jdi` is
  NULL, which is clearly the intended behavior given the existing NULL
  check.

### Stable Kernel Criteria

1. **Obviously correct and tested**: Yes — reviewed by subsystem
   maintainer, trivially correct
2. **Fixes a real bug**: Yes — NULL pointer dereference leading to
   kernel crash
3. **Fixes an important issue**: Yes — crash in driver removal path
4. **Small and contained**: Yes — 3 lines in a single file
5. **No new features**: Correct — pure bug fix
6. **Applies cleanly**: Likely — the change is very localized

### Dependencies

This patch is self-contained with no dependencies on other commits.

### User Impact

This affects users of the JDI LPM102A188A panel (used in some
Chromebook-style devices). When the panel's DSI link is being removed
(e.g., during driver unbind or system shutdown), the kernel would crash.
While this is a niche driver, the fix is risk-free and prevents a real
crash.

**YES**

 drivers/gpu/drm/panel/panel-jdi-lpm102a188a.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-jdi-lpm102a188a.c b/drivers/gpu/drm/panel/panel-jdi-lpm102a188a.c
index 23462065d726b..ea975170fafff 100644
--- a/drivers/gpu/drm/panel/panel-jdi-lpm102a188a.c
+++ b/drivers/gpu/drm/panel/panel-jdi-lpm102a188a.c
@@ -434,8 +434,10 @@ static void jdi_panel_dsi_remove(struct mipi_dsi_device *dsi)
 	int err;
 
 	/* only detach from host for the DSI-LINK2 interface */
-	if (!jdi)
+	if (!jdi) {
 		mipi_dsi_detach(dsi);
+		return;
+	}
 
 	err = jdi_panel_disable(&jdi->base);
 	if (err < 0)
-- 
2.51.0

