Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8468C14282
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4r+js+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11A9C433C8;
	Mon, 23 Oct 2023 11:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059831;
	bh=txzMAzRMB4zHXnCdzcmw2U6qxjcEArFD8FmySzRhCsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4r+js+OLB+hK8fOHsdiSAfNSkO31daGZnqKGxONfnEPB/klIGg8SZp9hLD+lKALl
	 z9k4UyRspNjYasAc1IsFJ4GSkd4iM7bENUiX5l4/OBAI+rXgeQ3DzDUVgdbTUVEyO/
	 /KbsGaUm2bSJzXkXcmQKWvdEc8aT/xhFPnB4TA9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 4.19 60/98] i40e: prevent crash on probe if hw registers have invalid values
Date: Mon, 23 Oct 2023 12:56:49 +0200
Message-ID: <20231023104815.732145791@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
References: <20231023104813.580375891@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

commit fc6f716a5069180c40a8c9b63631e97da34f64a3 upstream.

The hardware provides the indexes of the first and the last available
queue and VF. From the indexes, the driver calculates the numbers of
queues and VFs. In theory, a faulty device might say the last index is
smaller than the first index. In that case, the driver's calculation
would underflow, it would attempt to write to non-existent registers
outside of the ioremapped range and crash.

I ran into this not by having a faulty device, but by an operator error.
I accidentally ran a QE test meant for i40e devices on an ice device.
The test used 'echo i40e > /sys/...ice PCI device.../driver_override',
bound the driver to the device and crashed in one of the wr32 calls in
i40e_clear_hw.

Add checks to prevent underflows in the calculations of num_queues and
num_vfs. With this fix, the wrong device probing reports errors and
returns a failure without crashing.

Fixes: 838d41d92a90 ("i40e: clear all queues and interrupts")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Link: https://lore.kernel.org/r/20231011233334.336092-2-jacob.e.keller@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1332,7 +1332,7 @@ void i40e_clear_hw(struct i40e_hw *hw)
 		     I40E_PFLAN_QALLOC_FIRSTQ_SHIFT;
 	j = (val & I40E_PFLAN_QALLOC_LASTQ_MASK) >>
 	    I40E_PFLAN_QALLOC_LASTQ_SHIFT;
-	if (val & I40E_PFLAN_QALLOC_VALID_MASK)
+	if (val & I40E_PFLAN_QALLOC_VALID_MASK && j >= base_queue)
 		num_queues = (j - base_queue) + 1;
 	else
 		num_queues = 0;
@@ -1342,7 +1342,7 @@ void i40e_clear_hw(struct i40e_hw *hw)
 	    I40E_PF_VT_PFALLOC_FIRSTVF_SHIFT;
 	j = (val & I40E_PF_VT_PFALLOC_LASTVF_MASK) >>
 	    I40E_PF_VT_PFALLOC_LASTVF_SHIFT;
-	if (val & I40E_PF_VT_PFALLOC_VALID_MASK)
+	if (val & I40E_PF_VT_PFALLOC_VALID_MASK && j >= i)
 		num_vfs = (j - i) + 1;
 	else
 		num_vfs = 0;


