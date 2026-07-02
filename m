Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C67C33B951;
	Thu,  2 Jul 2026 17:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011702; cv=none; b=OLjezIR27/MSF9J0v+dAAoze4upSFbuKLXWxaA1GHDIWzq5uqw9nUvjoaxPRfMIQJduQvIzzOeHCh5RB8ejntTCHvgavBudsXS6z6Qod4c0Yabm6jo8QEYZLVsxrzL4PWjsKqxqEo+iGNS5x7xZncVRacfDvy7iujt/yfZrILiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011702; c=relaxed/simple;
	bh=GJKsW0ZTuWBFDYeZMoJtORXfzaxoDOcaGESxRErEw7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCjyoDvG8yzyormYG4bkaL3Ge022PHhttqEtdo7qTChHgev3NmXHTlyRJECYfadCH47wpQy+7Bp5L/94s3K2z9RiX5V+tQ8Csgy9r/7PExQiczlENl5HbdjhOnj3zG4N4Tl1sP22K73kTscpx3TLPYZUTfOg02hdENMqtEDEMuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QG+7Ab5c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QG+7Ab5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B542A1F000E9;
	Thu,  2 Jul 2026 17:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011701;
	bh=6CMuobbF6oCSFsrHM2a3fZIpNMl/UGwgmkdmBSOjnBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QG+7Ab5cjs0Iz6uSi4Tw3KVpbWN/wU/aqHLAI9+yEOv9BdDcrNaWu4n5U8SW//edi
	 cbkMucJSQFrnKn1IxFpbglStcY39XEjhGusDW9lAQ+VHJoDsSaVBBo9MrMSamKmhZY
	 /bytsQGZKJv1xP2aKSEGcyZF4QdrbD+ed9lBU0no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Junjie Cao <junjie.cao@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 7.1 056/120] wifi: iwlwifi: mvm: fix race condition in PTP removal
Date: Thu,  2 Jul 2026 18:20:52 +0200
Message-ID: <20260702155114.122697547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junjie Cao <junjie.cao@intel.com>

commit 65150c9cc3e06ab54bc4e8134a47f6f5d095a4e3 upstream.

iwl_mvm_ptp_remove() calls cancel_delayed_work_sync() only after
ptp_clock_unregister() and clearing ptp_data state (ptp_clock,
ptp_clock_info, last_gp2).

This creates a race where the delayed work iwl_mvm_ptp_work() can
execute between ptp_clock_unregister() and cancel_delayed_work_sync(),
observing partially cleared PTP state.

Move cancel_delayed_work_sync() before ptp_clock_unregister() to
ensure the delayed work is fully stopped before any PTP cleanup
begins.

Cc: stable@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Link: https://patch.msgid.link/20260212125035.1345718-1-junjie.cao@intel.com
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
@@ -325,11 +325,11 @@ void iwl_mvm_ptp_remove(struct iwl_mvm *
 			       mvm->ptp_data.ptp_clock_info.name,
 			       ptp_clock_index(mvm->ptp_data.ptp_clock));
 
+		cancel_delayed_work_sync(&mvm->ptp_data.dwork);
 		ptp_clock_unregister(mvm->ptp_data.ptp_clock);
 		mvm->ptp_data.ptp_clock = NULL;
 		memset(&mvm->ptp_data.ptp_clock_info, 0,
 		       sizeof(mvm->ptp_data.ptp_clock_info));
 		mvm->ptp_data.last_gp2 = 0;
-		cancel_delayed_work_sync(&mvm->ptp_data.dwork);
 	}
 }


