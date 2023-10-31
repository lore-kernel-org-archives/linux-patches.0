Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6D3208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNctvWkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0291C433CB;
	Tue, 31 Oct 2023 17:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774498;
	bh=MYHPeqnmScChCwTdJff+4CRpLLItqqFA8VK7w3MZ0FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNctvWkRlgK7TqGbTeYrI0yecNANk6tmCnjhoxGEkOcxleLHUW40ukRSzv6Oc0Sjn
	 MYWxrRD2uWkr0fzx7Loy8YsFfAl+sCuJPZ9lOa599xrN1/RbREaUArTU7zoBFV+pVM
	 dNMR3MjTlPtHnJy2wwwb+L8sJpuMaBBgT8DK9P44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	hq.dev+kernel@msdfc.xyz,
	Tirthendu Sarkar <tirthendu.sarkar@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH 6.5 022/112] i40e: sync next_to_clean and next_to_process for programming status desc
Date: Tue, 31 Oct 2023 18:00:23 +0100
Message-ID: <20231031165902.009158690@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>

commit 068d8b75c1aee153193522211ace6c13c21cd16b upstream.

When a programming status desc is encountered on the rx_ring,
next_to_process is bumped along with cleaned_count but next_to_clean is
not. This causes I40E_DESC_UNUSED() macro to misbehave resulting in
overwriting whole ring with new buffers.

Update next_to_clean to point to next_to_process on seeing a programming
status desc if not in the middle of handling a multi-frag packet. Also,
bump cleaned_count only for such case as otherwise next_to_clean buffer
may be returned to hardware on reaching clean_threshold.

Fixes: e9031f2da1ae ("i40e: introduce next_to_process to i40e_ring")
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reported-by: hq.dev+kernel@msdfc.xyz
Reported by: Solomon Peachy <pizza@shaftnet.org>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217678
Tested-by: hq.dev+kernel@msdfc.xyz
Tested by: Indrek Järve <incx@dustbite.net>
Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20231019203852.3663665-1-jacob.e.keller@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 0b3a27f118fb..50c70a8e470a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2544,7 +2544,14 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
 			rx_buffer = i40e_rx_bi(rx_ring, ntp);
 			i40e_inc_ntp(rx_ring);
 			i40e_reuse_rx_page(rx_ring, rx_buffer);
-			cleaned_count++;
+			/* Update ntc and bump cleaned count if not in the
+			 * middle of mb packet.
+			 */
+			if (rx_ring->next_to_clean == ntp) {
+				rx_ring->next_to_clean =
+					rx_ring->next_to_process;
+				cleaned_count++;
+			}
 			continue;
 		}
 
-- 
2.42.0



