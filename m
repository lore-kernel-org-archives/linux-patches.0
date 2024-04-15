Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F011E4B1;
	Mon, 15 Apr 2024 14:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192119; cv=none; b=oeAqaORbGGKxhhqBZmTc/uBP4cAc/IvloxP1Bo7AlaUNmUvyxBI9UbWe3ekb7Xw9/b2kSJ+Him6Ql4Qz0LN94gAoS1MEDF/I6Y+DzCqDn6qdafXWCWO9rY7VClkXiDMP3xsdDGh3qK0U1DtURvRrZjD54pipnbk7DoynHN7/kkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192119; c=relaxed/simple;
	bh=6iucqrJJL0scwhY8+4RE2uRj/g2IyXEB4O4bWyTB9I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EGA7UEiAThK85r5E9we0kGz3h1syHIpa6z0Dv3A6Uz5aIYOR+tLUlm6GXZ3kdOB0xUS41M+cXrx1M27ooybw6pXchoGK3q8Do51FsM24JC0Crt4s83xSGN6Yx6wayVlvuz0fsTMOId+uq5/G+8WZfngLOKBI/u1xWA6sN83dCtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYJJuR7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYJJuR7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3719C113CC;
	Mon, 15 Apr 2024 14:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192119;
	bh=6iucqrJJL0scwhY8+4RE2uRj/g2IyXEB4O4bWyTB9I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYJJuR7pJrsfXGFvW/9zPJdSN3EG8RmpnE8kJ+MqrQl75cKMgwl2R7N4mT8oya6F5
	 ZLuvRtuDEdqfZsCW24Bm4hxuFRgV2+9Prgl+iTE9xYyZuKonGiheIv5Nz5k5AI2NFu
	 rrjA7ll6jmIRfQ/A3HgPO3PPGw845ighOYaTG06I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 53/69] x86/cpu: Actually turn off mitigations by default for SPECULATION_MITIGATIONS=n
Date: Mon, 15 Apr 2024 16:21:24 +0200
Message-ID: <20240415141947.766678667@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2788,7 +2788,8 @@ enum cpu_mitigations {
 };
 
 static enum cpu_mitigations cpu_mitigations __ro_after_init =
-	CPU_MITIGATIONS_AUTO;
+	IS_ENABLED(CONFIG_SPECULATION_MITIGATIONS) ? CPU_MITIGATIONS_AUTO :
+						     CPU_MITIGATIONS_OFF;
 
 static int __init mitigations_parse_cmdline(char *arg)
 {


