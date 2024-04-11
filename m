Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5808A13A244;
	Thu, 11 Apr 2024 18:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712859076; cv=none; b=AHW5qa73kENJjABnUB/2hMKBD0Igxgd6x08eqhtYSZH6Sj9NaNeur6CpK609GoBKKWKsKplIAtciv3+qFYhDuX5xF9D0oDu+qNSBPCDINycf1VrmGIgQqgJQNkucwAUDJC2jl3hqKiqTOlbjxSbcUAfsNwjB9IFAmyMwnrq3+kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712859076; c=relaxed/simple;
	bh=XOsbqvr4AZyPNMl9xo6AYH1X+oIS2bOvRQecWxU5VBs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kF37v50IffiVeqotxQyafl+Tin8CKVm0HyNP04BcotI0LszZrE70LTsv03GgLXzqRgL0p05BMyrPa6r6oqcpbW1vSagY0fyk7amIbpYusYrtSo6yK5folcrZoE5FADBLq+TVq5mHrTWdzWTHAFvHYDOI/dl5ZvY9qNmwxyMMz7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pMq3nxWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pMq3nxWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D7DC072AA;
	Thu, 11 Apr 2024 18:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712859075;
	bh=XOsbqvr4AZyPNMl9xo6AYH1X+oIS2bOvRQecWxU5VBs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pMq3nxWcOhM7YCNikVsaCBGoXvGnWEw5InSBj+ROEoeNvztIi43HNr4gaMPj0vFTb
	 n9UrmrmsiOGWdg2ONr099nwNYFFcJEnLFqT9OTBdNG3Qq7jGGC1OEhaXsOFDp9bNnp
	 zZrw6BNa8yIsTBg2LJuntvkcKumLqMTBWRKPE555QZ0sdBICgTEOC6Vn+lgsbuRdBh
	 hxMxgZgsaT5bx5fc1a7kavUvYnbRczIqS2NCUpGbTwIf+YBpQAtZFsphr7tnBEqdaR
	 rTpkNB5T2MsEGokIQfcQjM2fOxkPAO5x3IKoLpqF9OPM/7FqlVrFHHFNRsGuEROUYg
	 R6EJKsMDCwMJQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 11 Apr 2024 11:11:07 -0700
Subject: [PATCH 2/2] configs/hardening: Disable CONFIG_UBSAN_SIGNED_WRAP
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240411-fix-ubsan-in-hardening-config-v1-2-e0177c80ffaa@kernel.org>
References: <20240411-fix-ubsan-in-hardening-config-v1-0-e0177c80ffaa@kernel.org>
In-Reply-To: <20240411-fix-ubsan-in-hardening-config-v1-0-e0177c80ffaa@kernel.org>
To: keescook@chromium.org
Cc: gustavoars@kernel.org, justinstitt@google.com, 
 linux-hardening@vger.kernel.org, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1703; i=nathan@kernel.org;
 h=from:subject:message-id; bh=XOsbqvr4AZyPNMl9xo6AYH1X+oIS2bOvRQecWxU5VBs=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGkS6oe+cb9t1p6iICB+7o5jsNTjuYtabtp8df8kap2yY
 rq00nGtjlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCR/puMDEe+HCq4/fw6y9eM
 bz+u1F//5/Rg5exFac6bV6THXtVmDZ3CyLDx9vO4i4/2BETv/FlXeMPLMbt5y9M0g7x359/HHe2
 N8uEAAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

kernel/configs/hardening.config turns on UBSAN for the bounds sanitizer,
as that in combination with trapping can stop the exploitation of buffer
overflows within the kernel. At the same time, hardening.config turns
off every other UBSAN sanitizer because trapping means all UBSAN reports
will be fatal and the problems brought up by other sanitizers generally
do not have security implications.

The signed integer overflow sanitizer was recently added back to the
kernel and it is default on with just CONFIG_UBSAN=y, meaning that it
gets enabled when merging hardening.config into another configuration.
While this sanitizer does have security implications like the array
bounds sanitizer, work to clean up enough instances to allow this to run
in production environments is still ramping up, which means regular
users and testers may be broken by these instances with
CONFIG_UBSAN_TRAP=y. Disable CONFIG_UBSAN_SIGNED_WRAP in
hardening.config to avoid this situation.

Fixes: 557f8c582a9b ("ubsan: Reintroduce signed overflow sanitizer")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 kernel/configs/hardening.config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/configs/hardening.config b/kernel/configs/hardening.config
index d6f6dc45628a..4b4cfcba3190 100644
--- a/kernel/configs/hardening.config
+++ b/kernel/configs/hardening.config
@@ -41,6 +41,7 @@ CONFIG_UBSAN_BOUNDS=y
 # CONFIG_UBSAN_SHIFT is not set
 # CONFIG_UBSAN_DIV_ZERO is not set
 # CONFIG_UBSAN_UNREACHABLE is not set
+# CONFIG_UBSAN_SIGNED_WRAP is not set
 # CONFIG_UBSAN_BOOL is not set
 # CONFIG_UBSAN_ENUM is not set
 # CONFIG_UBSAN_ALIGNMENT is not set

-- 
2.44.0

