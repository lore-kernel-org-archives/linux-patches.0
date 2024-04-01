Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADFA1E86C;
	Mon,  1 Apr 2024 16:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990759; cv=none; b=qSU4bu4B61ZmKrXAZazLW0BN7DvMzXYiMpkX5Fr79rkRPI0iK/C7LsofMc5kn8M771rZfgXtxQtBJyBhJhRUIKq/L8h6VnCLBLkoHe2cvcBF/embPBIw3BXXKbj1WgkW/HollKlyIyrYjKM3znG/PAsbu3VhzuNd1dJ7Zb6ioYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990759; c=relaxed/simple;
	bh=RztuwVQE0VbnDXPq3tIIIYnI+WiaBzhbZXBPDv7COnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=br/aBaabB77t/rH8pgeaSkGeVwRhKPcrqaU55zMEZgd+FlY6QjDd9Yo2j6rvLqjd0uDrKFAeMYF4DjWf+p6/pyZGGD9QUH5jAxZlxh1ZVdjOqmMZM+NXDMThIALotZoia776MBNVRvmrppwgVpXGlHiH5xN2LKK0PWFsRWk+5DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPYpDaN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPYpDaN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C05C433C7;
	Mon,  1 Apr 2024 16:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990759;
	bh=RztuwVQE0VbnDXPq3tIIIYnI+WiaBzhbZXBPDv7COnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPYpDaN591OBiXk7hTGGAmJMZEUEr5djtPzBWgWDcW+FbmWwaupQAQ1tRZdMBQ+cM
	 UaCdiWvhnUVLE8PESPvuk19cQr795ti1q+ryq+a8cIUj76XbiwExXbqePM6EGy5cb/
	 AHWb1TkQ6erSw/jIdoFUZ9hop+wGsUjBxGJT7tvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/272] powerpc/smp: Adjust nr_cpu_ids to cover all threads of a core
Date: Mon,  1 Apr 2024 17:43:38 +0200
Message-ID: <20240401152531.238600545@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 5580e96dad5a439d561d9648ffcbccb739c2a120 ]

If nr_cpu_ids is too low to include at least all the threads of a single
core adjust nr_cpu_ids upwards. This avoids triggering odd bugs in code
that assumes all threads of a core are available.

Cc: stable@vger.kernel.org
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231229120107.2281153-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/prom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 8537c354c560b..a64f4fb332893 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -369,6 +369,12 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 	if (IS_ENABLED(CONFIG_PPC64))
 		boot_cpu_hwid = be32_to_cpu(intserv[found_thread]);
 
+	if (nr_cpu_ids % nthreads != 0) {
+		set_nr_cpu_ids(ALIGN(nr_cpu_ids, nthreads));
+		pr_warn("nr_cpu_ids was not a multiple of threads_per_core, adjusted to %d\n",
+			nr_cpu_ids);
+	}
+
 	/*
 	 * PAPR defines "logical" PVR values for cpus that
 	 * meet various levels of the architecture:
-- 
2.43.0



