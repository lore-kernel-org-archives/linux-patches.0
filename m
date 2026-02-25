Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8634369A;
	Wed, 25 Feb 2026 01:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982891; cv=none; b=Fw5yeEteUrtQdQGb2UR+2U0P3BntjZnXe+Z4WDlwMgJdSokv8HNy1v5xPs+J/+Eh3lL5F7AONzOP5S9Q25OvfDMTPrAcYszfWCKowafRRu4OiNVZdgyflWwpkMyKHDHX5E7paNtT+HXnbBRmLHd/9cPCy7PgRstF7Mzk+5pR4MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982891; c=relaxed/simple;
	bh=hUCHvvJz0r+uBbusOfnCOaE4hdicPWzmg3XqHCyx7dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A65koapH9Rgb3Vh39Et1R/b3Z+/tIjnEGmFh7QmBqtPNVDh64Rsjnk1vbAX5uUSBUxMAzCFPOgLP4EwxI5LQRxWRndn8DfqNTEkRboeuKrhjN5xUzF6fYXa0WwbtRCVnd9f1PJa+9pXdXPDLIbKzLnA0qwJuFYeBUm8HNxXjb78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYiQlZpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYiQlZpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDC3C116D0;
	Wed, 25 Feb 2026 01:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982891;
	bh=hUCHvvJz0r+uBbusOfnCOaE4hdicPWzmg3XqHCyx7dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYiQlZpb1LxjxzmrywgkINnFwsON1KVi6RsBPTRH2VbZzVHy/taoAcKCGbyyQG/cm
	 KDh51yvz2N/RP8QATz4KF137miEyXAjDw0LWj306vP7XKOupF81PxKG9v84ZpUwljG
	 MRE5UzWzbEls+qqhaI3BPRUZ/tU4ubGpzmn4O3v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 076/781] ARM: VDSO: Patch out __vdso_clock_getres() if unavailable
Date: Tue, 24 Feb 2026 17:13:05 -0800
Message-ID: <20260225012401.567789224@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit b9fecf0dddfc55cd7d02b0011494da3c613f7cde ]

The vDSO code hides symbols which are non-functional.
__vdso_clock_getres() was not added to this list when it got introduced.

Fixes: 052e76a31b4a ("ARM: 8931/1: Add clock_getres entry point")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20251223-vdso-compat-time32-v1-6-97ea7a06a543@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/vdso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kernel/vdso.c b/arch/arm/kernel/vdso.c
index e38a30477f3d7..566c40f0f7c77 100644
--- a/arch/arm/kernel/vdso.c
+++ b/arch/arm/kernel/vdso.c
@@ -161,6 +161,7 @@ static void __init patch_vdso(void *ehdr)
 		vdso_nullpatch_one(&einfo, "__vdso_gettimeofday");
 		vdso_nullpatch_one(&einfo, "__vdso_clock_gettime");
 		vdso_nullpatch_one(&einfo, "__vdso_clock_gettime64");
+		vdso_nullpatch_one(&einfo, "__vdso_clock_getres");
 	}
 }
 
-- 
2.51.0



