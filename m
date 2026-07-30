Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F62936493F;
	Thu, 30 Jul 2026 14:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423135; cv=none; b=WuPyj6+1pGp1QILf/8mu38+is5NgODnNgFjm/8R+k01Wew0uXergHVNlpNzYTxR9b1KQUVFUSANAVYT2m5WpIbx12JwTOiQjk0J9K3fSRVTGoeQ0VkkIw6vexPa+bnYB6bgyokd7qByDv42v75UAf2ec8DboGcoEXPgRMOrCVTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423135; c=relaxed/simple;
	bh=DmZp49WGlcVsic9pkjoybG5JlhGYNVue7c4w68GjhIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZQrYfvSar6HgQROPgXrBgzkPK5B+onuxfm7IyA7gUQnTF68MkQLnUBYpHye8RdxvPkrlZZQGihE39Xb62JCHr1X+zppwYA5ijSmI0Ts1v6QUdxdGrGSAt/FK99+9r23cTV8Vnq0X/MYl8xZzZkmygWppEsE3JJzu/xgZcrxpUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAdf0hEe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAdf0hEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834601F000E9;
	Thu, 30 Jul 2026 14:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423134;
	bh=awlJjFvhqwvmL6qeqSKGoLx23RAdqwhplHGWD9zxOko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NAdf0hEeANcX7goqoszKCfxsV/W3/61nam9QSkFVWQhWqZ4+VQQIRAM2EXndvbxOR
	 nv6CGf3h1k0wTixHBBqBzDs66XF/QUXfqer688tBGSEYU7S+cr+ahvek/hChYBKT+C
	 5ZlXNxuSD/phdPaz5H4gve1GVfxE0lu8/pUFO//w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Temerkhanov <sergey.temerkhanov@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 7.1 677/744] ice: use READ_ONCE() to access cached PHC time
Date: Thu, 30 Jul 2026 16:15:50 +0200
Message-ID: <20260730141458.652916797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Sergey Temerkhanov <sergey.temerkhanov@intel.com>

commit 2915681b89f817677ab9f1166d95b595bc144f5f upstream.

ptp.cached_phc_time is a 64-bit value updated by a periodic work item
on one CPU and read locklessly on another.  On 32-bit or non-atomic
architectures this can result in a torn read.  Use READ_ONCE() to
enforce a single atomic load.

Fixes: 77a781155a65 ("ice: enable receive hardware timestamping")
Cc: stable@vger.kernel.org
Signed-off-by: Sergey Temerkhanov <sergey.temerkhanov@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260717185340.3595286-9-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -350,7 +350,7 @@ static u64 ice_ptp_extend_40b_ts(struct
 		return 0;
 	}
 
-	return ice_ptp_extend_32b_ts(pf->ptp.cached_phc_time,
+	return ice_ptp_extend_32b_ts(READ_ONCE(pf->ptp.cached_phc_time),
 				     (in_tstamp >> 8) & mask);
 }
 


