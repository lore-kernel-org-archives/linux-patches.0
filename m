Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DC314A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="biULYfxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BA9C433CA;
	Mon, 23 Oct 2023 11:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059127;
	bh=PfSm7KT/m/cjifK3/Ra0rT9SkEOY+S+f8UHSrdaTbH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=biULYfxu4qhfTmOCrK1X/dYgTS05HEC5UKVktJ+5N20y60Nkftr5OFBVL9x91Dvqb
	 AxiWXN/oAHrowi6JFPmXfZEQ6Rj0pQ3GCwyVFX6j87WK5MMPv3gJYI+l/gks/+O01i
	 /1PMupLE5tccYh3jSnbsNuj1xEoTPT3lBLS6SiKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.5 073/241] i40e: prevent crash on probe if hw registers have invalid values
Date: Mon, 23 Oct 2023 12:54:19 +0200
Message-ID: <20231023104835.672962681@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1082,7 +1082,7 @@ void i40e_clear_hw(struct i40e_hw *hw)
 		     I40E_PFLAN_QALLOC_FIRSTQ_SHIFT;
 	j = (val & I40E_PFLAN_QALLOC_LASTQ_MASK) >>
 	    I40E_PFLAN_QALLOC_LASTQ_SHIFT;
-	if (val & I40E_PFLAN_QALLOC_VALID_MASK)
+	if (val & I40E_PFLAN_QALLOC_VALID_MASK && j >= base_queue)
 		num_queues = (j - base_queue) + 1;
 	else
 		num_queues = 0;
@@ -1092,7 +1092,7 @@ void i40e_clear_hw(struct i40e_hw *hw)
 	    I40E_PF_VT_PFALLOC_FIRSTVF_SHIFT;
 	j = (val & I40E_PF_VT_PFALLOC_LASTVF_MASK) >>
 	    I40E_PF_VT_PFALLOC_LASTVF_SHIFT;
-	if (val & I40E_PF_VT_PFALLOC_VALID_MASK)
+	if (val & I40E_PF_VT_PFALLOC_VALID_MASK && j >= i)
 		num_vfs = (j - i) + 1;
 	else
 		num_vfs = 0;


