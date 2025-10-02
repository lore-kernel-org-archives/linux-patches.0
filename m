Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DB821D3E6;
	Thu,  2 Oct 2025 15:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419062; cv=none; b=t1U8eS0p3zjxz3I272YRigADwENLD7fGPzvZTZAwbpY7Uds1eLEWuim8M6cfpKwLr3r6hLkfxGbtv/1PHWcnmathO4bsHtKpRyMcym7yFYyovQCPxcTKdtrHt0AbreJ/J6u5lNthctGOvGl53/gissgBGFa3d13maMBxBwTnI9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419062; c=relaxed/simple;
	bh=jiHHeTdxwr2NtyZ8m2KBDe2yqAXM7KaYp/7I4+o8Xp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BP8aC0T2qaAllW+IeWc1x8ms5SYCKV0ecWQ2QmxLQn/OuswwknrofuUmUOavcR9h7BgdcsHffHttvyb1PYweV03T2/7Ehci2iK512itIn/wZQspjzYhH4Qi4RawkEAqRRiH5lIp8Y/wB/AUCqZPWW+qwWMgmWfkDh98Fk6H0Ruo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rQBpLVhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rQBpLVhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3190C4CEF4;
	Thu,  2 Oct 2025 15:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759419061;
	bh=jiHHeTdxwr2NtyZ8m2KBDe2yqAXM7KaYp/7I4+o8Xp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQBpLVhDiEqSk4lPguy9G1poualkJ80DwG6QvO/5ZUHYcJaKCthw5mQrK2mcXDVpA
	 nqsvS/oKkRldXAXO8kvsjCcgk/eCUUZP0xNb36TDzcLTQiinAjT0B1E8YD4wyADbe8
	 MFMrxajTcC5PUUZMoS7r29Em3iZaFGxGKKGMc93kYz5qWyjDs/MwPYDniQgYRkY7An
	 3gEurfyhWGYg1eB5f8B687xXPnaW9uGtkqhgNyscU4mEAleppi9RnLypG9Y+GgArUb
	 M3rHP9h6tNWnKgMOKIazpYYQUVmTonz+60FBHnTB47yjXlSI9Ze0TK4+yUZ6Rii/5/
	 Dbo3deDBQMLUA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Harald Freudenberger <freude@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.16] s390/pkey: Forward keygenflags to ep11_unwrapkey
Date: Thu,  2 Oct 2025 11:30:13 -0400
Message-ID: <20251002153025.2209281-26-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002153025.2209281-1-sashal@kernel.org>
References: <20251002153025.2209281-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 11aa54ba4cfa5390ea47c9a1fc62502abce1f6b9 ]

The pkey ioctl PKEY_CLR2SECK2 describes in the pkey.h header file
the parameter 'keygenflags' which is forwarded to the handler
functions which actually deal with the clear key to secure key
operation. The ep11 handler module function ep11_clr2keyblob()
function receives this parameter but does not forward it to the
underlying function ep11_unwrapkey() on invocation. So in the end
the user of this ioctl could not forward additional key generation
flags to the ep11 implementation and thus was unable to modify the
key generation process in any way. So now call ep11_unwrapkey()
with the real keygenflags instead of 0 and thus the user of this
ioctl can for example via keygenflags provide valid combinations
of XCP_BLOB_* flags.

Suggested-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## BACKPORT RECOMMENDATION: **YES**

## EXTENSIVE ANALYSIS

### Bug Description and Impact

This commit fixes a **functional bug** in the s390 pkey subsystem where
the `keygenflags` parameter provided by users through the
`PKEY_CLR2SECK2` ioctl is ignored and not forwarded to the underlying
EP11 implementation.

**Specific Code Change Analysis**
(drivers/s390/crypto/zcrypt_ep11misc.c:1406-1408):

The bug is at line 1408 in the `ep11_clr2keyblob()` function, where
`ep11_unwrapkey()` is called. The problematic code was:
```c
rc = ep11_unwrapkey(card, domain, kek, keklen,
                    encbuf, encbuflen, 0, def_iv,
                    keybitsize, 0, keybuf, keybufsize, keytype, xflags);
                             ^^
                    Hardcoded 0 instead of keygenflags parameter
```

The fix changes this to:
```c
rc = ep11_unwrapkey(card, domain, kek, keklen,
                    encbuf, encbuflen, 0, def_iv,
                    keybitsize, keygenflags,
                    keybuf, keybufsize,
                    keytype, xflags);
```

### User Impact Analysis

**What Users Cannot Do (Before Fix):**
1. **Cannot customize EP11 AES key attributes** - Users calling
   PKEY_CLR2SECK2 ioctl cannot specify custom XCP_BLOB_* flags (e.g.,
   XCP_BLOB_ENCRYPT, XCP_BLOB_DECRYPT, XCP_BLOB_PROTKEY_EXTRACTABLE
   combinations)
2. **Stuck with default attributes** - All generated keys use the
   hardcoded defaults (0x00200c00 = XCP_BLOB_ENCRYPT | XCP_BLOB_DECRYPT
   | XCP_BLOB_PROTKEY_EXTRACTABLE)
3. **API version selection may be suboptimal** - The EP11 API version
   selection in `_ep11_unwrapkey()` (zcrypt_ep11misc.c:1100-1101)
   depends on keygenflags, and passing 0 always selects EP11_API_V4

**What the Fix Enables:**
- Users can now properly control key generation attributes via the
  documented PKEY_CLR2SECK2 ioctl interface
- Correct API version selection based on user-provided flags
- Full functionality as documented in
  arch/s390/include/uapi/asm/pkey.h:290-292

### Historical Context

**Bug Introduction:** Commit 55d0a513a0e202 (December 6, 2019) -
"s390/pkey/zcrypt: Support EP11 AES secure keys"
- This was a major feature addition (1007 insertions) that added EP11
  AES secure key support
- The bug existed from day one - the keygenflags parameter was received
  but never forwarded
- **Bug age: Nearly 6 years** (2019-12-06 to 2025-08-13)
- **Affected versions: v5.10 onwards** (all stable kernels from v5.10 to
  v6.17+)

**Similar Bug Pattern:** Commit deffa48fb014f (August 29, 2019) fixed an
identical issue for CCA cipher keys where keygenflags were not handled
correctly, showing this is a recurring pattern in the s390 crypto
subsystem.

### Backport Suitability Assessment

**✓ Fixes Important User-Visible Bug:**
- YES - Breaks documented ioctl interface functionality
- Users cannot access advertised EP11 key generation customization
  features

**✓ Small and Contained Change:**
- YES - Only **1 functional line changed** (passing keygenflags instead
  of 0)
- Additional changes are just code reformatting (line breaks for
  readability)
- Change is in drivers/s390/crypto/zcrypt_ep11misc.c:1408 only

**✓ Minimal Regression Risk:**
- **VERY LOW RISK** - The change makes the code do what it was supposed
  to do from the beginning
- Forwards an existing parameter that was already being received but
  ignored
- No new code paths introduced
- No changes to data structures or API signatures
- Default behavior preserved (when keygenflags=0, defaults are still
  used via ternary in _ep11_unwrapkey)

**✓ No Architectural Changes:**
- YES - Pure parameter forwarding fix
- No changes to subsystem architecture

**✓ Confined to Subsystem:**
- YES - Only affects s390 pkey/zcrypt EP11 crypto subsystem
- No cross-subsystem dependencies

**✗ Explicit Stable Tree Marking:**
- NO "Cc: stable@vger.kernel.org" tag present
- NO "Fixes:" tag present
- However, this is likely an oversight given the clear bug fix nature

### Security Implications

**Low Security Risk, Potential Security Enhancement:**
1. **No new vulnerabilities introduced** - The fix enables intended
   functionality
2. **May improve security posture** - Users can now properly configure
   key attributes like encryption/decryption capabilities and
   extractability
3. **Restores documented interface contract** - Users get the security
   controls they were promised in the API

### Dependencies and Prerequisites

**No prerequisites identified:**
- Function signature of `ep11_clr2keyblob()` has included keygenflags
  parameter since v5.10
- Function signature of `ep11_unwrapkey()` has included keygenflags
  parameter since v5.10
- No ABI changes
- No new kernel features required
- Clean application to stable trees expected

### Related Work

The fix commit (11aa54ba4cfa5390ea47c9a1fc62502abce1f6b9) was authored
on 2025-08-13 and committed to mainline on 2025-08-28, making it very
recent. It has already been backported to at least one stable tree
(commit 6b78f84e140b4a3e with "Upstream commit" marker).

### Recommendation Summary

This commit is an **excellent candidate for backporting** to stable
kernel trees because:

1. ✅ Fixes a clear, long-standing functional bug (6 years)
2. ✅ Extremely small, surgical change (1 line functional change)
3. ✅ Affects documented user-facing API (PKEY_CLR2SECK2 ioctl)
4. ✅ Zero architectural impact
5. ✅ Very low regression risk
6. ✅ Restores intended functionality without breaking existing users
7. ✅ Confined to s390 crypto subsystem
8. ✅ Follows stable tree best practices (important bugfix, minimal risk)

**Backport Target:** All stable trees containing the original bug
(v5.10+, specifically kernels containing commit 55d0a513a0e202)

 drivers/s390/crypto/zcrypt_ep11misc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/zcrypt_ep11misc.c b/drivers/s390/crypto/zcrypt_ep11misc.c
index 3bf09a89a0894..e92e2fd8ce5da 100644
--- a/drivers/s390/crypto/zcrypt_ep11misc.c
+++ b/drivers/s390/crypto/zcrypt_ep11misc.c
@@ -1405,7 +1405,9 @@ int ep11_clr2keyblob(u16 card, u16 domain, u32 keybitsize, u32 keygenflags,
 	/* Step 3: import the encrypted key value as a new key */
 	rc = ep11_unwrapkey(card, domain, kek, keklen,
 			    encbuf, encbuflen, 0, def_iv,
-			    keybitsize, 0, keybuf, keybufsize, keytype, xflags);
+			    keybitsize, keygenflags,
+			    keybuf, keybufsize,
+			    keytype, xflags);
 	if (rc) {
 		ZCRYPT_DBF_ERR("%s importing key value as new key failed, rc=%d\n",
 			       __func__, rc);
-- 
2.51.0

