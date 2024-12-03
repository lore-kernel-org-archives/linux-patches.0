Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B220C1F7557;
	Tue,  3 Dec 2024 15:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239698; cv=none; b=WFihJ5UtmlQYNS+oq/HLCG8GOa+duAJ5CNxhpt0EKzyKaufcL/3UOlNPgo12KDTu8eMbTV1JkX+xpCfADp70b4oYihQyaPF9AWRXbDXiVyiRbecqCZ4UXQjOOzXAs1fWbMyair9TfKmuJUqEXS/nv3bjGN9gE31ldwdwz4LouzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239698; c=relaxed/simple;
	bh=HNqHPi+S1g4SSx8drqJZKkPdou+3vdmhNUSJsJfwSAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TA3wf5fzrBvCAX2lslKBBw/S1mQJ1MXyp7qPXwQpUH/F5bi5inwYVxR1BhfoURzt38SP2Kox3wqag5Wwx2xeLeYMyZhejSRcnmGEoaJC4QVXxwPTyP9r9HKAE1y4Ck5HRpnPWQiabblVZ1scxeRjUdP4iBCvIVNYA8yPJmC7rc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5uAFQDV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5uAFQDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A6DC4CED9;
	Tue,  3 Dec 2024 15:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239698;
	bh=HNqHPi+S1g4SSx8drqJZKkPdou+3vdmhNUSJsJfwSAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5uAFQDVnKBpHudzUdmnGWIrCYdlEjhKQxgiwe9IRHjq0erOzToB+wwurdO5D8zlX
	 06l2qL6QRVUHrEQwmW2FoUP+w+HQiN/M9jB81UTUC/8yiQ0qo3d7yEeTuOanM1E45f
	 qhEET+M3GU9KvsP80IEv1p4DFSrodak8+Pt9XH4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Taube <jesse@rivosinc.com>,
	Evan Green <evan@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.11 703/817] RISC-V: Scalar unaligned access emulated on hotplug CPUs
Date: Tue,  3 Dec 2024 15:44:35 +0100
Message-ID: <20241203144023.421768131@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Taube <jesse@rivosinc.com>

commit 9c528b5f7927b857b40f3c46afbc869827af3c94 upstream.

The check_unaligned_access_emulated() function should have been called
during CPU hotplug to ensure that if all CPUs had emulated unaligned
accesses, the new CPU also does.

This patch adds the call to check_unaligned_access_emulated() in
the hotplug path.

Fixes: 55e0bf49a0d0 ("RISC-V: Probe misaligned access speed in parallel")
Signed-off-by: Jesse Taube <jesse@rivosinc.com>
Reviewed-by: Evan Green <evan@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241017-jesse_unaligned_vector-v10-2-5b33500160f8@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/unaligned_access_speed.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/kernel/unaligned_access_speed.c
+++ b/arch/riscv/kernel/unaligned_access_speed.c
@@ -191,6 +191,7 @@ static int riscv_online_cpu(unsigned int
 	if (per_cpu(misaligned_access_speed, cpu) != RISCV_HWPROBE_MISALIGNED_SCALAR_UNKNOWN)
 		goto exit;
 
+	check_unaligned_access_emulated(NULL);
 	buf = alloc_pages(GFP_KERNEL, MISALIGNED_BUFFER_ORDER);
 	if (!buf) {
 		pr_warn("Allocation failure, not measuring misaligned performance\n");


