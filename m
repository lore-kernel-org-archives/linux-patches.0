Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A0A275B1D;
	Wed, 30 Jul 2025 09:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868345; cv=none; b=NQc/A3cKDron1i85X8B6MJvpIG6VSzB1OyNsJlZvW8ugd1cCEVI5IFWLhJSLX+vQdqMwG1lfreDrafFc+VXJeSJLwbBTSAGVlNREevvT4MiLI8toKVW9ncfVhLYwHpUezif83yg0gXQ0U5H1tMgfK/vwp4pcXOWTFYfsjtFCDcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868345; c=relaxed/simple;
	bh=OJ874T+X9rbciREKHTxlidDhjDLn01MgaN4LemkWiqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jev52CjeyuIbdW89D4JRr6GrPkCLu3pXwgb+H0fnqqlJp3I/h4OTIpyJUlmqyf9gbA/Y3bSIquH9PvZtNEm/B3X4S9xDG0OdXBDVj72ScCjzitlL+moaB+u4psoy+fNrUMAwnWZZq/nJK5NQF+qi+Yj3zSl4FA+czmEijLNBSMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZTk0aOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZTk0aOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F8EC4CEE7;
	Wed, 30 Jul 2025 09:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868344;
	bh=OJ874T+X9rbciREKHTxlidDhjDLn01MgaN4LemkWiqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZTk0aOgmLOELjhY6Y5Zg6ovFHhMvE8CL/y6T8lUPrmMz5yWeYnLxZ4wNFgGDBgZ6
	 iEOfo30jVLzL7j8b26M5VW3wQgri2AMbCcB4Kb3HKHdQG6pdiBw1gFkmOWbXF0zBcT
	 w9nSeUY/rGaaJGgqTGTUPdp/WFS2FYpZaR3K9ZWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.6 41/76] ice: Fix a null pointer dereference in ice_copy_and_init_pkg()
Date: Wed, 30 Jul 2025 11:35:34 +0200
Message-ID: <20250730093228.428411677@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 4ff12d82dac119b4b99b5a78b5af3bf2474c0a36 upstream.

Add check for the return value of devm_kmemdup()
to prevent potential null pointer dereference.

Fixes: c76488109616 ("ice: Implement Dynamic Device Personalization (DDP) download")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_ddp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/intel/ice/ice_ddp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ddp.c
@@ -1884,6 +1884,8 @@ enum ice_ddp_state ice_copy_and_init_pkg
 		return ICE_DDP_PKG_ERR;
 
 	buf_copy = devm_kmemdup(ice_hw_to_dev(hw), buf, len, GFP_KERNEL);
+	if (!buf_copy)
+		return ICE_DDP_PKG_ERR;
 
 	state = ice_init_pkg(hw, buf_copy, len);
 	if (!ice_is_init_pkg_successful(state)) {


