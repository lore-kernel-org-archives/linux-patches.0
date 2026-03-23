Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23771F91F6;
	Mon, 23 Mar 2026 14:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275446; cv=none; b=LrewAKrDRekH+PPKCSa/dfrOD/FRYbzP1lp/F6Wt1/yb2FNDY7pXOelBkC2Aq0NYHwVMT0UEqurIvW5NmGYKAPJcxB2FX5MzH80ezFowE+H7s1/aI8VvRTuCtO9fBM++tlWFr4enYzD47ZvBY3+IqbgPHky8sX5itsx6fbrJHIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275446; c=relaxed/simple;
	bh=d6zwCY4cBrLwSprruLdEfME985001FmSlHdGcf2yC2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FptsmCVrVBcQH/uO9KYvObgmGu8hZKkkEWX6ZExBIYLR3ZSkZJE40YWKVhyfHRXrUWubegdkBv0kzUjDaEcVCoMWFpRr575JtkjdDsaXhVdBnMChNnpGdvqhEDNrKfV+vA/PlogNFgQZMaTXpD72r9ri98CLxIvNcqNF4SsVGQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEO2cVwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEO2cVwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84739C4CEF7;
	Mon, 23 Mar 2026 14:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275445;
	bh=d6zwCY4cBrLwSprruLdEfME985001FmSlHdGcf2yC2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEO2cVwxpPwKo2LmlOhrpCLcSV1OxtQASn7DKVNAefK3vzX10XgDZH0klKLRKjbk/
	 0zfKX3YfehUBgnD6ciAoLXGm4kqd7S+hW7tSFl/78Il9chhfUuwQcincGK36DylpBT
	 K3u1LhN4BxZy0/rh8ZbJOB/W6QhExsA/zaW/yL3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/460] xdp: register system page pool as an XDP memory model
Date: Mon, 23 Mar 2026 14:40:56 +0100
Message-ID: <20260323134528.185755150@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit e77d9aee951341119be16a991fcfc76d1154d22a ]

To make the system page pool usable as a source for allocating XDP
frames, we need to register it with xdp_reg_mem_model(), so that page
return works correctly. This is done in preparation for using the system
page_pool to convert XDP_PASS XSk frames to skbs; for the same reason,
make the per-cpu variable non-static so we can access it from other
source files as well (but w/o exporting).

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://patch.msgid.link/20241203173733.3181246-7-aleksander.lobakin@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6f1a9140ecda ("net: add xmit recursion limit to tunnel xmit functions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3699c43731ccf..d5215f23f2b99 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3256,6 +3256,7 @@ struct softnet_data {
 };
 
 DECLARE_PER_CPU_ALIGNED(struct softnet_data, softnet_data);
+DECLARE_PER_CPU(struct page_pool *, system_page_pool);
 
 #ifndef CONFIG_PREEMPT_RT
 static inline int dev_recursion_level(void)
diff --git a/net/core/dev.c b/net/core/dev.c
index a855cee5e5aeb..336257b515f04 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -460,7 +460,7 @@ EXPORT_PER_CPU_SYMBOL(softnet_data);
  * PP consumers must pay attention to run APIs in the appropriate context
  * (e.g. NAPI context).
  */
-static DEFINE_PER_CPU(struct page_pool *, system_page_pool);
+DEFINE_PER_CPU(struct page_pool *, system_page_pool);
 
 #ifdef CONFIG_LOCKDEP
 /*
@@ -12225,11 +12225,18 @@ static int net_page_pool_create(int cpuid)
 		.nid = cpu_to_mem(cpuid),
 	};
 	struct page_pool *pp_ptr;
+	int err;
 
 	pp_ptr = page_pool_create_percpu(&page_pool_params, cpuid);
 	if (IS_ERR(pp_ptr))
 		return -ENOMEM;
 
+	err = xdp_reg_page_pool(pp_ptr);
+	if (err) {
+		page_pool_destroy(pp_ptr);
+		return err;
+	}
+
 	per_cpu(system_page_pool, cpuid) = pp_ptr;
 #endif
 	return 0;
@@ -12363,6 +12370,7 @@ static int __init net_dev_init(void)
 			if (!pp_ptr)
 				continue;
 
+			xdp_unreg_page_pool(pp_ptr);
 			page_pool_destroy(pp_ptr);
 			per_cpu(system_page_pool, i) = NULL;
 		}
-- 
2.51.0



