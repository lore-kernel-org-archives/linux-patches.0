Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31D7358373;
	Thu, 30 Jul 2026 15:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426525; cv=none; b=cUHoI3CSLBseKuRGCXv2oj/wGO7CBhrqh4C532mbQ6TZ2xYyFDMlYPBbqKQ42G9DzsyexKVKIUdyCdkK30XU0rmdTN22f+EzobTpVNcO/FU0Ngz06+ijS4qBBDHROkw+IeZl5ZlTvN8xAJmt+0c4qW5FQ2Q9prTU9/1pg8AzYPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426525; c=relaxed/simple;
	bh=R8c2DTklYIzTedQUxYV9rqKV1VVD2XZkHqgSpTKxFOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THnhfbZazc3A0ewCY/CYTzOOqr1h7G/A+TAyHdTfwlR5j3rKaU2cMwtPISTqUF15BjToGcGowYFNlM9htONXwodqjZ9+PeB7jjE8pBmWXmdfUWe0Kwl/Uct96zU4FSO+NRQq6AFC79eDUhVfIh5/PYE7iTqmEhUfIFHrn8zC4Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzyGlnGw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzyGlnGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286C21F000E9;
	Thu, 30 Jul 2026 15:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426524;
	bh=T1L419KHEk7RrcQRrKsAqCqKapa8NIg2nN59TXumH4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WzyGlnGwDdZ1ZOHQegZL+PbUbtZoSmNryCOvK9kL8t9jOgCo/8x1IY8KAyNaqtNDf
	 Ep/gP7ciknPl3s2vUbHYFfKEgVR7wk9c5aBhENQX5S1/4LxEAICbYBzbYTcjgKQURz
	 LjAROE3MKwlAexav9LoBwS4riBuW+s5Ra07/4w8E=
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
Subject: [PATCH 6.12 423/602] ice: use READ_ONCE() to access cached PHC time
Date: Thu, 30 Jul 2026 16:13:35 +0200
Message-ID: <20260730141444.854040705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
@@ -514,7 +514,7 @@ static u64 ice_ptp_extend_40b_ts(struct
 		return 0;
 	}
 
-	return ice_ptp_extend_32b_ts(pf->ptp.cached_phc_time,
+	return ice_ptp_extend_32b_ts(READ_ONCE(pf->ptp.cached_phc_time),
 				     (in_tstamp >> 8) & mask);
 }
 


