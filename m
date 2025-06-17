Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63632EB5AB;
	Tue, 17 Jun 2025 15:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174824; cv=none; b=htjClFQgeH9iIs8DytByfYmGSG/F6NSrQHj8wn9J6oY2nOcu+yu+5t8ppoEtnlP99JMCu3scKVxsurLZ6Lhum68mHrFrcxW8eVvdAx3YyONhcEZ5W5Gom6CEFCwYzuIezsPo+OTwY0o/ZZziN50fDnDm7c76jfTv+GUPLMYB1D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174824; c=relaxed/simple;
	bh=h1tAG1q7Xcsghly2q3v90Wyowi5VvGLdbSxgpQcpAzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruLAEh0xym6qxCqPo/yQd+zLEth9Rg65g9Cb52Eavt1xhDRH/p+W+JKzn9zCE19AuW4kkRqpdL9J8JPsb46Z0J2gTd4hbB9gNWoyKihrJaF5Orr/CFqdvmKPq+LPsGtXtv535+ICJJa0WBMZ/uztc+IpS1HsZuHCVHlpMcIUAlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNkoOPrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNkoOPrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B6CC4CEE7;
	Tue, 17 Jun 2025 15:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174823;
	bh=h1tAG1q7Xcsghly2q3v90Wyowi5VvGLdbSxgpQcpAzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNkoOPrx/ww6XXgGtUr83h2xcrbooaN5KLmSyU850ScSl/FdtSJgjYSRkVleLWhqW
	 qAj9aRClExNJqHR3xQ7tojZWn4KsTGw8gwaH/A345WXP3gWheX1um2aik6m6ExfNXo
	 a4KmcbnreaQojN3uDMOA9H/+ZcTzmivK0xatrgWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Annie Li <jiayanli@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 024/780] x86/microcode/AMD: Do not return error when microcode update is not necessary
Date: Tue, 17 Jun 2025 17:15:32 +0200
Message-ID: <20250617152452.493239051@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Annie Li <jiayanli@google.com>

[ Upstream commit b43dc4ab097859c24e2a6993119c927cffc856aa ]

After

  6f059e634dcd("x86/microcode: Clarify the late load logic"),

if the load is up-to-date, the AMD side returns UCODE_OK which leads to
load_late_locked() returning -EBADFD.

Handle UCODE_OK in the switch case to avoid this error.

  [ bp: Massage commit message. ]

Fixes: 6f059e634dcd ("x86/microcode: Clarify the late load logic")
Signed-off-by: Annie Li <jiayanli@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250430053424.77438-1-jiayanli@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 079f046ee26d1..e8021d3e58824 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -696,6 +696,8 @@ static int load_late_locked(void)
 		return load_late_stop_cpus(true);
 	case UCODE_NFOUND:
 		return -ENOENT;
+	case UCODE_OK:
+		return 0;
 	default:
 		return -EBADFD;
 	}
-- 
2.39.5



