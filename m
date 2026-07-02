Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0194782866;
	Thu,  2 Jul 2026 16:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011303; cv=none; b=ZsPubjyWarYX+4tK/wfdycq7eRMnv1G/WZgVQWxPUFQhBSeMmfThMbNQPfIKuoLuCdDSbiwX1YlOJLq5pstGDvDG1rO9RotW4Vi0ZsQmE39I/G+MKqdTRnuFD1vubDAWa2YPzGJVzVT9LE9ZkG9GOyas38wruNj1S4AUdNWgR7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011303; c=relaxed/simple;
	bh=YcP7KgPGEMttQY/gxQUSWN1FdCiTw6D2M7gW7RxQ72g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVeMfkUKZTROaKul3ER7qXkL6bbdFHxtDi6h0GxD8bh7EgQvVOYJ4mugWmq3kch1KEY3pYFtSCYmM8Z2pnLvvCNW7sR5JeSwwQUkQ/X/PPBcX5XA9iabgsyBbPFuFYLPT4vSVjqxk8TfDjWQzeXJya0NH1UUYOE9+C3ef1olz7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDiGph52; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDiGph52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667D31F000E9;
	Thu,  2 Jul 2026 16:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011301;
	bh=r7/DTDhUdCdVCnFQELAtUHKMRye6XGymPukPhysWmOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDiGph52SLyWQbPAzaB6Lz9MxpaowkXvfsoLhvUwjkG88fW07OXABanSWjc4DumXN
	 Px5DLnf05gwBm5vpop4ntHyIBbuO9dEZc969H5vb+CAQzMxhsdaJIXIX2gRTgRJfEK
	 owOHCnI8VC9HdvleZm4xbrfIfdBR2mKEQpdHQzf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Junjie Cao <junjie.cao@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.18 058/108] wifi: iwlwifi: mld: fix race condition in PTP removal
Date: Thu,  2 Jul 2026 18:20:55 +0200
Message-ID: <20260702155113.310621551@linuxfoundation.org>
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
@@ -319,10 +319,10 @@ void iwl_mld_ptp_remove(struct iwl_mld *
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


