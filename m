Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354CA14AD0D;
	Thu, 23 May 2024 13:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470435; cv=none; b=g4IZYEKHrsglEjoGXqgXuEE8+bjEOgzwUFsC1XmxfuIcDHY1oNic+F1HbPczngJcay4p3QQA9J8DFIABpRQAAYZYLP290zstKhAH0rfH5jO8NxIdWdNgNahps6MjnrDWQz6AeaSszO83ZE3zF+F+1fkkAPqOXB4jpIpG8L2Ydok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470435; c=relaxed/simple;
	bh=9sN5wR37VHpQXrXKDtZtL9dkb5ht3INBCzcyQNar43U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGvS7R+KzspYTzTwyar598P5mh9CeTR+pG7u+orhpIrKiC3aAnDcj9TjM6BwPCewf5b10gO+ctejhJpN6cr7Ih37AxeD0xR5JKfU/IWBnv4p2XW7+6FCAye1UKt6Jtha7SJwbejt8UZnaIDP/LyqPbOqgMvjEgHVLYeubeQAqpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msjRd6PM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msjRd6PM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCB2C32786;
	Thu, 23 May 2024 13:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470435;
	bh=9sN5wR37VHpQXrXKDtZtL9dkb5ht3INBCzcyQNar43U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=msjRd6PMfiYiU0jF5wSi5E8LxAf328h6iAlRrRXTraxsIMOJ5aOjMI8+FCtKcSDMn
	 EjxlRr8qcRR7XvcsVQHmlAynkKq8PedakQsV3d3rpZp54MDd05tHW6VdJNgIb5Nlju
	 c0L3Sdd1eeAhsfzt2BHV+jlq9qYVJYQ5Ni2nP2jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.1 04/45] ice: remove unnecessary duplicate checks for VF VSI ID
Date: Thu, 23 May 2024 15:12:55 +0200
Message-ID: <20240523130332.667690287@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


