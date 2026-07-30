Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B724E3AA187;
	Thu, 30 Jul 2026 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425020; cv=none; b=fdCtQ/bbJsN+6lFkItGPCgX+so3tY1EK0xYtpuX3WymAYtRkya+fPa9joA+SZ3cjUkSSue21koINhr2rO4f/WgiTaZq/1BVIjw5PPZZetQUM08bnX5Mqu28puMcJ791tIODPhsh5oJo2KcagwuE4L68Siu9YnuQjQiQwPd5qPpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425020; c=relaxed/simple;
	bh=9XRnUV7hSQo3ILt51ih+sfwC6OhoscWK0iCujXFph+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqwGX7iYGi7de33RKqli4vvYqvYoViO2FeoR/5W5dAeI0R1pfiTXsb0UfwphALqLkuh13fhEf4T1IeNqIfG2396SR8zvKNBiKbZ3JiH6FWvi1LPZezMScMQBd/pNwePPHi+V4BADmwZJqdTmDaECwcjrnfe63Bd1xba7aaT8y3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5h0lOdA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5h0lOdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC9E1F000E9;
	Thu, 30 Jul 2026 15:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425019;
	bh=WYTNTaLBw8rMhVQm/rOVxphiQf4GQCrqI7OU7EG4UfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v5h0lOdA/KfyGOt8OLO3Q+M0TpQ0mLV1S9+MQOFjPfXmb3Htk82W/e0Xj5cWYY808
	 FkOKvoGUbLlPH/CYd/pQ0l1+TA8DVhCbCuAQ/FSdq8pEk8vptArIjMoO3XSrhSR7om
	 dN8WnIM1+6i775GNbCuzbXwcvksunRDRwXXOIOBQ=
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
Subject: [PATCH 6.18 554/675] ice: use READ_ONCE() to access cached PHC time
Date: Thu, 30 Jul 2026 16:14:44 +0200
Message-ID: <20260730141456.911562760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
 


