Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E565C78C78;
	Mon, 15 Apr 2024 14:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191436; cv=none; b=LvDurrjWLMPOFyILlacI+Q6MyBwcNqhMDI8mij7pcsPZTkFsR3h4gUX+wWTSo7tI/qw5GbC1BppS/atsUkVCtLsuQ3YEFivNxTK2D43P/vIYzPGGEhB4NyewKWGXAJ7gLmTz8wARNmUmWYMWNEZjiNnknsUNv7q+Q0SjReFhgUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191436; c=relaxed/simple;
	bh=pQA5TYDnhmdh+/uulFnCfP9NcD7PxpYH00MqJpwFSYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sPDcnMTfwc1jY7f2xxBk0wnZhu52gK/KoyGHxgC1ceW/5gNCI8nfRRgBNEIPSz5548rDE01m/obc7XOxxc0VwkgaDIgeLFBQMPi9sPcVEKrW8thlgFBEMOpeCAAqEPFaJF4BRQ4I7qNlnnXVGJwSr2E3MhFOatw4YfhmpPCQPzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNaBbOho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNaBbOho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4BAC2BD11;
	Mon, 15 Apr 2024 14:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191435;
	bh=pQA5TYDnhmdh+/uulFnCfP9NcD7PxpYH00MqJpwFSYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNaBbOhoycwG67GgjY0G05TPsouNxFZDe0XM+Dt4n8wotmsAc8dJUtCsalNy/Dot4
	 MnlNelLd2K9XFsjn1Rs6+/ST0EtJR4z7iX9nEROXt2CCMb+8/Sq0yPmDwAECaZ7gIs
	 OFe/aLRieEJoxiBW2gbw2Lxq0+aGfqi2lXxabicA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.8 142/172] x86/cpu: Actually turn off mitigations by default for SPECULATION_MITIGATIONS=n
Date: Mon, 15 Apr 2024 16:20:41 +0200
Message-ID: <20240415142004.684949568@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3207,7 +3207,8 @@ enum cpu_mitigations {
 };
 
 static enum cpu_mitigations cpu_mitigations __ro_after_init =
-	CPU_MITIGATIONS_AUTO;
+	IS_ENABLED(CONFIG_SPECULATION_MITIGATIONS) ? CPU_MITIGATIONS_AUTO :
+						     CPU_MITIGATIONS_OFF;
 
 static int __init mitigations_parse_cmdline(char *arg)
 {


