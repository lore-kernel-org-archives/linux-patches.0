Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3805151C38;
	Mon, 11 Dec 2023 18:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwzGLsu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19AFC433C7;
	Mon, 11 Dec 2023 18:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320817;
	bh=Yz8+XiRiywrSJ8ZAWhJjMUpfXqKkJ0WVSM5oWA1lc6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zwzGLsu51Am5vDSwqsLkDnyXNGCcuzblvKlRkWZOpThHDCTZvoYSJbG39b/+vTJyZ
	 bp3VYdIpcK6vwd7EJ3A0g3LRXH5Y72nzDgyCnhzLo3K/PowGx1sefcbPK4+t3pC71F
	 /j82RSeXt3L45YVjvg9Cl15Ymog2n0w4JQ4F4u7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 179/194] x86/CPU/AMD: Check vendor in the AMD microcode callback
Date: Mon, 11 Dec 2023 19:22:49 +0100
Message-ID: <20231211182044.651221008@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 9b8493dc43044376716d789d07699f17d538a7c4 upstream.

Commit in Fixes added an AMD-specific microcode callback. However, it
didn't check the CPU vendor the kernel runs on explicitly.

The only reason the Zenbleed check in it didn't run on other x86 vendors
hardware was pure coincidental luck:

  if (!cpu_has_amd_erratum(c, amd_zenbleed))
	  return;

gives true on other vendors because they don't have those families and
models.

However, with the removal of the cpu_has_amd_erratum() in

  05f5f73936fa ("x86/CPU/AMD: Drop now unused CPU erratum checking function")

that coincidental condition is gone, leading to the zenbleed check
getting executed on other vendors too.

Add the explicit vendor check for the whole callback as it should've
been done in the first place.

Fixes: 522b1d69219d ("x86/cpu/amd: Add a Zenbleed fix")
Cc: <stable@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231201184226.16749-1-bp@alien8.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1291,6 +1291,9 @@ static void zenbleed_check_cpu(void *unu
 
 void amd_check_microcode(void)
 {
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
+		return;
+
 	on_each_cpu(zenbleed_check_cpu, NULL, 1);
 }
 


