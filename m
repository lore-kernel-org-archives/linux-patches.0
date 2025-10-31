Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A8A3C17;
	Fri, 31 Oct 2025 14:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919602; cv=none; b=BNACRchGnuO/duVWrqTpQYn0Zr0OzwMYjgvwgNqf/zgjNuuWKiksuEL5LRgUWkVzVyJnR3VVJG0UmLq24yOsIDe8Y6Sruxgi1vY6iut1yJFM1zvgYMVLxCJ3j3z4gpjqJb+Tf8sosQMHJDN+pAE4393lv/nmX6CQgGs6VZf35a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919602; c=relaxed/simple;
	bh=9a4EEfIoTTgBtzsoV6KodaVI9yPeedcxKQFKgJiBzKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfFMazWw0IWaVvHZoPrRvYRwAWBqE4WdThDjoFx+qMbpcP4CfuCruubSgFqxXCYmILYoZMfxtlEz1VscEqwJi+gzoDu7moNWKovoWZeEcw1G3qJGkCBbQUUOOVRG5DWu7SmJgObSuBFRybqAQx6RVi3Usql6LA/mE/mhtfURMRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCY2WA/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCY2WA/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A020C4CEE7;
	Fri, 31 Oct 2025 14:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919602;
	bh=9a4EEfIoTTgBtzsoV6KodaVI9yPeedcxKQFKgJiBzKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCY2WA/l9K8/mkywhjEyIjwcnFH49yuXyqZwR3SN5C2qDIVE4VvoQfcQ6V7mnW7He
	 3SPTzWlwuEYU7Xv6Xa5Ba6Oh+mNyX31vW9d5dM2Kn2YGP0RS0fjaTjtiHqkHncoygs
	 tCnXxfEnkXfFuaeXP70l4yTiYFE7yxPLBH5M/MqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Kaplan <david.kaplan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 06/35] x86/bugs: Qualify RETBLEED_INTEL_MSG
Date: Fri, 31 Oct 2025 15:01:14 +0100
Message-ID: <20251031140043.714890303@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Kaplan <david.kaplan@amd.com>

[ Upstream commit 204ced4108f5d38f6804968fd9543cc69c3f8da6 ]

When retbleed mitigation is disabled, the kernel already prints an info
message that the system is vulnerable.  Recent code restructuring also
inadvertently led to RETBLEED_INTEL_MSG being printed as an error, which is
unnecessary as retbleed mitigation was already explicitly disabled (by config
option, cmdline, etc.).

Qualify this print statement so the warning is not printed unless an actual
retbleed mitigation was selected and is being disabled due to incompatibility
with spectre_v2.

Fixes: e3b78a7ad5ea ("x86/bugs: Restructure retbleed mitigation")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220624
Signed-off-by: David Kaplan <david.kaplan@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20251003171936.155391-1-david.kaplan@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index bf79ff6a1f662..9750ce448e626 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1461,7 +1461,9 @@ static void __init retbleed_update_mitigation(void)
 			break;
 		default:
 			if (retbleed_mitigation != RETBLEED_MITIGATION_STUFF) {
-				pr_err(RETBLEED_INTEL_MSG);
+				if (retbleed_mitigation != RETBLEED_MITIGATION_NONE)
+					pr_err(RETBLEED_INTEL_MSG);
+
 				retbleed_mitigation = RETBLEED_MITIGATION_NONE;
 			}
 		}
-- 
2.51.0



