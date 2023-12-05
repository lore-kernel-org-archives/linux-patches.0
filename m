Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D608C07;
	Tue,  5 Dec 2023 03:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJugf6mC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B90C433C8;
	Tue,  5 Dec 2023 03:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746317;
	bh=dlds8l92xHrlWC2MQ067Ddo7+BcttbQ74jtdEoJwhlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJugf6mCFA3HLFwDT7H0IETUhckxMg3nHzTSu5Wcfp9pQY2vgi02mosZTX3o37sqm
	 WwbcSOqAMR1od3aDn7p9hhoKM4tOa+P6oGWSraeBDEJ4Er2JoKS9tFSR9OO+VdG59c
	 bfE5uIOjzFdQb/5MQNTcmay8DtHmII35SySyzqzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Stabellini <stefano.stabellini@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/30] arm/xen: fix xen_vcpu_info allocation alignment
Date: Tue,  5 Dec 2023 12:16:14 +0900
Message-ID: <20231205031511.911790242@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031511.476698159@linuxfoundation.org>
References: <20231205031511.476698159@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Stabellini <sstabellini@kernel.org>

[ Upstream commit 7bf9a6b46549852a37e6d07e52c601c3c706b562 ]

xen_vcpu_info is a percpu area than needs to be mapped by Xen.
Currently, it could cross a page boundary resulting in Xen being unable
to map it:

[    0.567318] kernel BUG at arch/arm64/xen/../../arm/xen/enlighten.c:164!
[    0.574002] Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP

Fix the issue by using __alloc_percpu and requesting alignment for the
memory allocation.

Signed-off-by: Stefano Stabellini <stefano.stabellini@amd.com>

Link: https://lore.kernel.org/r/alpine.DEB.2.22.394.2311221501340.2053963@ubuntu-linux-20-04-desktop
Fixes: 24d5373dda7c ("arm/xen: Use alloc_percpu rather than __alloc_percpu")
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/xen/enlighten.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 32aa108b2b7cd..7a18bdf32ecc2 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -376,7 +376,8 @@ static int __init xen_guest_init(void)
 	 * for secondary CPUs as they are brought up.
 	 * For uniformity we use VCPUOP_register_vcpu_info even on cpu0.
 	 */
-	xen_vcpu_info = alloc_percpu(struct vcpu_info);
+	xen_vcpu_info = __alloc_percpu(sizeof(struct vcpu_info),
+				       1 << fls(sizeof(struct vcpu_info) - 1));
 	if (xen_vcpu_info == NULL)
 		return -ENOMEM;
 
-- 
2.42.0



