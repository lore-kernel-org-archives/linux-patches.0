Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B513093DD;
	Thu,  2 Jul 2026 16:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011300; cv=none; b=NbaFOfU9WQjePl3I8BRdyOZmbspWH3L28yhG+WaoHYMmjpcDilSa/7Bw/xfadPbkR8mCII1RtCEn6PrpGRDN762T77pKPlqaTnH2OcYm1m2rrMBiYR5tYH8HZexxTEXArdq8NtcRW0uvbWjPZ4/KzLMAdGA9Cue2gX+jG02hBeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011300; c=relaxed/simple;
	bh=eF8puqzZXTm+S5QBAsR5rtBBiA1DcT1A9P/pTx5iCyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eq+aA1QRBTaWPZzK88VClYDPz8fXqvJ4PPJD6UIzJtJZs6XcVrVzwZ5PdI4cLBXr47+3DavJ6FY5UP5OrzKMEMNjl0STgODtaPMSBOfOCwGUd5vQAFsqPTibnIAeU2DYapAHMlN8uAX5XlfJr2fkHTfD10ZEtHU3A/t5BjiT6Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eW/RWJis; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eW/RWJis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6D71F000E9;
	Thu,  2 Jul 2026 16:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011299;
	bh=K2Jro+PTFmhU0Se5eKgEewj0/k6AfOqmdne3ayUJWg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eW/RWJisbKmx5JWzxqG+IAweQJuLuN73DwDAjYOCPQOEOl+rh2IIJ/S7On07CO0Aq
	 lPCU9A4P660gqCId6WIzoXtv7n/7+hCUEjUvc3Hs+OAhfjFOjIwouf9bogDKesB3pt
	 F9VZC/IAflTpX9BHnyOaBx73Xa5IqayjN/LzK0i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Junjie Cao <junjie.cao@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.18 057/108] wifi: iwlwifi: mvm: fix race condition in PTP removal
Date: Thu,  2 Jul 2026 18:20:54 +0200
Message-ID: <20260702155113.290793147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -323,11 +323,11 @@ void iwl_mvm_ptp_remove(struct iwl_mvm *
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


