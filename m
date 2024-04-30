Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DA47464;
	Tue, 30 Apr 2024 10:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474757; cv=none; b=ODOhEKOj1SZL/O+UFC8T33Ywy8RPdHF+RZsCXiSr44hzWHp9AVUdajTjMJ/ZLp0xrZ+FWVEQImqYqAmMgpgEYBMege8yd9odQCkl8Muaf164fQULiis5/IeyZ2Ewnha/aYd6EeLzwGRI/cz8r/CgnpsQJqpt5Rg8zgrawPEg+uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474757; c=relaxed/simple;
	bh=fwgGE+9iYvnFOPi2uc5EZptV7u1ZxlNjNHBmJ1R8abs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R03KveOaVf/S1qfhbwlgj8Y3FpSl5jRXoTWVnzzFFMcFXZGJSpHQNhGrnyv1MBEtjzPEdHkQYnKns8Awi4030DAI6YvuK6LIhDDUFrLGrMaMTgYVxMu4Ap0WhX/0Xnj9n52RY2pTm6wlJsMmv0g9ibRQfZWDPOXwm4a3QS7DIzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJDTZLsv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJDTZLsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4522BC2BBFC;
	Tue, 30 Apr 2024 10:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474757;
	bh=fwgGE+9iYvnFOPi2uc5EZptV7u1ZxlNjNHBmJ1R8abs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJDTZLsvBeqW4B9A2kLM+jCEmF1QlkpQHKrLxmmV5wgD+guL0FJ1yMAo6nnbLV92D
	 J/wI5y4yxfx5WDWOo/dNK6XNpXcSfqIz3r0bUu/Ef+rbjdCG+6+fWk0kHhHrNOkABa
	 LqkvDqJN79gbld1LAXdi8lCOzse7tFga3C/ofO/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 026/138] x86/cpu: Actually turn off mitigations by default for SPECULATION_MITIGATIONS=n
Date: Tue, 30 Apr 2024 12:38:31 +0200
Message-ID: <20240430103050.199989620@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2600,7 +2600,8 @@ enum cpu_mitigations {
 };
 
 static enum cpu_mitigations cpu_mitigations __ro_after_init =
-	CPU_MITIGATIONS_AUTO;
+	IS_ENABLED(CONFIG_SPECULATION_MITIGATIONS) ? CPU_MITIGATIONS_AUTO :
+						     CPU_MITIGATIONS_OFF;
 
 static int __init mitigations_parse_cmdline(char *arg)
 {


