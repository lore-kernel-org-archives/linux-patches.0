Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4723546EF8D;
	Wed, 30 Sep 2026 18:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793402; cv=none; b=mAvK8t7x3yDG7T0uYMLi68i9Iphk+wQGpLnRwwHM1Mtm458gYHmZbHhiJb6lTaSoOf3l/4c5ZoZz30hySijw/7VqiKsXGwEWEiwnzjIJu96EoaQXJ35T1fAPh/bEOb1QASh4Nztxo9t0JkkuOtCar2sHLJ6QLmyN+DYp8micIhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793402; c=relaxed/simple;
	bh=nfRG5xXUFIt4vz6KeHb99bBC5gcGr5fBjKnuhPzkvAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aqsd9X8bR2w6dS59mHkBNzAkl9k8ItUXVAH1CCzn4YAFDIoVTWHx90rrp8js7M8BJoI6yaTdMXRUuEdvfjds1ThmhOikwS3P7df+nCFipIF7TTIC/AVLKWkMZVrKDIC1wN2z7fErkullcjc5O2KehdL4Jr4Pf4aMV2usAZtCxko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vT2OqoRY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vT2OqoRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A115E1F000FF;
	Wed, 30 Sep 2026 18:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793401;
	bh=T5bjjLTcFxQ1FzMjSMSba5hWlt4JRKh/ykf1jmQkQHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vT2OqoRYIpe/ku4eNRq3sGXTdtIP44In/JbBH/Pp9X1oyXKzPz7FuAyju0Nl+crko
	 CSbweHjkx7vRbwaIfG37KvbmoYpwXOiZyTg3u2rlk/6ZTWLYNihsM+rgdb4mMZSUZB
	 eNTEtDIIMdr5iLUvQl7bID9Solr62gAdDeJWQSSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Lipski <ivan.lipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 242/395] drm/amd/display: Bump frame warning limit for clang builds of dml
Date: Wed, 30 Sep 2026 17:28:24 +0200
Message-ID: <20260930152345.905256063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Ivan Lipski <ivan.lipski@amd.com>

commit 18779dd84515db093fedb4ebaf0998c9b165a5fb upstream.

[Why&How]
When building the DML files with clang without any sanitizer or LTO,
the following -Wframe-larger-than errors break the build under
CONFIG_WERROR:

  display_mode_vba_30.c: error: stack frame size (2512) exceeds limit
    (2048) in 'dml30_ModeSupportAndSystemConfigurationFull'
  display_mode_vba_31.c: error: stack frame size (2416) exceeds limit
    (2048) in 'dml31_ModeSupportAndSystemConfigurationFull'
  display_mode_vba_314.c: error: stack frame size (2392) exceeds limit
    (2048) in 'dml314_ModeSupportAndSystemConfigurationFull'

Clang consistently spills more than gcc, pushing the frame past the 2048
byte limit.

Apply an existing approach of increasing the warn stack size to the
non-sanitizer path so plain clang builds use a 3072 byte limit.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5642
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 21711b6e66bb7b41b1aec67b2d99aafe768c8fcb)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -36,7 +36,11 @@ ifneq ($(CONFIG_FRAME_WARN),0)
             frame_warn_limit := 3072
         endif
     else
-        frame_warn_limit := 2048
+        ifeq ($(CONFIG_CC_IS_CLANG),y)
+            frame_warn_limit := 3072
+        else
+            frame_warn_limit := 2048
+        endif
     endif
 
     ifeq ($(call test-lt, $(CONFIG_FRAME_WARN), $(frame_warn_limit)),y)


