Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A6AD512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9BDC433D2;
	Mon, 12 Jun 2023 10:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566945;
	bh=zZwNJA1cWHiwJ8+WmY0D0tpx2UxwYKlywa6iFeeYRu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXI5Dhkx3DQmOwjEeKr5feC2+i/lbmYh6rWd25BXAr1JwksUOdYBiY+XNFz4a+Y69
	 mS3hOA72IcnxoAMOMk5ecdbmAAVg0NLjfAagWcCpf5qLmgTMYlwnJ2a1lw4xz17L9s
	 vZ87AdeMQ04GLqQ1zkz8HLymHAk5R+Cc3lm+9Nr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.3 092/160] wifi: iwlwifi: mvm: Fix -Warray-bounds bug in iwl_mvm_wait_d3_notif()
Date: Mon, 12 Jun 2023 12:27:04 +0200
Message-ID: <20230612101719.230793849@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit 7a4615b9a9da5225b22b36a20508555dd133ac24 upstream.

kmemdup() at line 2735 is not duplicating enough memory for
notif->tid_tear_down and notif->station_id. As it only duplicates
612 bytes: up to offsetofend(struct iwl_wowlan_info_notif,
received_beacons), this is the range of [0, 612) bytes.

2735	notif = kmemdup(notif_v1,
2736			offsetofend(struct iwl_wowlan_info_notif,
2737				    received_beacons),
2738			GFP_ATOMIC);

which evidently does not cover bytes 612 and 613 for members
tid_tear_down and station_id in struct iwl_wowlan_info_notif.
See below:

$ pahole -C iwl_wowlan_info_notif drivers/net/wireless/intel/iwlwifi/mvm/d3.o
struct iwl_wowlan_info_notif {
	struct iwl_wowlan_gtk_status_v3 gtk[2];          /*     0   488 */
	/* --- cacheline 7 boundary (448 bytes) was 40 bytes ago --- */
	struct iwl_wowlan_igtk_status igtk[2];           /*   488    80 */
	/* --- cacheline 8 boundary (512 bytes) was 56 bytes ago --- */
	__le64                     replay_ctr;           /*   568     8 */
	/* --- cacheline 9 boundary (576 bytes) --- */
	__le16                     pattern_number;       /*   576     2 */
	__le16                     reserved1;            /*   578     2 */
	__le16                     qos_seq_ctr[8];       /*   580    16 */
	__le32                     wakeup_reasons;       /*   596     4 */
	__le32                     num_of_gtk_rekeys;    /*   600     4 */
	__le32                     transmitted_ndps;     /*   604     4 */
	__le32                     received_beacons;     /*   608     4 */
	u8                         tid_tear_down;        /*   612     1 */
	u8                         station_id;           /*   613     1 */
	u8                         reserved2[2];         /*   614     2 */

	/* size: 616, cachelines: 10, members: 13 */
	/* last cacheline: 40 bytes */
};

Therefore, when the following assignments take place, actually no memory
has been allocated for those objects:

2743	notif->tid_tear_down = notif_v1->tid_tear_down;
2744	notif->station_id = notif_v1->station_id;

Fix this by allocating space for the whole notif object and zero out the
remaining space in memory after member station_id.

This also fixes the following -Warray-bounds issues:
 CC      drivers/net/wireless/intel/iwlwifi/mvm/d3.o
drivers/net/wireless/intel/iwlwifi/mvm/d3.c: In function ‘iwl_mvm_wait_d3_notif’:
drivers/net/wireless/intel/iwlwifi/mvm/d3.c:2743:30: warning: array subscript ‘struct iwl_wowlan_info_notif[0]’ is partly outside array bounds of ‘unsigned char[612]’ [-Warray-bounds=]
 2743 |                         notif->tid_tear_down = notif_v1->tid_tear_down;
      |
                 from drivers/net/wireless/intel/iwlwifi/mvm/d3.c:7:
In function ‘kmemdup’,
    inlined from ‘iwl_mvm_wait_d3_notif’ at drivers/net/wireless/intel/iwlwifi/mvm/d3.c:2735:12:
include/linux/fortify-string.h:765:16: note: object of size 612 allocated by ‘__real_kmemdup’
  765 |         return __real_kmemdup(p, size, gfp);
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/intel/iwlwifi/mvm/d3.c: In function ‘iwl_mvm_wait_d3_notif’:
drivers/net/wireless/intel/iwlwifi/mvm/d3.c:2744:30: warning: array subscript ‘struct iwl_wowlan_info_notif[0]’ is partly outside array bounds of ‘unsigned char[612]’ [-Warray-bounds=]
 2744 |                         notif->station_id = notif_v1->station_id;
      |                              ^~
In function ‘kmemdup’,
    inlined from ‘iwl_mvm_wait_d3_notif’ at drivers/net/wireless/intel/iwlwifi/mvm/d3.c:2735:12:
include/linux/fortify-string.h:765:16: note: object of size 612 allocated by ‘__real_kmemdup’
  765 |         return __real_kmemdup(p, size, gfp);
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

Link: https://github.com/KSPP/linux/issues/306
Fixes: 905d50ddbc83 ("wifi: iwlwifi: mvm: support wowlan info notification version 2")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/ZHpGN555FwAKGduH@work
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2729,17 +2729,13 @@ static bool iwl_mvm_wait_d3_notif(struct
 		if (wowlan_info_ver < 2) {
 			struct iwl_wowlan_info_notif_v1 *notif_v1 = (void *)pkt->data;
 
-			notif = kmemdup(notif_v1,
-					offsetofend(struct iwl_wowlan_info_notif,
-						    received_beacons),
-					GFP_ATOMIC);
-
+			notif = kmemdup(notif_v1, sizeof(*notif), GFP_ATOMIC);
 			if (!notif)
 				return false;
 
 			notif->tid_tear_down = notif_v1->tid_tear_down;
 			notif->station_id = notif_v1->station_id;
-
+			memset_after(notif, 0, station_id);
 		} else {
 			notif = (void *)pkt->data;
 		}


