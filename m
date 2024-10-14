Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2A31A28C;
	Mon, 14 Oct 2024 14:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916562; cv=none; b=K+mxTVInfrZsj3rJBCknpMgjBOSshBIKmVI4yR2jBtqTk35Qc/2DO2adXNUmMTZve7axcx0w0ECR6XNw4aLkZQi4AdJ7fmptFqZ+zeCgPdIIg1C+DR06km58NgvFU40uEg03X8VHYudrhDPnfzq8DCR137r3MTbXpuEFkTAUY4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916562; c=relaxed/simple;
	bh=0CUtIHbsIBU1WMSA0GIDpablTuk6lEOzJcT2c+fVC/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frHuMYTQuZYl6tK9VHeuhfMB3l6iH7xsP9kKTtJ34YAQNGhcZ/bkU5xtiA3ZniEH7JcQ6gvZnMc20PiJIIlHCBxHjEN14jn1u/5or5HbBCyb+zmOr+TuUbBEXsxsn4cbS9FKS/1nBQ4eG2d/9efbwIdnkN3els9smCKDJHItZg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uv1k/2iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uv1k/2iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6181DC4CEC3;
	Mon, 14 Oct 2024 14:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916561;
	bh=0CUtIHbsIBU1WMSA0GIDpablTuk6lEOzJcT2c+fVC/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uv1k/2iys4ESyZAZuitxUofkLslWzQc4jcAjT8TQ//5uzGnRYzxrQwjuw4aRcy63p
	 sFj16nSQk3aJMTfdo8p8bofuARGiZpbgk0lJcMrh6PvwtOrxX5/UZylmQ2ZOwBVP4w
	 ev1yY7C7N4pOLA4DhhykL6V6yK5+ZX/eNPVGI8s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@outlook.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.11 200/214] ice: Fix improper handling of refcount in ice_dpll_init_rclk_pins()
Date: Mon, 14 Oct 2024 16:21:03 +0200
Message-ID: <20241014141052.780047570@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@outlook.com>

commit ccca30a18e36a742e606d5bf0630e75be7711d0a upstream.

This patch addresses a reference count handling issue in the
ice_dpll_init_rclk_pins() function. The function calls ice_dpll_get_pins(),
which increments the reference count of the relevant resources. However,
if the condition WARN_ON((!vsi || !vsi->netdev)) is met, the function
currently returns an error without properly releasing the resources
acquired by ice_dpll_get_pins(), leading to a reference count leak.

To resolve this, the check has been moved to the top of the function. This
ensures that the function verifies the state before any resources are
acquired, avoiding the need for additional resource management in the
error path.

This bug was identified by an experimental static analysis tool developed
by our team. The tool specializes in analyzing reference count operations
and detecting potential issues where resources are not properly managed.
In this case, the tool flagged the missing release operation as a
potential problem, which led to the development of this patch.

Fixes: d7999f5ea64b ("ice: implement dpll interface to control cgu")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <hanguidong02@outlook.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -1628,6 +1628,8 @@ ice_dpll_init_rclk_pins(struct ice_pf *p
 	struct dpll_pin *parent;
 	int ret, i;
 
+	if (WARN_ON((!vsi || !vsi->netdev)))
+		return -EINVAL;
 	ret = ice_dpll_get_pins(pf, pin, start_idx, ICE_DPLL_RCLK_NUM_PER_PF,
 				pf->dplls.clock_id);
 	if (ret)
@@ -1643,8 +1645,6 @@ ice_dpll_init_rclk_pins(struct ice_pf *p
 		if (ret)
 			goto unregister_pins;
 	}
-	if (WARN_ON((!vsi || !vsi->netdev)))
-		return -EINVAL;
 	dpll_netdev_pin_set(vsi->netdev, pf->dplls.rclk.pin);
 
 	return 0;


