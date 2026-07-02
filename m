Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A631731DD97;
	Thu,  2 Jul 2026 16:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011586; cv=none; b=qDUdfl0ROtD/xe/R1dKMGmJVEiMu8G1pTkFsa3+ohRaJFnmh7EqLV2a2wAobOjYl7B/vSAIX9XmwAjr19P8Aps2sOG7/Y8AV4g1IH+VDRFD7LIP83ogzO8aH5XvksTYBtcv9U7Sw30YQMS3aMWQRBcfqpvN/2cutm92f/yMDTWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011586; c=relaxed/simple;
	bh=+csx7Tudl64XD8lH/aHX55/EMtxtuL78QoYZFgDePqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXHvzU/Hpyes0u8Iouh8PWeBy4recnalR9wEL7MJ438ptyNEU9vLY6Rk8YtwtfPycAvYclscjHSvaDpBYbrbErTdFfMmxEwAvvjBSX7zMQjHGKd/g3CkSNf7WAKNDN16kG4z4C2aWQeAo3J80+G6jmn0Zr3JsNNqddWiPz8vnVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VvG3dc3n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VvG3dc3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177E51F00A3A;
	Thu,  2 Jul 2026 16:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011585;
	bh=g6D0qDLQMgvFiP4PnensUdArIpLA07MatbeNr+eQCk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VvG3dc3n8VYjJ4YWkZv24ubMdANoiC4Vt4ZQvvPq7VpkbkmO8j/dZa9GZB8qOilSb
	 ISB0ezanD+4+iWiHreUnekpdfMFKnZhzcWUHSp+AZ0ZtDr7Vjy5aQZw+prjzB2ZZth
	 hB/dZmUZWR3lGROpwV3urY0H0u60FYAkn45+QEhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Junjie Cao <junjie.cao@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 7.1 057/120] wifi: iwlwifi: mld: fix race condition in PTP removal
Date: Thu,  2 Jul 2026 18:20:53 +0200
Message-ID: <20260702155114.143278870@linuxfoundation.org>
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

commit e1fc08598aa34b28359831e768076f56632720c1 upstream.

iwl_mld_ptp_remove() calls cancel_delayed_work_sync() only after
ptp_clock_unregister() and clearing ptp_data state (ptp_clock,
last_gp2, wrap_counter).

This creates a race where the delayed work iwl_mld_ptp_work() can
execute between ptp_clock_unregister() and cancel_delayed_work_sync(),
observing partially cleared PTP state.

Move cancel_delayed_work_sync() before ptp_clock_unregister() to
ensure the delayed work is fully stopped before any PTP cleanup
begins.

Cc: stable@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Link: https://patch.msgid.link/20260212125035.1345718-2-junjie.cao@intel.com
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/ptp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ptp.c
@@ -321,10 +321,10 @@ void iwl_mld_ptp_remove(struct iwl_mld *
 			       mld->ptp_data.ptp_clock_info.name,
 			       ptp_clock_index(mld->ptp_data.ptp_clock));
 
+		cancel_delayed_work_sync(&mld->ptp_data.dwork);
 		ptp_clock_unregister(mld->ptp_data.ptp_clock);
 		mld->ptp_data.ptp_clock = NULL;
 		mld->ptp_data.last_gp2 = 0;
 		mld->ptp_data.wrap_counter = 0;
-		cancel_delayed_work_sync(&mld->ptp_data.dwork);
 	}
 }


