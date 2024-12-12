Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665722185A8;
	Thu, 12 Dec 2024 15:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017922; cv=none; b=n7xnmq3Bi3t+Yvc/+3HgXPZL91hmtRbeVjhCVnHzqsShXw3AHnQ323InMTP1DO2I+irVvNKkdIumXXnX4Y/693tM7/87vIip8cAOmWzW9DKHiMT7szzgHwXUFWwzTfcNd2CFeS9RFjvh8slmyYt50cJMO+w+aBXYTF6Oh1NZQnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017922; c=relaxed/simple;
	bh=hCak/1qFm7w8rQZ/BJIWSsonF6trx07v3bhoeNP4Sow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/Tn7WzSywLL7s0gS/N5TwEOVuREtiskWfbFQO+o99Fw/EEVu7ep73g5Qb1h5JqnP7DmjHhQCdT7eAkp3jHPSBnILjBNBHZg/KuZkWU4tm5sQcbDi2KhCC3MMEqfs1tgG/vrE3xUMSO34h9V3r1VxLkhlrzb2gyGNkf1NpmKfrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQ4q4VFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQ4q4VFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC572C4CECE;
	Thu, 12 Dec 2024 15:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017922;
	bh=hCak/1qFm7w8rQZ/BJIWSsonF6trx07v3bhoeNP4Sow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQ4q4VFEApRIChcBNCseBydyftzCkEn1opqrm107hv2BG841y8tPe1/HXQMqEg8cA
	 d9s5lpC8WTGMeFWe4UhvknOo9LFTZ3ji4GTKvHSQZB6FxEnb1lI1YanXPwLTUGDZcD
	 oxzsZ7/LXc6iVaESCYrNND6RQPAKI/OGsmXSeUlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 148/356] arm64: ptrace: fix partial SETREGSET for NT_ARM_TAGGED_ADDR_CTRL
Date: Thu, 12 Dec 2024 15:57:47 +0100
Message-ID: <20241212144250.486597351@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1385,7 +1385,7 @@ static int tagged_addr_ctrl_get(struct t
 {
 	long ctrl = get_tagged_addr_ctrl(target);
 
-	if (IS_ERR_VALUE(ctrl))
+	if (WARN_ON_ONCE(IS_ERR_VALUE(ctrl)))
 		return ctrl;
 
 	return membuf_write(&to, &ctrl, sizeof(ctrl));
@@ -1399,6 +1399,10 @@ static int tagged_addr_ctrl_set(struct t
 	int ret;
 	long ctrl;
 
+	ctrl = get_tagged_addr_ctrl(target);
+	if (WARN_ON_ONCE(IS_ERR_VALUE(ctrl)))
+		return ctrl;
+
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &ctrl, 0, -1);
 	if (ret)
 		return ret;


