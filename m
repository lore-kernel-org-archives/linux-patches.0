Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17FE101D9
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8barPue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFDBC433C8;
	Mon, 23 Oct 2023 11:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061642;
	bh=P7SVsYwQ5ea6iwvC0EYOSkm2WKQ0KgnFWw13ZmRcy4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8barPueMhQZSg8f9vi5vbsWt5T2HeWp8sGA5BXgzw3H0Piy0vT8LHF7EUFU15c3H
	 Du4B3Xta4p5fivCfdUOTd1mUQOkktsOsctb8XKzl97n0NroxbMLbQGBYMwP4QWW0l1
	 VWbsRXk8L4RfzWiHdDqrVV1J57u1DTPdrey6xvrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 5.10 115/202] i40e: prevent crash on probe if hw registers have invalid values
Date: Mon, 23 Oct 2023 12:57:02 +0200
Message-ID: <20231023104829.896285755@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1339,7 +1339,7 @@ void i40e_clear_hw(struct i40e_hw *hw)
 		     I40E_PFLAN_QALLOC_FIRSTQ_SHIFT;
 	j = (val & I40E_PFLAN_QALLOC_LASTQ_MASK) >>
 	    I40E_PFLAN_QALLOC_LASTQ_SHIFT;
-	if (val & I40E_PFLAN_QALLOC_VALID_MASK)
+	if (val & I40E_PFLAN_QALLOC_VALID_MASK && j >= base_queue)
 		num_queues = (j - base_queue) + 1;
 	else
 		num_queues = 0;
@@ -1349,7 +1349,7 @@ void i40e_clear_hw(struct i40e_hw *hw)
 	    I40E_PF_VT_PFALLOC_FIRSTVF_SHIFT;
 	j = (val & I40E_PF_VT_PFALLOC_LASTVF_MASK) >>
 	    I40E_PF_VT_PFALLOC_LASTVF_SHIFT;
-	if (val & I40E_PF_VT_PFALLOC_VALID_MASK)
+	if (val & I40E_PF_VT_PFALLOC_VALID_MASK && j >= i)
 		num_vfs = (j - i) + 1;
 	else
 		num_vfs = 0;


