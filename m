Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5173A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2e8xy1nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC274C433C8;
	Wed, 15 Nov 2023 19:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077749;
	bh=ctZtkCOMYx87arsnCZzSBtJPXuZzwh5uF8nAoiufaIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2e8xy1njLe1EP240yUfdAXQldOenLFSK86AwuTMXN2ITjuT75jqPHmS2Udu/ny7/g
	 XsfOtoZcP2YOO+lABVufx0MmylEiP3DSTpwDRG3Y6jh3iVWa/OdBr/GH1htS8Q+Usl
	 K9kNsKPfObyJhzpAwVvBFGlvy8oMxnMPfCu63Cv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 474/603] powerpc/pseries: fix potential memory leak in init_cpu_associativity()
Date: Wed, 15 Nov 2023 14:16:59 -0500
Message-ID: <20231115191645.277819273@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 95f1a128cd728a7257d78e868f1f5a145fc43736 ]

If the vcpu_associativity alloc memory successfully but the
pcpu_associativity fails to alloc memory, the vcpu_associativity
memory leaks.

Fixes: d62c8deeb6e6 ("powerpc/pseries: Provide vcpu dispatch statistics")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Reviewed-by: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/1671003983-10794-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/lpar.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index f2cb62148f36f..d4d6de0628b05 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -526,8 +526,10 @@ static ssize_t vcpudispatch_stats_write(struct file *file, const char __user *p,
 
 	if (cmd) {
 		rc = init_cpu_associativity();
-		if (rc)
+		if (rc) {
+			destroy_cpu_associativity();
 			goto out;
+		}
 
 		for_each_possible_cpu(cpu) {
 			disp = per_cpu_ptr(&vcpu_disp_data, cpu);
-- 
2.42.0



