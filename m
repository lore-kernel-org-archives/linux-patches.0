Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4131ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01383C433C8;
	Tue, 25 Jul 2023 11:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284060;
	bh=X8XpVLALfca4QiqcOu9uGQPSu1zEcxUL9KNugrRUV0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhiYWceUNF+3AsdTSxouLd3DwmyQzj194Rz4D0IykxquLmIxT43K8AQ4fHb8iAbvD
	 OXzk6q617+YtDuf6kDCPMEgH0a++RGFdX+CBWroGD3hrzE4IldFPj3k1mlCt8VILOL
	 /DLq9u7t5/yads1RNzHzozBDywOl/VCeA2vAWLCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/509] powerpc/powernv/sriov: perform null check on iov before dereferencing iov
Date: Tue, 25 Jul 2023 12:42:10 +0200
Message-ID: <20230725104602.472020121@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit f4f913c980bc6abe0ccfe88fe3909c125afe4a2d ]

Currently pointer iov is being dereferenced before the null check of iov
which can lead to null pointer dereference errors. Fix this by moving the
iov null check before the dereferencing.

Detected using cppcheck static analysis:
linux/arch/powerpc/platforms/powernv/pci-sriov.c:597:12: warning: Either
the condition '!iov' is redundant or there is possible null pointer
dereference: iov. [nullPointerRedundantCheck]
 num_vfs = iov->num_vfs;
           ^

Fixes: 052da31d45fc ("powerpc/powernv/sriov: De-indent setup and teardown")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230608095849.1147969-1-colin.i.king@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/pci-sriov.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-sriov.c b/arch/powerpc/platforms/powernv/pci-sriov.c
index 28aac933a4391..e3e52ff2cbf58 100644
--- a/arch/powerpc/platforms/powernv/pci-sriov.c
+++ b/arch/powerpc/platforms/powernv/pci-sriov.c
@@ -600,12 +600,12 @@ static void pnv_pci_sriov_disable(struct pci_dev *pdev)
 	struct pnv_iov_data   *iov;
 
 	iov = pnv_iov_get(pdev);
-	num_vfs = iov->num_vfs;
-	base_pe = iov->vf_pe_arr[0].pe_number;
-
 	if (WARN_ON(!iov))
 		return;
 
+	num_vfs = iov->num_vfs;
+	base_pe = iov->vf_pe_arr[0].pe_number;
+
 	/* Release VF PEs */
 	pnv_ioda_release_vf_PE(pdev);
 
-- 
2.39.2



