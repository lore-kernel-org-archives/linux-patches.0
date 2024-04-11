Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A981813BACD;
	Thu, 11 Apr 2024 10:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831838; cv=none; b=VhNT+rWziigKv4ck5DxZmwyZoSdzmpcStg+hVeIV8SGSHLDKrZrDxwdOuRPLAaosDoZLbTS6UbhnXscx6OyHGrsgo/3Ds4CdnjJzQJ53zw7PO9JM6lrsCIqE2IlJK2+/aqNDdyW0OEfY7bvFD16wrvvSdeBYAWPt49US27SuAsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831838; c=relaxed/simple;
	bh=k4IhuJ1BdEjDrB/D7niM3qjICCxMUlpuw6KQsChOKeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXzviAj1ns1VqF4hoAcoCbb1H8Xli99uoU2cC62hunum18thwNd/qq9RJbAbubzQut4l3u7lKS1uqXpxtY5fw5Xf1a+LXvc1DIpixjr2MSPfLuTWY6xAPoaqLTxImrXrGibxZ+s0BGKAU40lg0Xy0HZMhnrX1uHCZL1az9jn0hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVJZciFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVJZciFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31064C433F1;
	Thu, 11 Apr 2024 10:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831838;
	bh=k4IhuJ1BdEjDrB/D7niM3qjICCxMUlpuw6KQsChOKeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVJZciFsuKtprsgFVQemjYrTRx1OUuJA3cUU5UqqVWuf0R4iSO+E7v5tIJ4xbKF+y
	 StWBwnRQTJqiOOiFjm1tKNg5rM1H0rbP/8/gi2NBfNvKCrfRv8paKdWErko+gzrkza
	 YEBGvBXnEk+Di0XNc0VvS+mzRFs842FtwSnBW7Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 5.10 141/294] x86/entry_32: Add VERW just before userspace transition
Date: Thu, 11 Apr 2024 11:55:04 +0200
Message-ID: <20240411095439.902266498@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit a0e2dab44d22b913b4c228c8b52b2a104434b0b3 upstream.

As done for entry_64, add support for executing VERW late in exit to
user path for 32-bit mode.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20240213-delay-verw-v8-3-a6216d83edb7%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_32.S |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -949,6 +949,7 @@ SYM_FUNC_START(entry_SYSENTER_32)
 	BUG_IF_WRONG_CR3 no_user_check=1
 	popfl
 	popl	%eax
+	CLEAR_CPU_BUFFERS
 
 	/*
 	 * Return back to the vDSO, which will pop ecx and edx.
@@ -1021,6 +1022,7 @@ restore_all_switch_stack:
 
 	/* Restore user state */
 	RESTORE_REGS pop=4			# skip orig_eax/error_code
+	CLEAR_CPU_BUFFERS
 .Lirq_return:
 	/*
 	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on IRET core serialization
@@ -1219,6 +1221,7 @@ SYM_CODE_START(asm_exc_nmi)
 
 	/* Not on SYSENTER stack. */
 	call	exc_nmi
+	CLEAR_CPU_BUFFERS
 	jmp	.Lnmi_return
 
 .Lnmi_from_sysenter_stack:


