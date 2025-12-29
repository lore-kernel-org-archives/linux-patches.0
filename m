Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCCB26FD9B;
	Mon, 29 Dec 2025 16:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025197; cv=none; b=BI7rzddhSAI3sIxGsicVbcRtVIC8dIDlRu0lNSD6NToJO9CioP/6QOz0u0k8vMckUd1nHHXdU3MsRkwS74pK0E4TSyKtJbdK8QRKXjemz3uNrBXTvfSde+lQz1QuoqiDcK4s5Fi762RN230x8bMiHRJJHReXLHoxjzYGGkS7TyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025197; c=relaxed/simple;
	bh=nU2e5YJ/h+IXz0PLh7fJtZul7tf/2icrX+Zj9bBkgFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsGTVt+gdMsE/ITOWZuaFlnA+pvSsLF6OAZWcQoGJPiDxP75uvTnri2sSDrhHcNHVH9wVCzml6IVTQo6RuT9f5mwzvydcbUdtwq9kvbfzVsA1x+d3VisuEG072NGtm3nAe92rDcglhf6i8UaIyH84815OrWtPumQXuq1ynZwEds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F90qBzNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F90qBzNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE90FC4CEF7;
	Mon, 29 Dec 2025 16:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025197;
	bh=nU2e5YJ/h+IXz0PLh7fJtZul7tf/2icrX+Zj9bBkgFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F90qBzNA6rF7Rs5AoNpRKU4EaWGHIxJWrna72IawehN94cVYYQ1KIjg8+hkGrGLrd
	 ym7cW8nqULdqEATTD8CJ2zdjtFZapxtlflsFy5HT/eC7dbcaq4zsiwe6nf5qYVaXGx
	 GIz9IzoZruohpYyPslDFQbvvcyUkMpqMsqDEU/bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 127/430] x86/xen: Fix sparse warning in enlighten_pv.c
Date: Mon, 29 Dec 2025 17:08:49 +0100
Message-ID: <20251229160729.040207799@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit e5aff444e3a7bdeef5ea796a2099fc3c60a070fa ]

The sparse tool issues a warning for arch/x76/xen/enlighten_pv.c:

   arch/x86/xen/enlighten_pv.c:120:9: sparse: sparse: incorrect type
     in initializer (different address spaces)
     expected void const [noderef] __percpu *__vpp_verify
     got bool *

This is due to the percpu variable xen_in_preemptible_hcall being
exported via EXPORT_SYMBOL_GPL() instead of EXPORT_PER_CPU_SYMBOL_GPL().

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512140856.Ic6FetG6-lkp@intel.com/
Fixes: fdfd811ddde3 ("x86/xen: allow privcmd hypercalls to be preempted")
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20251215115112.15072-1-jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/enlighten_pv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 4806cc28d7ca..b74ff8bc7f2a 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -108,7 +108,7 @@ static int xen_cpu_dead_pv(unsigned int cpu);
  * calls.
  */
 DEFINE_PER_CPU(bool, xen_in_preemptible_hcall);
-EXPORT_SYMBOL_GPL(xen_in_preemptible_hcall);
+EXPORT_PER_CPU_SYMBOL_GPL(xen_in_preemptible_hcall);
 
 /*
  * In case of scheduling the flag must be cleared and restored after
-- 
2.51.0



