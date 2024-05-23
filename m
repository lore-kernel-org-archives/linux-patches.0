Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83CC14830E;
	Thu, 23 May 2024 13:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470769; cv=none; b=nDZOjRe5SLSQVPczRcq0DFkx2Dst0qoWrQyrnJVriXhrxz9CfkkvszpZggJuKWHi0Y6Ohg/DmWcOeWxLM0wRmxgTOndrhzRbUHWuOHyaXXeYCtcahxgHnuQXyDwcV1FiEzYAl7PdMSLXm827LjfTp5XRXa8GzBUERCxxTYEIFqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470769; c=relaxed/simple;
	bh=DYJPnitqFkwL8ZIlAMs7u3V8/rg9YrdHl//hA+CNg6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nt6GY5jFXSbdjDCUDj/ccQCqblhRVEDzd1o0Wf23mYdc22XpaPp16j5YX6Qcy+N/Mg3JCOolj9CRHHWDNJ12j/kR9/oO2Z63sbA+FBhUnff268hxY7I299QFSh40iqaZHokDK/JbvIjQQGk1r69KxMDtVRIn7cyr3GWOIsRqfgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dArYzWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dArYzWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29426C2BD10;
	Thu, 23 May 2024 13:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470769;
	bh=DYJPnitqFkwL8ZIlAMs7u3V8/rg9YrdHl//hA+CNg6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2dArYzWmXo7qscFXBWty7yqY51r+tWAHkqiw4IUYvbxyAWsL35w6dDOJd2usb1b4n
	 /L3KnItliLUN3HbZXavoMAvBCtXdYFJR6aHEHAklkOA6vWcyDUZY1xADODdFq0awTT
	 gldJmpTxn88L90ggzExOt1lzCDVHrGC5mgSpTRcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.6 080/102] ice: remove unnecessary duplicate checks for VF VSI ID
Date: Thu, 23 May 2024 15:13:45 +0200
Message-ID: <20240523130345.484792007@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jacob Keller <jacob.e.keller@intel.com>

commit 363f689600dd010703ce6391bcfc729a97d21840 upstream.

The ice_vc_fdir_param_check() function validates that the VSI ID of the
virtchnl flow director command matches the VSI number of the VF. This is
already checked by the call to ice_vc_isvalid_vsi_id() immediately
following this.

This check is unnecessary since ice_vc_isvalid_vsi_id() already confirms
this by checking that the VSI ID can locate the VSI associated with the VF
structure.

Furthermore, a following change is going to refactor the ice driver to
report VSI IDs using a relative index for each VF instead of reporting the
PF VSI number. This additional check would break that logic since it
enforces that the VSI ID matches the VSI number.

Since this check duplicates  the logic in ice_vc_isvalid_vsi_id() and gets
in the way of refactoring that logic, remove it.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -107,9 +107,6 @@ ice_vc_fdir_param_check(struct ice_vf *v
 	if (!(vf->driver_caps & VIRTCHNL_VF_OFFLOAD_FDIR_PF))
 		return -EINVAL;
 
-	if (vsi_id != vf->lan_vsi_num)
-		return -EINVAL;
-
 	if (!ice_vc_isvalid_vsi_id(vf, vsi_id))
 		return -EINVAL;
 


