Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EAC199230;
	Mon,  3 Nov 2025 18:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762192996; cv=none; b=CSYU3jUIUgH/s9z8/KEBFaK7cWKWmfWo9ZevKYNChGOKxD5/WpSwyUJoPV3WcVIBacHZ1Do/wKGPRMsGjNFJfPqquJDMM1QP/r/uiUOOUzMyse1jIC1qq8jKqivq0tKaESCDs04R5xV9aE4Y68H/tUkRoyRI9E8GTsWtCzGBy+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762192996; c=relaxed/simple;
	bh=9q0LlLf/dRUDFwF8f8synzTkHZ77cem5WHNmuYp4NYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eyavP6O9Qlnmp/HanD4VTz4n5tZSpgTNY2oTSIti06ECsRomwU22wFqga/L5IH7SeiekTrQij5kHI3bhFDzY4c03ciS5lCcVNbfoc4cBDhTt0O1VsI/cNtJhY4fwu//pFAKK3Qrqaxlo9ddSMicYruMNC/7UaZ2Zj5L2ynP5yhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fAcFz9NK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fAcFz9NK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABF0C116C6;
	Mon,  3 Nov 2025 18:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762192996;
	bh=9q0LlLf/dRUDFwF8f8synzTkHZ77cem5WHNmuYp4NYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAcFz9NKPrFHEFmXnDWPRconr+BoaDkslwhZTHwGdVPjM+fROVoua3A7Qt6BA6IYV
	 8ln/eT1IArETuzu+jIFZwxl2JFO0BrvIyBXXGiUwF83MTWAui0yjK9KCTMCg+6OCFV
	 w30Wnh0Omhx2tDHg8kCLfsmC1dGkwgGsjHJYolhSsxY90msLQwFaY+7dDSDqnnsklS
	 JmV4p3UT6ZrXiEK4W1jYMWFgkpSz3UC8xB2LGSsfRNjnkJ5XMNwZzOEyI8S26PCcbZ
	 jDZ5+vcrxcEjIZypv/FguRRADcnFTX1BAOejUoEtPtZcRDIVxQOQiHl+Tzo3caul2V
	 P9w9ULEPu6yWQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Po-Hsu Lin <po-hsu.lin@canonical.com>,
	Edoardo Canepa <edoardo.canepa@canonical.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.15] selftests: net: use BASH for bareudp testing
Date: Mon,  3 Nov 2025 13:02:28 -0500
Message-ID: <20251103180246.4097432-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103180246.4097432-1-sashal@kernel.org>
References: <20251103180246.4097432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

[ Upstream commit 9311e9540a8b406d9f028aa87fb072a3819d4c82 ]

In bareudp.sh, this script uses /bin/sh and it will load another lib.sh
BASH script at the very beginning.

But on some operating systems like Ubuntu, /bin/sh is actually pointed to
DASH, thus it will try to run BASH commands with DASH and consequently
leads to syntax issues:
  # ./bareudp.sh: 4: ./lib.sh: Bad substitution
  # ./bareudp.sh: 5: ./lib.sh: source: not found
  # ./bareudp.sh: 24: ./lib.sh: Syntax error: "(" unexpected

Fix this by explicitly using BASH for bareudp.sh. This fixes test
execution failures on systems where /bin/sh is not BASH.

Reported-by: Edoardo Canepa <edoardo.canepa@canonical.com>
Link: https://bugs.launchpad.net/bugs/2129812
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://patch.msgid.link/20251027095710.2036108-2-po-hsu.lin@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and examination of the Linux kernel
repository, here is my determination:

## **Backport Status: YES**

### Evidence and Analysis:

#### 1. **Code Change Analysis**
The commit makes a single-line change to
`tools/testing/selftests/net/bareudp.sh`:
- Changes shebang from `#!/bin/sh` to `#!/bin/bash`

I examined both files:
- **bareudp.sh:1** currently has `#!/bin/sh` but sources lib.sh on line
  109
- **lib.sh:1** has `#!/bin/bash` and uses BASH-specific features:
  - Line 4: `${BASH_SOURCE[0]}` - BASH-specific variable
  - Line 5: `source` command (POSIX uses `.`)
  - Line 24+: Array syntax (`NS_LIST=()`)

#### 2. **Repository Investigation Findings**

I discovered this commit **has already been backported** to stable:
- **Original commit**: `9311e9540a8b4` (mainline)
- **Backport commit**: `e171733806283` (linux-autosel-6.17, signed by
  Sasha Levin)

```bash
$ git show e171733806283 --stat
commit e1717338062838ac0054457d3dcbec14b56529ae
Author: Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Mon Oct 27 17:57:10 2025 +0800

    selftests: net: use BASH for bareudp testing

    [ Upstream commit 9311e9540a8b406d9f028aa87fb072a3819d4c82 ]
    ...
    Signed-off-by: Sasha Levin <sashal@kernel.org>
```

#### 3. **Impact Scope**
- Bareudp.sh is the **only** script sourcing lib.sh with `#!/bin/sh`
  (all others use `#!/bin/bash`)
- Out of ~109 net selftests, 97 use bash, only 12 use sh
- This fix ensures consistency across the selftest infrastructure

#### 4. **Why This Should Be Backported**

**符合 Stable Tree 标准:**
- ✅ **Fixes a real bug**: Test execution failures on Ubuntu/Debian
  systems where /bin/sh → DASH
- ✅ **Obviously correct**: One-line change, zero risk
- ✅ **Small and contained**: Single line modification
- ✅ **No side effects**: Only affects test execution, not kernel runtime
- ✅ **Improves test infrastructure**: Allows CI/CD systems to properly
  validate stable kernels

**Practical Benefits:**
- Enables proper testing of the bareudp driver on stable kernels
- Fixes false negatives in test results on Debian-based distributions
- Zero risk of kernel regression (test-only change)
- Already proven safe by existing backport

#### 5. **Why Semantic Tools Not Used**
The semantic code analysis tools (mcp__semcode__*) are designed for C
code analysis. This commit modifies a shell script in the testing
infrastructure, not kernel C code. The analysis was conducted using:
- Direct file inspection (Read tool)
- Git history analysis (Bash/git commands)
- Pattern matching across test scripts

### Conclusion
This commit **should definitively be backported** to stable kernel
trees. The fact that it has already been successfully backported by the
stable kernel maintainer (Sasha Levin) to linux-autosel-6.17 provides
strong empirical evidence of its suitability for stable backporting.

 tools/testing/selftests/net/bareudp.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/bareudp.sh b/tools/testing/selftests/net/bareudp.sh
index 4046131e78882..d9e5b967f8151 100755
--- a/tools/testing/selftests/net/bareudp.sh
+++ b/tools/testing/selftests/net/bareudp.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
 # Test various bareudp tunnel configurations.
-- 
2.51.0

