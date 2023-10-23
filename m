Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BF614A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2PQMrZmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5533C433CA;
	Mon, 23 Oct 2023 11:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698058956;
	bh=ZOhgvJVu0PGo5kOKyrE05QFkRozauQS0Hus/lBAXsNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2PQMrZmQDPed9q3/QpXbQTVCVxHn+A1yQo893vE8Vw3t7a8uAtrSejlgSCMIaQ6MG
	 tvawwCZaoezpQWyxX16VH9HcNk4R4AHdTDl+P9OJhyEoS6dtMByH7nHT5oEaQIOLD9
	 JUrVy/V0zLftmLFyrhkDiat5CvfWpgcn0TSqQ+FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Dohrmann <erbse.13@gmx.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.5 016/241] x86/sev: Disable MMIO emulation from user mode
Date: Mon, 23 Oct 2023 12:53:22 +0200
Message-ID: <20231023104834.311154880@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Upstream commit: a37cd2a59d0cb270b1bba568fd3a3b8668b9d3ba

A virt scenario can be constructed where MMIO memory can be user memory.
When that happens, a race condition opens between when the hardware
raises the #VC and when the #VC handler gets to emulate the instruction.

If the MOVS is replaced with a MOVS accessing kernel memory in that
small race window, then write to kernel memory happens as the access
checks are not done at emulation time.

Disable MMIO emulation in user mode temporarily until a sensible use
case appears and justifies properly handling the race window.

Fixes: 0118b604c2c9 ("x86/sev-es: Handle MMIO String Instructions")
Reported-by: Tom Dohrmann <erbse.13@gmx.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Tom Dohrmann <erbse.13@gmx.de>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1508,6 +1508,9 @@ static enum es_result vc_handle_mmio(str
 			return ES_DECODE_FAILED;
 	}
 
+	if (user_mode(ctxt->regs))
+		return ES_UNSUPPORTED;
+
 	switch (mmio) {
 	case INSN_MMIO_WRITE:
 		memcpy(ghcb->shared_buffer, reg_data, bytes);


