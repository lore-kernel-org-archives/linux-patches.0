Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA9FAD4B;
	Fri, 31 Oct 2025 14:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919357; cv=none; b=CyvE+zT3HqQQguIAsNStKo07XIB8hAG+ffLxJBE2oF8sqrwMecL9SBGVDy493CF0gURwA24AvIoTwFF2c5EyHUadSWSxSn0wCjHZXhkedRksN0PQ5PYKd1dn2C4wrONu/vIH4+n9bmgjtMZ6K1vgat+dTisLB1NihOmLlnKKGl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919357; c=relaxed/simple;
	bh=Y0/7nXZk8HCedvtPbCjNdczEKhOCDNVm/YBDmXtwytc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXRE/OvbpS17TTJRoonmyuGCteXswBSppvMU/Y3XJ77FuZ5e+Ozw1OkxbihR5hWCWm6jyThHTncX7WS9/NeX0YrCmjNqcTqUCEmRDA9hRkwn2loUoqmBwfPd0xGY7JhLrzPZ9adY21O/z+2CYExSENGBAiBCD9u36FoznWtiKaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pz5Fvtfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pz5Fvtfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56D2C4CEE7;
	Fri, 31 Oct 2025 14:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919357;
	bh=Y0/7nXZk8HCedvtPbCjNdczEKhOCDNVm/YBDmXtwytc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pz5FvtfrGdkXYHzSy2O9LkvE+LRPkoPrZZ/pq9v4Y6CQ51cYAZGbcuzu7IXmN+Exr
	 cc2tF6qpyYCpZo+W15zSULDMchJJgAIU4de/uWeh52ncBIyKgYspX3K5XzH0ZBLSDu
	 sPOsQNYx5LtBGq2SKv8+Bm+KhipMatl128AEGV2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Kaplan <david.kaplan@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 06/32] x86/bugs: Report correct retbleed mitigation status
Date: Fri, 31 Oct 2025 15:01:00 +0100
Message-ID: <20251031140042.556712162@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 315926ccea0fa..f66e0e5b49eb1 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1185,8 +1185,10 @@ static void __init retbleed_select_mitigation(void)
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



