Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E871D2784;
	Wed,  6 Nov 2024 12:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896021; cv=none; b=nEUWcMbj6zSBUyXfNVHWwEUvoXYvBXtpFhlE3eeyfTweVv1Zhti+GPOIRNnI79PY54ztjYTFrcbhtBd3WqOww0p54isERgQEHu8MujKRR8E8tNDA7srIwyLnbl2NPYL3IMxjwXU1jsSxSfiWvoWIBQ8qRhrmejrg/EdClfNNImQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896021; c=relaxed/simple;
	bh=tuKrpcj7ZGjgh/hfz7LPmqu5VBDDwidoOS+zIDgdeUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdp7/FfF8Meo/LzBpEiy/uR68MVerzW8g9wh5Oh8tIHKEe7QQ72GT72iy5kJ4vNh5My4t6gxSGXR8Adh8VMf9GOWzUMgVqN7R4Ti3BcViJ1Q9TP7T+AVf23w5IKtAmkHAYR9o91xQqdaC4bUnBuqD1giAbh8FOXmCb7e3kCGahM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KH+cybDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KH+cybDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281E4C4CECD;
	Wed,  6 Nov 2024 12:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896021;
	bh=tuKrpcj7ZGjgh/hfz7LPmqu5VBDDwidoOS+zIDgdeUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KH+cybDrmocV6Tk75vZIJpxzDJqhrz1aWaDF+EgUPiS/QtLwfesPHTa5IVSZYmAa1
	 C3KStZ9ajqlm/0/73mrWPldXgGzZtfVHgpDOHXQFjMMVE+zc1bSsHkCpZX3pMNa/SB
	 AX+1WPgnkvPXKhVabDMEJ30t/5DBlH5EyIypyc4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+908886656a02769af987@syzkaller.appspotmail.com,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrew Pinski <pinskia@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 063/245] kasan: Fix Software Tag-Based KASAN with GCC
Date: Wed,  6 Nov 2024 13:01:56 +0100
Message-ID: <20241106120320.756228876@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Elver <elver@google.com>

[ Upstream commit 894b00a3350c560990638bdf89bdf1f3d5491950 ]

Per [1], -fsanitize=kernel-hwaddress with GCC currently does not disable
instrumentation in functions with __attribute__((no_sanitize_address)).

However, __attribute__((no_sanitize("hwaddress"))) does correctly
disable instrumentation. Use it instead.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=117196 [1]
Link: https://lore.kernel.org/r/000000000000f362e80620e27859@google.com
Link: https://lore.kernel.org/r/ZvFGwKfoC4yVjN_X@J2N7QTR9R3
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218854
Reported-by: syzbot+908886656a02769af987@syzkaller.appspotmail.com
Tested-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrew Pinski <pinskia@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Fixes: 7b861a53e46b ("kasan: Bump required compiler version")
Link: https://lore.kernel.org/r/20241021120013.3209481-1-elver@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler-gcc.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index f805adaa316e9..cd6f9aae311fc 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -80,7 +80,11 @@
 #define __noscs __attribute__((__no_sanitize__("shadow-call-stack")))
 #endif
 
+#ifdef __SANITIZE_HWADDRESS__
+#define __no_sanitize_address __attribute__((__no_sanitize__("hwaddress")))
+#else
 #define __no_sanitize_address __attribute__((__no_sanitize_address__))
+#endif
 
 #if defined(__SANITIZE_THREAD__)
 #define __no_sanitize_thread __attribute__((__no_sanitize_thread__))
-- 
2.43.0



