Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A335B30C37A;
	Thu,  2 Jul 2026 16:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010559; cv=none; b=f8YRVKXx6Zvac7Z1YW1FBAosQZ9hCnXkyZaO+Oncq6brmSI0h2YbLcsgEVySYF2Y9PsPQn+21hj1NlF+RzbCA+ZXdEFAA4GVp8ptp0F5eRQksh6Rf+PpKqq8/P00EZLmZxTWaUliBl/azDHd/SA0eAAz5i1a3F5qJWM6DveWPQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010559; c=relaxed/simple;
	bh=3J434RzIcTR9Rjw09PO5AjtYnrVakEws82zBRuTa/bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFdZfPL8+PYApt1C30jDqNNTEsx+/pcZuMU3J2mzX1nTtZom/oyPBWTD0RKfgGQcEOFdb5b1OzP89X6FunKVjBAKDhXLUDRLpPl46OXBfc9sWv/fnxGpiT9suQzIrfI+35JlBC69oeOohWD2magmGd/NLGowjFr/gnXS9Rr1YYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQH5oTVY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQH5oTVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153AE1F000E9;
	Thu,  2 Jul 2026 16:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010558;
	bh=jePCEF5qNQHN8B6prVAjUZY7zdC6/scf1i/govnjlsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQH5oTVYcOgGbfbCfztb2kuFv9fY6Wj3xLLJ/Hg7mCH4+AXM3GVhhI1Du223LShio
	 UiJkSRE0tE/B3s7f2FLvefuzT+IpEOLcrLA0daW0etnmzC5Iu2V61oc+5zb7farS2h
	 ZrdEyE27DBYmMkjkp+B4djUK0vumEQJCgs6HCbbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Junjie Cao <junjie.cao@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.12 153/204] wifi: iwlwifi: mvm: fix race condition in PTP removal
Date: Thu,  2 Jul 2026 18:20:10 +0200
Message-ID: <20260702155121.863240811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -316,11 +316,11 @@ void iwl_mvm_ptp_remove(struct iwl_mvm *
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


