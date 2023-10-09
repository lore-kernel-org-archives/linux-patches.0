Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0C8199B3;
	Mon,  9 Oct 2023 13:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXEFgXwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91CFC433C7;
	Mon,  9 Oct 2023 13:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857459;
	bh=Q/U5fLrR6w9ER1LNqbdTr91noNQ83AyAgj6MM0UCiVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXEFgXwcwzMHwa/fJZzQFVhh47qPk6EjdnvnjbUho1Hazi0eLtgiPA/TGceMlAFnh
	 32GzZgRlBznH9qItes4fJPOmavlWvkZYtN4iCqP//V3kyALkyj+CmlASqs8tNodz6Y
	 geG/5B35A9FEUvGMZmFH7+1JIlsbElmnLB//gIZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Yajun Deng" <yajun.deng@linux.dev>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH 6.1 053/162] i40e: fix the wrong PTP frequency calculation
Date: Mon,  9 Oct 2023 15:00:34 +0200
Message-ID: <20231009130124.398550576@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yajun Deng <yajun.deng@linux.dev>

The new adjustment should be based on the base frequency, not the
I40E_PTP_40GB_INCVAL in i40e_ptp_adjfine().

This issue was introduced in commit 3626a690b717 ("i40e: use
mul_u64_u64_div_u64 for PTP frequency calculation"), frequency is left
just as base I40E_PTP_40GB_INCVAL before the commit. After the commit,
frequency is the I40E_PTP_40GB_INCVAL times the ptp_adj_mult value.
But then the diff is applied on the wrong value, and no multiplication
is done afterwards.

It was accidentally fixed in commit 1060707e3809 ("ptp: introduce helpers
to adjust by scaled parts per million"). It uses adjust_by_scaled_ppm
correctly performs the calculation and uses the base adjustment, so
there's no error here. But it is a new feature and doesn't need to
backported to the stable releases.

This issue affects both v6.0 and v6.1, and the v6.1 version is an LTS
release. Therefore, the patch only needs to be applied to v6.1 stable.

Fixes: 3626a690b717 ("i40e: use mul_u64_u64_div_u64 for PTP frequency calculation")
Cc: <stable@vger.kernel.org> # 6.1
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_ptp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -361,9 +361,9 @@ static int i40e_ptp_adjfine(struct ptp_c
 				   1000000ULL << 16);
 
 	if (neg_adj)
-		adj = I40E_PTP_40GB_INCVAL - diff;
+		adj = freq - diff;
 	else
-		adj = I40E_PTP_40GB_INCVAL + diff;
+		adj = freq + diff;
 
 	wr32(hw, I40E_PRTTSYN_INC_L, adj & 0xFFFFFFFF);
 	wr32(hw, I40E_PRTTSYN_INC_H, adj >> 32);


