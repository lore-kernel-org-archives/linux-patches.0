Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8E4222D77;
	Thu, 12 Dec 2024 16:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020980; cv=none; b=es3Rx5KGUVHDX0VR8s8/nSLqVkbjvJyqMkwdU73xQCcNsByBCoA9RQEWqNtkFa2iTui10v8oNQi9PaiazmiUZlEXafJGBM8xoNL1iy+rnDhlZeA30KB7k/Iyr3buCJqzaqFM6zLi263PATf0XUhkZo2FlA5HaFSUKCcZuJJpkgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020980; c=relaxed/simple;
	bh=J4mc4CfJj2nyR9+eHmMy5MyLp1kOM53S5X7LSlq89Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vymy9xdmdxJ/b0dMrm+dhlar4ZA9G8E7hgPbRZL6sHiDL3Ox3iK8Eei+1F9Id9DGqE3xhwqXTTvymFTejCDsQnAluI4aiq7tS+IyE/jVQMM7FXI8ZmfRMCCJoCGiwudke+TYwBH6yR4O2QW9s6m6un7wKPHFEfEKYk7OGaY408o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugg25P06; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugg25P06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69437C4CED0;
	Thu, 12 Dec 2024 16:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020979;
	bh=J4mc4CfJj2nyR9+eHmMy5MyLp1kOM53S5X7LSlq89Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugg25P06TDGzlL14LMagMeYSkBRu89K2h+Wyjy+xsnprW0sRD5Kxey+rBcnKG/6j4
	 36rmd7G8+b7OkuqTnrD2bHYtEvG1N5YQr2C5tjmuQiJgsn4pZbXBe/OExdlaABu9Tf
	 lWD+XmL5mfnd20nCxw0s/r59FAQ+SdJVfnnQJSCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 612/772] arm64: ptrace: fix partial SETREGSET for NT_ARM_TAGGED_ADDR_CTRL
Date: Thu, 12 Dec 2024 15:59:17 +0100
Message-ID: <20241212144415.220697682@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit ca62d90085f4af36de745883faab9f8a7cbb45d3 upstream.

Currently tagged_addr_ctrl_set() doesn't initialize the temporary 'ctrl'
variable, and a SETREGSET call with a length of zero will leave this
uninitialized. Consequently tagged_addr_ctrl_set() will consume an
arbitrary value, potentially leaking up to 64 bits of memory from the
kernel stack. The read is limited to a specific slot on the stack, and
the issue does not provide a write mechanism.

As set_tagged_addr_ctrl() only accepts values where bits [63:4] zero and
rejects other values, a partial SETREGSET attempt will randomly succeed
or fail depending on the value of the uninitialized value, and the
exposure is significantly limited.

Fix this by initializing the temporary value before copying the regset
from userspace, as for other regsets (e.g. NT_PRSTATUS, NT_PRFPREG,
NT_ARM_SYSTEM_CALL). In the case of a zero-length write, the existing
value of the tagged address ctrl will be retained.

The NT_ARM_TAGGED_ADDR_CTRL regset is only visible in the
user_aarch64_view used by a native AArch64 task to manipulate another
native AArch64 task. As get_tagged_addr_ctrl() only returns an error
value when called for a compat task, tagged_addr_ctrl_get() and
tagged_addr_ctrl_set() should never observe an error value from
get_tagged_addr_ctrl(). Add a WARN_ON_ONCE() to both to indicate that
such an error would be unexpected, and error handlnig is not missing in
either case.

Fixes: 2200aa7154cb ("arm64: mte: ptrace: Add NT_ARM_TAGGED_ADDR_CTRL regset")
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20241205121655.1824269-2-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/ptrace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1340,7 +1340,7 @@ static int tagged_addr_ctrl_get(struct t
 {
 	long ctrl = get_tagged_addr_ctrl(target);
 
-	if (IS_ERR_VALUE(ctrl))
+	if (WARN_ON_ONCE(IS_ERR_VALUE(ctrl)))
 		return ctrl;
 
 	return membuf_write(&to, &ctrl, sizeof(ctrl));
@@ -1354,6 +1354,10 @@ static int tagged_addr_ctrl_set(struct t
 	int ret;
 	long ctrl;
 
+	ctrl = get_tagged_addr_ctrl(target);
+	if (WARN_ON_ONCE(IS_ERR_VALUE(ctrl)))
+		return ctrl;
+
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &ctrl, 0, -1);
 	if (ret)
 		return ret;


