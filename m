Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B31E403E88;
	Tue, 21 Jul 2026 17:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654786; cv=none; b=hgHGpxO47fxvPNrfxq/WjWWE7E2kmQNfjSMVgFRVLN4bTSp46ZI0374H4ARQYTyAAF4vurYkLvu6Ggwd5sHT8EKRx8XRwH3e5uf+9BXAFQS7Ral7E2HSnqHy4X0eLZQrztTQCwYO5Pf2xahdJdmFfgMoVjPHx2EbIb5W64Hod8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654786; c=relaxed/simple;
	bh=r39k0k8+tLZwhJxd0Wawgp4mGRoMV0EbBuxtY2BGBIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOSx+u2wA2j5nGmh/1Hqsu9rdD1xi88cJUBumxSmOQ5CISMSe8o3UPQkduyFwFUDh0kkRpw61MY5v3w37hl1TBkZij8YuE6ho9uyDuDeP/Ex6gX71fRJclOXjlX+zBWXafCKTKYwTUyRlSDIoHeNxxK56Dxca5uHX4+8kiVAsoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSCLoNcM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSCLoNcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA6D1F000E9;
	Tue, 21 Jul 2026 17:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654783;
	bh=JK90la8HeUFWhCp4qDkKcB0Le0dJgUPWwaez8r4fyes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fSCLoNcMtH+e4HNAAXJsnYXXgyIlQqPf9pxD0DtfW2pV51VH6wplEwHvFWOGCqc3j
	 mb+NVm3loukKvcSDZCJMhuWR9oKI59BVLi0BUDLcqRFm1YgpRXdRjXdzGYiDWDlXMp
	 sbFSgwmsoI2ZtkrkYnPwNWH3BhdB7HkvRb6weQs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 7.1 1835/2077] bpf: Reset register bounds before narrowing retval range in check_mem_access()
Date: Tue, 21 Jul 2026 17:25:08 +0200
Message-ID: <20260721152636.021970535@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

commit 5e0b273e0a62cc04ec338c7b502797c66c2ed42a upstream.

When the BPF verifier processes a context load of an LSM hook return
value, it calls __mark_reg_s32_range() to narrow the register to the
hook's valid range. However, __mark_reg_s32_range() intersects the new
range with the register's existing bounds using max_t()/min_t() rather
than replacing them.

If the destination register carries stale bounds from a prior instruction
(e.g. BPF_MOV64_IMM), the intersection can produce a range narrower than
reality. The verifier then believes it knows the register's exact value,
while at runtime the actual hook return value is loaded, creating a
verifier/runtime mismatch that can be used to bypass BPF memory safety
checks.

The else branch already calls mark_reg_unknown() to reset register state
before any narrowing. Apply the same reset in the is_retval path so
stale bounds are cleared before __mark_reg_s32_range() intersects.

Fixes: 5d99e198be27 ("bpf, lsm: Add check for BPF LSM return value")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260622230123.3695446-2-tristmd@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6454,6 +6454,7 @@ static int check_mem_access(struct bpf_v
 			 */
 			if (info.reg_type == SCALAR_VALUE) {
 				if (info.is_retval && get_func_retval_range(env->prog, &range)) {
+					mark_reg_unknown(env, regs, value_regno);
 					err = __mark_reg_s32_range(env, regs, value_regno,
 								   range.minval, range.maxval);
 					if (err)


