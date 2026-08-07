Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570E442F71B;
	Fri,  7 Aug 2026 14:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113794; cv=none; b=tfPwQ9ti5wu2ni1tfMaNx1u48o697BFqzQmQYX4fg3mYOkYbMwr8lO5E264Vb334CYuu8xcQvk6UnS9Y6G2LY3ISnBN/kBsPijXiU7J9lGAc4L+nxZ1ju/g9wIppjpKRo46SCK+qnwwMEA9Z19LFnEPF8/RBIS5gopMHur9+soE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113794; c=relaxed/simple;
	bh=r+Q0RrTIt31QrvmEdEmJT9C+3D+GrefJB03R18EYUMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vww679UIUHLA5NBf6vi6WX827dkGYUy5lfp8KxCtg7eT6M+dAcsBDYWDdIKX05CBPOkdptu+zS5hjG/ot+dTZWrtF8EaraaSwCUrme7X1IR9h3GoCjqiRGxwTs9QIpq8aVT+ihn6Kq84aVQUzsrgoQCFrHPTV4/pGV2WcByBFMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TulftksZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TulftksZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE6F1F000E9;
	Fri,  7 Aug 2026 14:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113774;
	bh=az/ELvLLrT2M+lUpsgtu/PcbeNA6t8+DMyyKqYl8GoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TulftksZIIDcTo2NEIKVxak8Md2C5C6k6KloOZbbnfKCc9hzPPJGgx+rx26Sio1M7
	 wE1q3WcJukQp48uR+iyADjQ0uaNREf8pNikYBJw2Zgm1Q2AFUwPkqIcIxKKnJr+pPT
	 tpdrjhS3ceJwPNNYX0lzF/2H56ClZha2KSWrxP2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/337] um: Set parent death signal for userspace process
Date: Fri,  7 Aug 2026 16:33:30 +0200
Message-ID: <20260807143418.681796906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Benjamin Berg <benjamin.berg@intel.com>

commit 801e00d3a1b78b7f71675fae79946ff4aa3ee070 upstream.

Enable PR_SET_PDEATHSIG so that the UML userspace process will be killed
when the kernel exits unexpectedly.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://patch.msgid.link/20240919124511.282088-4-benjamin@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[florian: upstream applies os_set_pdeathsig() in stub_exe.c, a file
introduced in v6.13 that does not exist in 6.12; applied instead to
userspace_tramp() in arch/um/os-Linux/skas/process.c, which is the
equivalent entry-point for the userspace process in 6.12]
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/os-Linux/skas/process.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index b6f656bcffb1..cca016b0b29b 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -214,6 +214,9 @@ static int userspace_tramp(void *stack)
 				     (unsigned long) stub_segv_handler -
 				     (unsigned long) __syscall_stub_start;
 
+	/* Make sure this process dies if the kernel dies */
+	os_set_pdeathsig();
+
 	ptrace(PTRACE_TRACEME, 0, 0, 0);
 
 	signal(SIGTERM, SIG_DFL);
-- 
2.53.0



