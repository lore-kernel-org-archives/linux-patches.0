Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53521F37D4;
	Fri, 31 Oct 2025 14:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919600; cv=none; b=OScxrJlffP493bGywwb7S1hSPL6iazCdrStk2+3IM477TwpWcX6KrJTZvWByQssjypLLkKnZHb8YsAr/a1wUS43+YcaU2Mmuigz56UsudKw+MI5M3DBwNRCQ+gPBqCPQfmV8jg0HGbK4KPsaj17Id7QmQRlrlNCe5YQMAGWZc3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919600; c=relaxed/simple;
	bh=aza6z1G9CSiJc6TpMZ2/UUlJi3/yDyr3+PnvP2xukBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3gohPZKoklwpXme53lvVzBt9wR+5ce7sJHO+h4l23YnG4K5+KDPoHAIAH0loqq1ZZvUS+Vf8DhrcB8ACfIk8zSJJan20WKndSWbRZRnm2x7YnIc7FVhELhpQmn1nTo1K1zNWTkRYvANWgM4XhsNDzYC5ogmmt3cU/LCuWO6zaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujmlNTg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujmlNTg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6F0C4CEE7;
	Fri, 31 Oct 2025 14:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919599;
	bh=aza6z1G9CSiJc6TpMZ2/UUlJi3/yDyr3+PnvP2xukBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujmlNTg/ggeE1closihALyG1t9+gZL2z8ChUD1WvNV0Ud8hCqD5zPQKpVitiVAda9
	 RSKoMLf9vcKPchlgxjQiOaoylCxC7oN9byiVEUMQJzokUfaJRTEkZkwTLTXKk1wFS6
	 IxnKjui6rTcFABnVtGxMPHko68FPxCKkMcQwf5Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Kaplan <david.kaplan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 05/35] x86/bugs: Report correct retbleed mitigation status
Date: Fri, 31 Oct 2025 15:01:13 +0100
Message-ID: <20251031140043.691582535@linuxfoundation.org>
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

[ Upstream commit 930f2361fe542a00de9ce6070b1b6edb976f1165 ]

On Intel CPUs, the default retbleed mitigation is IBRS/eIBRS but this
requires that a similar spectre_v2 mitigation is applied.  If the user
selects a different spectre_v2 mitigation (like spectre_v2=retpoline) a
warning is printed but sysfs will still report 'Mitigation: IBRS' or
'Mitigation: Enhanced IBRS'.  This is incorrect because retbleed is not
mitigated, and IBRS is not actually set.

Fix this by choosing RETBLEED_MITIGATION_NONE in this scenario so the
kernel correctly reports the system as vulnerable to retbleed.

Signed-off-by: David Kaplan <david.kaplan@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250915134706.3201818-1-david.kaplan@amd.com
Stable-dep-of: 204ced4108f5 ("x86/bugs: Qualify RETBLEED_INTEL_MSG")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 36dcfc5105be9..bf79ff6a1f662 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1460,8 +1460,10 @@ static void __init retbleed_update_mitigation(void)
 			retbleed_mitigation = RETBLEED_MITIGATION_EIBRS;
 			break;
 		default:
-			if (retbleed_mitigation != RETBLEED_MITIGATION_STUFF)
+			if (retbleed_mitigation != RETBLEED_MITIGATION_STUFF) {
 				pr_err(RETBLEED_INTEL_MSG);
+				retbleed_mitigation = RETBLEED_MITIGATION_NONE;
+			}
 		}
 	}
 
-- 
2.51.0



