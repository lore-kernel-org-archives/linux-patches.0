Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B819213E97;
	Thu, 12 Dec 2024 15:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016091; cv=none; b=VQTLET1B7iyUyPNEMJmKleoZIKGxrLDtWXoqCusaC1/5FgYeoVIedyloPkbSXWLT2IJcWk/+ZhPlJLGSwkvTmkjiq24qhyEW7F7IvlKEd88LsEgdMbiR8a7hwjESZS6Hz7royLWypIfy1L42tgGBJsKe+PUumNNn3qRgVdc/KnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016091; c=relaxed/simple;
	bh=4gqk7jQxdYQPQlWW9HPbFKQz91K0H2VPb9JOEGm21aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQxWWTeVIAyQzWpMigSNP0CqdFjSfs16hHEkwugK+5wDVLg0ZtGLaC/lECxHBA43ru8gh6LIEO9CgS7W3EpBi9lSkLWBos2vraITfQrNp5g9mK+UDoZrzDNOo4FU15etzfzPKiiN6Yur9BGaepBhJB88g7tQojVzMz5Duz1NljM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MoWTKIvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MoWTKIvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E28AC4CED7;
	Thu, 12 Dec 2024 15:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016091;
	bh=4gqk7jQxdYQPQlWW9HPbFKQz91K0H2VPb9JOEGm21aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MoWTKIvNeCQyYwkH3Hf8w7IdhAdyg1Q1/YJNK8MiPxIzlf1jA84zaExU8r3ZtPhCa
	 2LPeEytQn5zfqxL+cQ/FA9XJbuaHZGkdc7V361L3ncrM4g0/E+YorYTu1iAwN2E+Uy
	 UVAi5Mrg3QN2P2FlJEY3TNIM9kY2LUz5WJRQV914=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rudi Horn <rudi.horn@oracle.com>,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/466] x86/pkeys: Ensure updated PKRU value is XRSTORd
Date: Thu, 12 Dec 2024 15:54:28 +0100
Message-ID: <20241212144310.727783417@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>

[ Upstream commit ae6012d72fa60c9ff92de5bac7a8021a47458e5b ]

When XSTATE_BV[i] is 0, and XRSTOR attempts to restore state component
'i' it ignores any value in the XSAVE buffer and instead restores the
state component's init value.

This means that if XSAVE writes XSTATE_BV[PKRU]=0 then XRSTOR will
ignore the value that update_pkru_in_sigframe() writes to the XSAVE buffer.

XSTATE_BV[PKRU] only gets written as 0 if PKRU is in its init state. On
Intel CPUs, basically never happens because the kernel usually
overwrites the init value (aside: this is why we didn't notice this bug
until now). But on AMD, the init tracker is more aggressive and will
track PKRU as being in its init state upon any wrpkru(0x0).
Unfortunately, sig_prepare_pkru() does just that: wrpkru(0x0).

This writes XSTATE_BV[PKRU]=0 which makes XRSTOR ignore the PKRU value
in the sigframe.

To fix this, always overwrite the sigframe XSTATE_BV with a value that
has XSTATE_BV[PKRU]==1.  This ensures that XRSTOR will not ignore what
update_pkru_in_sigframe() wrote.

The problematic sequence of events is something like this:

Userspace does:
	* wrpkru(0xffff0000) (or whatever)
	* Hardware sets: XINUSE[PKRU]=1
Signal happens, kernel is entered:
	* sig_prepare_pkru() => wrpkru(0x00000000)
	* Hardware sets: XINUSE[PKRU]=0 (aggressive AMD init tracker)
	* XSAVE writes most of XSAVE buffer, including
	  XSTATE_BV[PKRU]=XINUSE[PKRU]=0
	* update_pkru_in_sigframe() overwrites PKRU in XSAVE buffer
... signal handling
	* XRSTOR sees XSTATE_BV[PKRU]==0, ignores just-written value
	  from update_pkru_in_sigframe()

Fixes: 70044df250d0 ("x86/pkeys: Update PKRU to enable all pkeys before XSAVE")
Suggested-by: Rudi Horn <rudi.horn@oracle.com>
Signed-off-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20241119174520.3987538-3-aruna.ramakrishna%40oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/xstate.h | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 6b2924fbe5b8d..aa16f1a1bbcf1 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -72,10 +72,22 @@ static inline u64 xfeatures_mask_independent(void)
 /*
  * Update the value of PKRU register that was already pushed onto the signal frame.
  */
-static inline int update_pkru_in_sigframe(struct xregs_state __user *buf, u32 pkru)
+static inline int update_pkru_in_sigframe(struct xregs_state __user *buf, u64 mask, u32 pkru)
 {
+	u64 xstate_bv;
+	int err;
+
 	if (unlikely(!cpu_feature_enabled(X86_FEATURE_OSPKE)))
 		return 0;
+
+	/* Mark PKRU as in-use so that it is restored correctly. */
+	xstate_bv = (mask & xfeatures_in_use()) | XFEATURE_MASK_PKRU;
+
+	err =  __put_user(xstate_bv, &buf->header.xfeatures);
+	if (err)
+		return err;
+
+	/* Update PKRU value in the userspace xsave buffer. */
 	return __put_user(pkru, (unsigned int __user *)get_xsave_addr_user(buf, XFEATURE_PKRU));
 }
 
@@ -292,7 +304,7 @@ static inline int xsave_to_user_sigframe(struct xregs_state __user *buf, u32 pkr
 	clac();
 
 	if (!err)
-		err = update_pkru_in_sigframe(buf, pkru);
+		err = update_pkru_in_sigframe(buf, mask, pkru);
 
 	return err;
 }
-- 
2.43.0



