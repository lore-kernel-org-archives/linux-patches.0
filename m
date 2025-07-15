Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A741991D2;
	Tue, 15 Jul 2025 13:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585651; cv=none; b=CwHjsZyn9khlbquDN2h/LPJsUc0OpMCBxJqwAdfXssax0oF9DuX0QK+V31SP2X63YJo6y/sgx6wKcQa/sKIpIVcHPdjRWzYaH4+jBp8yWQHW+l/CYpND5NXRMwcKUdmDLVq7BNZCGXf+IZg9fOOTPTLvwBreoX4A7hXDZOCt5co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585651; c=relaxed/simple;
	bh=nmQDbsWReh/JA4mDjQ6O6cJmlPpD4IhMxQ2Zs9OJJcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wenqq4+mLAoyjuAZEjuJbuP/xYRLNTAH7+Njc4pSw3poX/tZK7WJdzRtDI3ON9Tdce3GmU8PXebtTtKmX8V19LxXouqhSxBjlCYI3HG4SI9M3UbA/AFLe2gZXD/kRu+0eyQDPSgZA1eU6a3+m9WRfgMZ2cLWQGcKLYz5vteZoMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=005P7b/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="005P7b/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DD9C4CEE3;
	Tue, 15 Jul 2025 13:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585651;
	bh=nmQDbsWReh/JA4mDjQ6O6cJmlPpD4IhMxQ2Zs9OJJcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=005P7b/apBp9pvN7wBJP87a7DKE7oixrE3bzIX/bmSTPHZ5ixcpH03W7qJ+JJ65qV
	 rxwNacjcmdAvWKVLEe0/T6NPNKEnl/tKYXOORXmqhJeIMM0VeaeUiFETJ/pRilcneO
	 pTOITdKpfz8zrGLEYMdSPrvsovWo0Dm0TDZ7TMtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 090/163] scripts/gdb: de-reference per-CPU MCE interrupts
Date: Tue, 15 Jul 2025 15:12:38 +0200
Message-ID: <20250715130812.486190459@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

commit 50f4d2ba26d5c3a4687ae0569be3bbf1c8f0cbed upstream.

The per-CPU MCE interrupts are looked up by reference and need to be
de-referenced before printing, otherwise we print the addresses of the
variables instead of their contents:

MCE: 18379471554386948492   Machine check exceptions
MCP: 18379471554386948488   Machine check polls

The corrected output looks like this instead now:

MCE:          0   Machine check exceptions
MCP:          1   Machine check polls

Link: https://lkml.kernel.org/r/20250625021109.1057046-1-florian.fainelli@broadcom.com
Link: https://lkml.kernel.org/r/20250624030020.882472-1-florian.fainelli@broadcom.com
Fixes: b0969d7687a7 ("scripts/gdb: print interrupts")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gdb/linux/interrupts.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/interrupts.py
+++ b/scripts/gdb/linux/interrupts.py
@@ -110,7 +110,7 @@ def x86_show_mce(prec, var, pfx, desc):
     pvar = gdb.parse_and_eval(var)
     text = "%*s: " % (prec, pfx)
     for cpu in cpus.each_online_cpu():
-        text += "%10u " % (cpus.per_cpu(pvar, cpu))
+        text += "%10u " % (cpus.per_cpu(pvar, cpu).dereference())
     text += "  %s\n" % (desc)
     return text
 


