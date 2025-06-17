Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E774623B633;
	Tue, 17 Jun 2025 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174408; cv=none; b=hlk0BM3iFv6EAQ+hYFlGj+JsQxdodUgr+exRBou52xeKAhD8efn3uhazJCSepn6/c/NgZgj8WGEH5jUksFR+3R0rzXV0LReS1fiuXo92+zB1efhKJHq4k6RuGQuqU0dKl6g5iycpyDyP3sTLmMS+yL/Xy9qq04VQplK+ljKkGd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174408; c=relaxed/simple;
	bh=V+jYs8ZGLWmqJcP6Wa7qdrFxxP29zwxuIq+tvPcTWXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dg8e/jlzXhJvs59VscK1zLw4JGoBU7htdWySedOlhCKPk8WkXudRuOYOFitLJpP+E1cbnxs4vBwh9lJUSDgB/5iFqsP2NN3usNGjnhm5llUDNBKv1Th5FUMNNbMz2ViSYVhFP1KVTHkTddcLmBOB0nubpO9gBS7h7MALqiU8EGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/fiZsRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/fiZsRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61624C4CEE7;
	Tue, 17 Jun 2025 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174407;
	bh=V+jYs8ZGLWmqJcP6Wa7qdrFxxP29zwxuIq+tvPcTWXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/fiZsROZI7nVkdiQgAS33kdVcWwf/pNAl04rkzxj+VC7arALagSIVhAzXGWIAhBO
	 Od3hyizkeaNVB11BHE5/tKXm8VhlrdjW8aBcrKC2GZbo+0xADCs0nySDzSGqIp0dn1
	 21lFc/fCkRHFUM51LKV2uKTgJflhTLXb1eEVEyEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Annie Li <jiayanli@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/512] x86/microcode/AMD: Do not return error when microcode update is not necessary
Date: Tue, 17 Jun 2025 17:19:41 +0200
Message-ID: <20250617152420.144852037@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Annie Li <jiayanli@google.com>

[ Upstream commit b43dc4ab097859c24e2a6993119c927cffc856aa ]

After

  6f059e634dcd("x86/microcode: Clarify the late load logic"),

if the load is up-to-date, the AMD side returns UCODE_OK which leads to
load_late_locked() returning -EBADFD.

Handle UCODE_OK in the switch case to avoid this error.

  [ bp: Massage commit message. ]

Fixes: 6f059e634dcd ("x86/microcode: Clarify the late load logic")
Signed-off-by: Annie Li <jiayanli@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250430053424.77438-1-jiayanli@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 079f046ee26d1..e8021d3e58824 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -696,6 +696,8 @@ static int load_late_locked(void)
 		return load_late_stop_cpus(true);
 	case UCODE_NFOUND:
 		return -ENOENT;
+	case UCODE_OK:
+		return 0;
 	default:
 		return -EBADFD;
 	}
-- 
2.39.5



