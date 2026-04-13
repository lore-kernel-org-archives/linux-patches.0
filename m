Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264A732570D;
	Mon, 13 Apr 2026 17:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099819; cv=none; b=f4wA0oG+KTUOuIKyHpPsh2IWM67uObi7AVlyjFc7TC/0EDPn4ekYGOT/8fcuYeJBle9nnXqKZkmqlUcvJiF2CgPiVeqooZA8IsL+P0Msi2+7Qq+bhCT/J/vjPYwQXanvx/xEco/ZLJZ0hi3ki4EoJ/2XVm2CevlLyi9dxOa3QTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099819; c=relaxed/simple;
	bh=PSeBGNBihjABkeqxhQ4LZC+WRxjLIzgKAOAcxsDcWto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P45s097PZLpGHfU0QO6lbDoMDOFSgNrBM4HoxUgUMROhlJz2CBNHBQZdVaWQxUmYJRlKOSONcI649xUf0tfaviX5wAP5OipFJuWpRPbIXnt3FwHtNdLWb302Fqd9vXSvD2XZTswzP13hHlzagYjlEbk/jvZCh3rlz75prLkRbzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0F6EpWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0F6EpWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B02C2BCAF;
	Mon, 13 Apr 2026 17:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099818;
	bh=PSeBGNBihjABkeqxhQ4LZC+WRxjLIzgKAOAcxsDcWto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0F6EpWBZ6CC7zgg+NGjV/VB9wRj13hYCUpCuFgHY+T7NfXhjSZr/SJlE6HReV/J9
	 WE7OQHf7GCa2fTumOKEJTxTaOpnjblKnfnIzwpeZV7KohxBl+USBKlIW+PO0NNniqN
	 ZbH2qc84qhyB0ikUtX5zdlHLmZmFDgCat22iF2dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Daniel Scally <djrscally@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 484/491] device property: Check fwnode->secondary when finding properties
Date: Mon, 13 Apr 2026 18:02:09 +0200
Message-ID: <20260413155837.174825318@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Scally <djrscally@gmail.com>

[ Upstream commit c097af1d0a8483b44fa30e86b311991d76b6ae67 ]

fwnode_property_get_reference_args() searches for named properties
against a fwnode_handle, but these could instead be against the fwnode's
secondary. If the property isn't found against the primary, check the
secondary to see if it's there instead.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Daniel Scally <djrscally@gmail.com>
Link: https://lore.kernel.org/r/20211128232455.39332-1-djrscally@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 2692c614f8f0 ("device property: Allow secondary lookup in fwnode_get_next_child_node()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/property.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -479,8 +479,17 @@ int fwnode_property_get_reference_args(c
 				       unsigned int nargs, unsigned int index,
 				       struct fwnode_reference_args *args)
 {
-	return fwnode_call_int_op(fwnode, get_reference_args, prop, nargs_prop,
-				  nargs, index, args);
+	int ret;
+
+	ret = fwnode_call_int_op(fwnode, get_reference_args, prop, nargs_prop,
+				 nargs, index, args);
+
+	if (ret < 0 && !IS_ERR_OR_NULL(fwnode) &&
+	    !IS_ERR_OR_NULL(fwnode->secondary))
+		ret = fwnode_call_int_op(fwnode->secondary, get_reference_args,
+					 prop, nargs_prop, nargs, index, args);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(fwnode_property_get_reference_args);
 


