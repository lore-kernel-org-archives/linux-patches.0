Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2749D82C60;
	Tue, 29 Apr 2025 17:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947287; cv=none; b=lnDee97RbFk2Z/ZhoKHGdr3l3Xvt9ARMaCBfsZOgxI5fo5DvnQKTV3LnfP2vinCEPluk0OZo9YZw5p2vlTbqja7oWViEpkV4UymXh0ftIagCY9pdURbQC2JqQAg6Az87F5fj+GS9cweBFiY/NTPDDEOh+eFTTQP8UR2/u737nAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947287; c=relaxed/simple;
	bh=EDPWvSE0UWghsvgVN3LgiZq60bb230qKfdOAlVVRD8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5PAzpjJZI69uxQLCC3ennirJ0IB2j3f4+GDtMVcJUIbG93sX+nJpEBANkzTtNTBEbqaIY0hhqHqlkASeNXqJMp+oXeGwNztl/BlxxbS3TuwZoglEdbuYxR5VRbHKCabOoZE+d8hJM9tBIcYgjEuw4DEUKBl+KLMqLpFRa9GHVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MjLdLCDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MjLdLCDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFE1C4CEE3;
	Tue, 29 Apr 2025 17:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947287;
	bh=EDPWvSE0UWghsvgVN3LgiZq60bb230qKfdOAlVVRD8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MjLdLCDSYvV8efSzf5/fvCFKkxwro8zMc7MwEdKLOcC6fh7Pv2mbIfEjUPdf2xCfy
	 7/9MieFftJni0e7sYT7f0+nCFwnvrMsXgDyQGPEtxTQ+Nme/hVcx/XARkO3Gye8Dd+
	 wjew6973eVKeTwOulnyZ6TuYRIs4okyKlOEC0C7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.10 193/286] drivers: staging: rtl8723bs: Fix locking in rtw_scan_timeout_handler()
Date: Tue, 29 Apr 2025 18:41:37 +0200
Message-ID: <20250429161115.906554220@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 3f467036093fedd7e231924327455fc609b5ef02 upstream.

Commit cc7ad0d77b51 ("drivers: staging: rtl8723bs: Fix deadlock in
rtw_surveydone_event_callback()") besides fixing the deadlock also
modified rtw_scan_timeout_handler() to use spin_[un]lock_irq()
instead of spin_[un]lock_bh().

Disabling the IRQs is not necessary since all code taking this lock
runs from either user contexts or from softirqs

rtw_scan_timeout_handler() is the only function taking pmlmepriv->lock
which uses spin_[un]lock_irq() for this. Switch back to
spin_[un]lock_bh() to make it consistent with the rest of the code.

Fixes: cc7ad0d77b51 ("drivers: staging: rtl8723bs: Fix deadlock in rtw_surveydone_event_callback()")
Cc: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230221145326.7808-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -1755,11 +1755,11 @@ void rtw_scan_timeout_handler(struct tim
 
 	DBG_871X(FUNC_ADPT_FMT" fw_state =%x\n", FUNC_ADPT_ARG(adapter), get_fwstate(pmlmepriv));
 
-	spin_lock_irq(&pmlmepriv->lock);
+	spin_lock_bh(&pmlmepriv->lock);
 
 	_clr_fwstate_(pmlmepriv, _FW_UNDER_SURVEY);
 
-	spin_unlock_irq(&pmlmepriv->lock);
+	spin_unlock_bh(&pmlmepriv->lock);
 
 	rtw_indicate_scan_done(adapter, true);
 }


