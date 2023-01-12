Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE12D746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 13:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D492C433EF;
	Thu, 12 Jan 2023 13:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673531860;
	bh=R/FzZwGWEz4Uxqu8dr4LIIJiLMXchnBGGB0kUA2SZEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NV5p8+7eCMclw8brVLAvrzO3D64kMCQt2Drf+5nqAxrNPzqPdnO9NPzEEU6bbkIFb
	 yWNCng4UUZ+m4JKb4/cvjiEMRtJxcsQTIDINbawouF7AN3Ws1/HnqEW8fqPIYprPBK
	 yeTnP8VEqbG71pAex+scGIQOr3i9Z2wu5Xm5vmkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Huey <me@kylehuey.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.15 06/10] x86/fpu: Emulate XRSTORs behavior if the xfeatures PKRU bit is not set
Date: Thu, 12 Jan 2023 14:56:43 +0100
Message-Id: <20230112135326.931667008@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
References: <20230112135326.689857506@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kyle Huey <me@kylehuey.com>

commit d7e5aceace514a2b1b3ca3dc44f93f1704766ca7 upstream

The hardware XRSTOR instruction resets the PKRU register to its hardware
init value (namely 0) if the PKRU bit is not set in the xfeatures mask.
Emulating that here restores the pre-5.14 behavior for PTRACE_SET_REGSET
with NT_X86_XSTATE, and makes sigreturn (which still uses XRSTOR) and
behave identically.

Fixes: e84ba47e313d ("x86/fpu: Hook up PKRU into ptrace()")
Signed-off-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20221115230932.7126-6-khuey%40kylehuey.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/xstate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1168,7 +1168,8 @@ static int copy_uabi_to_xstate(struct xr
 
 		xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
 		*pkru = xpkru->pkru;
-	}
+	} else
+		*pkru = 0;
 
 	/*
 	 * The state that came in from userspace was user-state only.


