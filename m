Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F192119;
	Mon, 15 Apr 2024 14:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192211; cv=none; b=U6zyHAT5+Ih5/Dj39bb8X7whRfkGXXAly9uptN9340XaOn2c3d83LrC/TsdhWRJq9lqfBQP+NBMcwkv8KpKE8/4++XgbsPqRbNVqvtpoCMmYbClKfhOA8hnMe3H3xJ7oTNZnJdA34iCI6umfQ6zvQakd5PKlFoDS15w142JIc3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192211; c=relaxed/simple;
	bh=x1xRxH91AhvcSCQOiFORVTP81xM8kygqSpCz4fMc/bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DS+N2fUHF+uSk5nuG0oEHuZ7+e2TZvfqF1pPy/xc9hAD1W6CqGvXFq5MSos4vlGw7yey0/QlNUIajBuyhMOpPsPnjzmpyJAU0A0tEcOb0RhWxCSJROFLOCJG5I2po4AwH2FXJFtBStCIY18H5p7fIZaXTisoMOgOL59prMaNduI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15WQchdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15WQchdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C27C113CC;
	Mon, 15 Apr 2024 14:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192211;
	bh=x1xRxH91AhvcSCQOiFORVTP81xM8kygqSpCz4fMc/bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15WQchdQnyFN9DDflZITaCL8zf16fBGFhVuPFXdp9Wg3BF4qpqEa3+da8zyw3rClE
	 2Ed7xHZx32wFCf6HYdGdUNdwd1+RlRnGcDjSomxflnl+meqrNsfBXEPWgffIAJT+qU
	 FP8/DHpScvI5P1xf1lt9u0wBH1/oiyAmvRTsJEC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 33/45] x86/cpu: Actually turn off mitigations by default for SPECULATION_MITIGATIONS=n
Date: Mon, 15 Apr 2024 16:21:40 +0200
Message-ID: <20240415141943.239655056@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
References: <20240415141942.235939111@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit f337a6a21e2fd67eadea471e93d05dd37baaa9be upstream.

Initialize cpu_mitigations to CPU_MITIGATIONS_OFF if the kernel is built
with CONFIG_SPECULATION_MITIGATIONS=n, as the help text quite clearly
states that disabling SPECULATION_MITIGATIONS is supposed to turn off all
mitigations by default.

  │ If you say N, all mitigations will be disabled. You really
  │ should know what you are doing to say so.

As is, the kernel still defaults to CPU_MITIGATIONS_AUTO, which results in
some mitigations being enabled in spite of SPECULATION_MITIGATIONS=n.

Fixes: f43b9876e857 ("x86/retbleed: Add fine grained Kconfig knobs")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Cc: stable@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20240409175108.1512861-2-seanjc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cpu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2722,7 +2722,8 @@ enum cpu_mitigations {
 };
 
 static enum cpu_mitigations cpu_mitigations __ro_after_init =
-	CPU_MITIGATIONS_AUTO;
+	IS_ENABLED(CONFIG_SPECULATION_MITIGATIONS) ? CPU_MITIGATIONS_AUTO :
+						     CPU_MITIGATIONS_OFF;
 
 static int __init mitigations_parse_cmdline(char *arg)
 {


