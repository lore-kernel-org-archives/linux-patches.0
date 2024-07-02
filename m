Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D5C15B0FE;
	Tue,  2 Jul 2024 17:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940227; cv=none; b=GL6SLPAGc9RVDfK4dghbI4dzDX/Vis67kotT+koo+2+UGPJVnT/Ajn0U0iYOGuB+/Xh91qgApgdPReUlJLx1LPeYc02n5jg3Yxc/Dq+eg1dBGD15UTWao8Cj9t7n2K49jaxunfMlZExEYhaRV/30gmpJPzWfvaBSzDZC/BG9Kpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940227; c=relaxed/simple;
	bh=Va3GTSb9ev6gE+rilAMEj5KMAi1uuEsPsOF9byrwK48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPuRTILDyiyQfpnSlXJ92CLPeEml/TDZ8LEAJQz1gCwE2ZjHX1A7OVCgqoLpkknk8SBtJruV0MiCbkIl4AlRYwTp+a96r3qXmmhAA+lt/cPGrMAB1rkPIdtlxRxJgjDZKr23Q4UXS/AiZIzMwJQicQtQHJ6dvQkmPWgWBFLkqoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iltHqc+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iltHqc+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B45C116B1;
	Tue,  2 Jul 2024 17:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940227;
	bh=Va3GTSb9ev6gE+rilAMEj5KMAi1uuEsPsOF9byrwK48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iltHqc+/cH1XP2Ay/D8Lnc9yx+rX570RoAWbbfd+pjfhATaim6smhfyOWbonQcOCo
	 HUuN2a2WJuqDv2m/BilfYFcvXJ4UkHebYky7ZOPS7dSq8fGTQwnYog4w90nOtSX22n
	 jkPysK8Iu8iJm8+zK0EBmHou22Qz+5ipPKsGiQqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Berger <stefanb@linux.ibm.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 091/222] evm: Enforce signatures on unsupported filesystem for EVM_INIT_X509
Date: Tue,  2 Jul 2024 19:02:09 +0200
Message-ID: <20240702170247.452866502@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Berger <stefanb@linux.ibm.com>

[ Upstream commit 47add87ad181473e5ef2438918669540ba5016a6 ]

Unsupported filesystems currently do not enforce any signatures. Add
support for signature enforcement of the "original" and "portable &
immutable" signatures when EVM_INIT_X509 is enabled.

The "original" signature type contains filesystem specific metadata.
Thus it cannot be copied up and verified. However with EVM_INIT_X509
and EVM_ALLOW_METADATA_WRITES enabled, the "original" file signature
may be written.

When EVM_ALLOW_METADATA_WRITES is not set or once it is removed from
/sys/kernel/security/evm by setting EVM_INIT_HMAC for example, it is not
possible to write or remove xattrs on the overlay filesystem.

This change still prevents EVM from writing HMAC signatures on
unsupported filesystem when EVM_INIT_HMAC is enabled.

Co-developed-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/evm/evm_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 81dbade5b9b3d..518b3090cdb77 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -192,7 +192,11 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 		     iint->evm_status == INTEGRITY_PASS_IMMUTABLE))
 		return iint->evm_status;
 
-	if (is_unsupported_fs(dentry))
+	/*
+	 * On unsupported filesystems without EVM_INIT_X509 enabled, skip
+	 * signature verification.
+	 */
+	if (!(evm_initialized & EVM_INIT_X509) && is_unsupported_fs(dentry))
 		return INTEGRITY_UNKNOWN;
 
 	/* if status is not PASS, try to check again - against -ENOMEM */
@@ -260,7 +264,8 @@ static enum integrity_status evm_verify_hmac(struct dentry *dentry,
 				evm_status = INTEGRITY_PASS_IMMUTABLE;
 			} else if (!IS_RDONLY(inode) &&
 				   !(inode->i_sb->s_readonly_remount) &&
-				   !IS_IMMUTABLE(inode)) {
+				   !IS_IMMUTABLE(inode) &&
+				   !is_unsupported_fs(dentry)) {
 				evm_update_evmxattr(dentry, xattr_name,
 						    xattr_value,
 						    xattr_value_len);
@@ -418,9 +423,6 @@ enum integrity_status evm_verifyxattr(struct dentry *dentry,
 	if (!evm_key_loaded() || !evm_protected_xattr(xattr_name))
 		return INTEGRITY_UNKNOWN;
 
-	if (is_unsupported_fs(dentry))
-		return INTEGRITY_UNKNOWN;
-
 	return evm_verify_hmac(dentry, xattr_name, xattr_value,
 				 xattr_value_len);
 }
-- 
2.43.0



