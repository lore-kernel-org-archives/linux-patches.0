Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0EA3B3888;
	Mon, 23 Mar 2026 15:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278867; cv=none; b=M4BMFKF0W+ZpM1w12C4Yz0Kf5TIdKNBVat1pntw/lukETJUFpDFPZ85ZHQX9aHe9ubUPzc4onFqMez7sTVjRLp7jPFMkZSegTFO02BjJ3VQty3rNA8ZhutezQvZjl04XGoC5a1woCl5kWx1v/mC9vj7WmDV7VhQwMQDm/5LYXZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278867; c=relaxed/simple;
	bh=/ch01L6Lv5GkUAOjFge5oofQCfQhwGhYf/+te668+Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHYrPOqor/tL2/Alzl6D7w5cu/G2FmZnnAui7N2REDEB1heneF6HwKw6zL2shEtGYYFMDMs6WQqLcZ+9h06RtAAVRYz1s9N7ks43JpLPJzaaRlSO0aX26PaXge8Mjc0u5eY2ggY12zkMV3b5Lfpn46HVTSBjt07DwUJReegoLgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDt3KfM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDt3KfM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3D1C2BC9E;
	Mon, 23 Mar 2026 15:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278866;
	bh=/ch01L6Lv5GkUAOjFge5oofQCfQhwGhYf/+te668+Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDt3KfM5xBeTv3KYave0DYfatnn0KyBsKailPUexwjCtc3ssYHUXr0AYqm/jH7j4d
	 krOJLAW5nY+6qak6Rc4kSpk5Or0wfdlk8e9r4aeIhyqYcGlp1L325KeBDmHwy7Kzaj
	 Nc+TFqO1Y2TF9d36rkpyZCjvKBa2royb+eIhz89U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 6.6 417/567] x86/sev: Check for MWAITX and MONITORX opcodes in the #VC handler
Date: Mon, 23 Mar 2026 14:45:37 +0100
Message-ID: <20260323134544.208669159@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Tom Lendacky <thomas.lendacky@amd.com>

[ Upstream commit e70316d17f6ab49a6038ffd115397fd68f8c7be8 ]

The MWAITX and MONITORX instructions generate the same #VC error code as
the MWAIT and MONITOR instructions, respectively. Update the #VC handler
opcode checking to also support the MWAITX and MONITORX opcodes.

Fixes: e3ef461af35a ("x86/sev: Harden #VC instruction emulation somewhat")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/453d5a7cfb4b9fe818b6fb67f93ae25468bc9e23.1713793161.git.thomas.lendacky@amd.com
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev-shared.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -1237,12 +1237,14 @@ static enum es_result vc_check_opcode_by
 		break;
 
 	case SVM_EXIT_MONITOR:
-		if (opcode == 0x010f && modrm == 0xc8)
+		/* MONITOR and MONITORX instructions generate the same error code */
+		if (opcode == 0x010f && (modrm == 0xc8 || modrm == 0xfa))
 			return ES_OK;
 		break;
 
 	case SVM_EXIT_MWAIT:
-		if (opcode == 0x010f && modrm == 0xc9)
+		/* MWAIT and MWAITX instructions generate the same error code */
+		if (opcode == 0x010f && (modrm == 0xc9 || modrm == 0xfb))
 			return ES_OK;
 		break;
 


