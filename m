Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD853FF1BE;
	Fri, 15 May 2026 15:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860639; cv=none; b=HO+6rIKMvj64puS0YVar0wo4rXbkmkG29uljGgtFBwHKBz7BcBl/k9opvgcXfYa2kBSpEuieVPd9Xc2rHdfFZcRBKsrGCoxmIIMCN6EcngetW3DqJRNTDG077Y2Rozs/UF7g7h5CbQBUJkMGjyxLxJHXd8QWMuRrsSVqMewshDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860639; c=relaxed/simple;
	bh=SpReF6MLl76F4wJXUOVwUh0SICkF9VtE8dT/cjwrpVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckGXV/7DEP1j3JI2jdPrjtbW+n30t4J/hWciKy1UJoBVWfCogum9/bCXsBp712vYTGFq2Om6iHulqwqi56oQbINjFG8r805IwubAxQURLP6iJRL/V6Kqv/gWAAhGIwFiKehQYmbsj4Nk1EWzfPP/MEIqGziVvP9fiowmUIbECnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xnuogeu2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xnuogeu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E90C2BCB0;
	Fri, 15 May 2026 15:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860639;
	bh=SpReF6MLl76F4wJXUOVwUh0SICkF9VtE8dT/cjwrpVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xnuogeu2KK7VkoYnxGpt0bE3Dme8OSFexBPJ0irQf031fskEqXfNc55VCWWkfYLu/
	 C+cHVuraMYYb4eYHoZvK9s5OzDVPm/oIFVyBKxetILnfjqrHuyeyS+Ki3zRiytUUrf
	 /0XUfWl4fySsOE2uuS3lMi3iib0Zjro6226C2qV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Jun Li <jun.li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.6 005/474] usb: chipidea: otg: not wait vbus drop if use role_switch
Date: Fri, 15 May 2026 17:41:54 +0200
Message-ID: <20260515154715.171690334@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit a4e99587102a83ee911c670752fbca694c7e557f upstream.

The usb role switch will update ID and VBUS states at the same time, and
vbus will not drop when execute data role swap in Type-C usecase. So lets
not wait vbus drop in usb role switch case too.

Fixes: e1b5d2bed67c ("usb: chipidea: core: handle usb role switch in a common way")
Cc: stable@vger.kernel.org
Acked-by: Peter Chen <peter.chen@kernel.org>
Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20260402071457.2516021-3-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/otg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/chipidea/otg.c
+++ b/drivers/usb/chipidea/otg.c
@@ -187,8 +187,8 @@ void ci_handle_id_switch(struct ci_hdrc
 
 		ci_role_stop(ci);
 
-		if (role == CI_ROLE_GADGET &&
-				IS_ERR(ci->platdata->vbus_extcon.edev))
+		if (role == CI_ROLE_GADGET && !ci->role_switch &&
+		    IS_ERR(ci->platdata->vbus_extcon.edev))
 			/*
 			 * Wait vbus lower than OTGSC_BSV before connecting
 			 * to host. If connecting status is from an external


