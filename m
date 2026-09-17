Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53487502545;
	Thu, 17 Sep 2026 18:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668718; cv=none; b=EpAxCVo+lEnEUX7MPDyb0NjNt1JLx6HfKaYaucwRUJfyRS2uDjzXh6g6pEsREuMI74DUDxujnc+Kwq1Ncx/SEe0SpXFbulF9vCDvLqESL3hs6MgtW87nQlgyc7aP2RdXrfvpqsi4YYUhiDDHfDiLm48GqyI38scM5/hlNzgiZ/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668718; c=relaxed/simple;
	bh=AidEfgHZ2NetQHEScYO3sOAVzok0spEXSYMD0dJFtqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkoezWXs7XNG4s7E9w4kBvYJuIwTK1qK5L0JV+vON4lHb+do4/dsFDnHwJZ/7FKFvm93mcCRxE2tk87ZI3yPcb+gjux7kXcdYTyRzpFlIm4KAcCnbwy92AAUFPRRpK1NI4FjalkWWsGhad0aSm+SAcvroN2yGYINXSSpYk17M0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOaC1LTu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOaC1LTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A592A1F000FF;
	Thu, 17 Sep 2026 18:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668717;
	bh=QKEWFoaXBwcrD9rMAWdQ1OjoNYec8Mv1E5CPMGrqzWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uOaC1LTuDuPZwzgrKiZ8QSKeNiebWh80pDk1EII9s8Gn2JDZ5fjgOSe+ALpsVprui
	 bKLeDdeI7efzYfkLZeN4prCxNtzYPnfNinVx24XCQivS5ovFNizUuW/RdWQq4Ag8TZ
	 J++UAseq5E41IQxaWIXJ+v0KmARXsalv6iafd1OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0469/1102] Revert "ARM: 9481/2: breakpoint: CFI breakpoints only on demand"
Date: Thu, 17 Sep 2026 16:06:52 +0100
Message-ID: <20260917151551.466636378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

This reverts commit 22107402c2669b0163d43cc68901a2c4a59fa43a.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/hw_breakpoint.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index 6819d4c1f3521..a12efd0f43e81 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -929,6 +929,10 @@ static void hw_breakpoint_cfi_handler(struct pt_regs *regs)
 		break;
 	}
 }
+#else
+static void hw_breakpoint_cfi_handler(struct pt_regs *regs)
+{
+}
 #endif
 
 /*
@@ -960,14 +964,9 @@ static int hw_breakpoint_pending(unsigned long addr, unsigned int fsr,
 	case ARM_ENTRY_SYNC_WATCHPOINT:
 		watchpoint_handler(addr, fsr, regs);
 		break;
-#ifdef CONFIG_CFI
 	case ARM_ENTRY_CFI_BREAKPOINT:
-		if (user_mode(regs))
-			ret = 1; /* Don't handle userspace BKPT */
-		else
-			hw_breakpoint_cfi_handler(regs);
+		hw_breakpoint_cfi_handler(regs);
 		break;
-#endif
 	default:
 		ret = 1; /* Unhandled fault. */
 	}
-- 
2.53.0



