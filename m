Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0096F2E9737;
	Tue, 17 Jun 2025 15:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174336; cv=none; b=QrXWPuu8BJHWA+mS7PX7/jD9LC32rwxqKrshEeP4IqoE+Sd37085h/OYhncP2wUYs5E/rWh2euEMWxR7RLoCW4dIg+MV+JMmDOdH8DINX1rN02gL8qySPFUxC0tw/8syee08W6kpWA+BAN4W+b/ICrUx7az4OMHpio9sYEuhhEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174336; c=relaxed/simple;
	bh=jUpaSHtFFhYR+djBd+sgK0nmP538GXrg82W0n2lavUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IX4y016kT10dREoLgwC3+w5E6oCdQ9jyZ7N4kD0jvnylg65qlFCx8kiZduXolZjyUXvdPUBnaSqiLZjZAgAED8NByBTtfCtAkVoYXo1coFgyDtbQOkw8YhGo3nggHI6MFkkfTeolY41c1DqdUbHIoauCl1eLPgCRA8BqMkfyFzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2j87BxZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2j87BxZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6409CC4CEE3;
	Tue, 17 Jun 2025 15:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174335;
	bh=jUpaSHtFFhYR+djBd+sgK0nmP538GXrg82W0n2lavUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2j87BxZZJUwDOvhJig38UX2YftJMpHJzIAiGcgmTKBs5Be5CXHKNjoGjceOIQTEHb
	 HATa9HYGwG1oW2uUlBUxuBvx01xXaZL5FrB+GNGh3YPJ7ln1iKR5MkjGo6z6sIam5b
	 vDhd82c4igPwX87LxmR0FvsS9bYzG2+kstx2Sc70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Annie Li <jiayanli@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/356] x86/microcode/AMD: Do not return error when microcode update is not necessary
Date: Tue, 17 Jun 2025 17:22:22 +0200
Message-ID: <20250617152339.328079026@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5b47c320f17a6..fc539346599cb 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -703,6 +703,8 @@ static int load_late_locked(void)
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



