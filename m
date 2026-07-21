Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ED646AA6C;
	Tue, 21 Jul 2026 15:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648125; cv=none; b=Bi4VL1iAx4U5OaGDw5xppclcDhLYOFxZ8HpkzF3RiEiB8Z8kUXm/9klvk5uRyXjqDzxXzYbYij+QrL5JuLEN7J1j8qPjDxljHlMRud5V379QSiY7fhHDZIBRCcj34EGzbPg5JqQKB6M6xSF4jidYiyKeEQfDsD8owSCCpi4EvDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648125; c=relaxed/simple;
	bh=IlF+9Nag4flDawCr5PN4gF2dzp6BUB6WmudOHLWlRso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDYU+5PZtq+NnjPgVdIstnT9H07ESk4SfuYYLWrSDMxHRopi481gIUrGImxFDOs1OhztIxsczWiOsc2FtRcLNmrQLClEAdR1jFg9y06kG/V7ixLEloc5c8/PVR6IR3k6sIoqSZPm1xqdo5ChIerBpFCzzSLs3w/rGkFclFiS2zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCOLj5jU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCOLj5jU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9919E1F000E9;
	Tue, 21 Jul 2026 15:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648124;
	bh=MZhxsgwIjH6Tiy8X6i8PPE6kBWHcztrXhB1BkXOWYqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCOLj5jUszs5RRQJjSf230g3j7s/fVxJ5SzmEeChdG74PZNG9wXw4frz9+FwvECLW
	 543/zKfi7u8t8xm4/ydZNotwjnEJr07VpUwjjtkY9xFAiIvSWgLi2YZb9FFuk5aupZ
	 RSn7/AhZRE6SvD4jZ52t4fxuaZZ4w3aKFDb7+t8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamlesh Kumar <kam@juniper.net>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0079/2077] ima: Fix sigv3 signature handling for EVM_IMA_XATTR_DIGSIG
Date: Tue, 21 Jul 2026 16:55:52 +0200
Message-ID: <20260721152554.557852566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamlesh Kumar <kamlesh0hrs@gmail.com>

[ Upstream commit 398ee113f15c1e8e62535e54f22fb4db340c7835 ]

ima_get_hash_algo() only recognizes version 2 signatures when the xattr
type is EVM_IMA_XATTR_DIGSIG. Since sigv3 signatures also use
EVM_IMA_XATTR_DIGSIG as the xattr type, version 3 must be accepted as
well to correctly determine the hash algorithm.

Additionally, ima_validate_rule() does not include IMA_SIGV3_REQUIRED in
the allowed flags bitmask for MODULE_CHECK, KEXEC_KERNEL_CHECK, and
KEXEC_INITRAMFS_CHECK hook functions. As a result, policy rules with
"appraise_type=sigv3" are rejected for these functions.

Add version 3 to the accepted versions in ima_get_hash_algo() for
EVM_IMA_XATTR_DIGSIG, and add IMA_SIGV3_REQUIRED to the allowed flags
for MODULE_CHECK, KEXEC_KERNEL_CHECK, and KEXEC_INITRAMFS_CHECK in
ima_validate_rule().

Signed-off-by: Kamlesh Kumar <kam@juniper.net>
Tested-by: Stefan Berger <stefanb@linux.ibm.com>
Fixes: de4c44a7f559 ("ima: add support to require IMA sigv3 signatures")
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_appraise.c | 5 +++--
 security/integrity/ima/ima_policy.c   | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index de963b9f363447..2dd231567710a5 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -195,8 +195,9 @@ enum hash_algo ima_get_hash_algo(const struct evm_ima_xattr_data *xattr_value,
 		return sig->hash_algo;
 	case EVM_IMA_XATTR_DIGSIG:
 		sig = (typeof(sig))xattr_value;
-		if (sig->version != 2 || xattr_len <= sizeof(*sig)
-		    || sig->hash_algo >= HASH_ALGO__LAST)
+		if ((sig->version != 2 && sig->version != 3) ||
+		    xattr_len <= sizeof(*sig) ||
+		    sig->hash_algo >= HASH_ALGO__LAST)
 			return ima_hash_algo;
 		return sig->hash_algo;
 	case IMA_XATTR_DIGEST_NG:
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index f7f940a7692234..b1c010e8eb1387 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1313,7 +1313,8 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
 				     IMA_GID | IMA_EGID |
 				     IMA_FGROUP | IMA_DIGSIG_REQUIRED |
 				     IMA_PERMIT_DIRECTIO | IMA_MODSIG_ALLOWED |
-				     IMA_CHECK_BLACKLIST | IMA_VALIDATE_ALGOS))
+				     IMA_CHECK_BLACKLIST | IMA_VALIDATE_ALGOS |
+				     IMA_SIGV3_REQUIRED))
 			return false;
 
 		break;
-- 
2.53.0



