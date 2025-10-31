Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EC52376E4;
	Fri, 31 Oct 2025 14:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919432; cv=none; b=SDuInnUbE36tma5BmWQE9P2ET8fixGXTbheuqDzXgzwKEIqFZFfMcZXGEAk426NiGwHqoEZSKU9CSOfRabSxsqb47c3Qu9iMp5W3cf04exF8GqdAl4hpwzUpdA4ixliSd83clF5H7qyO5Qsp7DjzGa4wVExr3/08yQcOQlM0GLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919432; c=relaxed/simple;
	bh=xxRljNyQBM+UZi/EtpFmNYOv2icWIl/4wOD5xawMezU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCSOtAxHTxPSAjyf6GJcdM3YttDxYezu9mwTOGrHAbGkRMIbENj6tUPAdx1Ircf0AUNO3EQSQh9GyJNHXNw9CAhOcKwvSSWVdaXfGzUjNeP6a3LCmws73LP682V9zjcTbSvNU4EorVpOTW8OMysEac5Fn+Q+Ij1RP0pgkllvkfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBvhh+wE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBvhh+wE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3E1C4CEE7;
	Fri, 31 Oct 2025 14:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919430;
	bh=xxRljNyQBM+UZi/EtpFmNYOv2icWIl/4wOD5xawMezU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBvhh+wEjx5+2JazdvY0WGjRBHzzNjkkeF2s2kf10ttRsOynkwQYMz2WJTvyClnKk
	 LkXUk2gl4l9z0gtZQOqz+ROFTWp9o7oqbhIc4s2ON5QltE+2VkkziEt4AgmRO+iauM
	 OdvabGqoJ4N79yHRjcW+TQiTKFY/COOM/WfjEOro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Kaplan <david.kaplan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 08/40] x86/bugs: Report correct retbleed mitigation status
Date: Fri, 31 Oct 2025 15:01:01 +0100
Message-ID: <20251031140044.145737887@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index f3cb559a598df..0c16457e06543 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1186,8 +1186,10 @@ static void __init retbleed_select_mitigation(void)
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



