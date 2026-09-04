Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CBF347532;
	Fri,  4 Sep 2026 05:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499871; cv=none; b=R/GqZ7HNSIzY8YbpG0n6RHuzX3L//WMWgyga9wx3fktMEtx1mfCmvQai7BNy3Dub5ErGIyMoFIDJLslF077We9jJd+pyV4aou179+tssEDZ46KENcVNQL2Rh8xVZFOTAAhYZ2PfbiRoYv8OnAeqF5avYSuzBRtTVR/aPAwtV5Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499871; c=relaxed/simple;
	bh=75kfcGn9lf1q7COIpbSiZcWWXyBumfxIA1XcdqGoegc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jLM74B4Qf+JyKaQapjUtZObAbTRBT0HvFJdq7T5F9b4v1IY/Lj8dtuqaDjUC7eexgc2smJth4Ufl0mGrek9M3W0I4OzDai32pMlG9RdVsl8JlpZlq7+qbSS8KYtmCZKUchBF0tATaM+IidaaOAeS04/r55gg3RBy/+2mIdyqP1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwT27W/Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwT27W/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136071F00A3D;
	Fri,  4 Sep 2026 05:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499870;
	bh=yLdDc6EgRMJwts8NozGhz2BHLdqv6YA5jWbH39WCK5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uwT27W/Y9SEg1mfWpUZHA37xy5w4Na90XnF/44ceDmK4ssVzsA2Fl6m9+Ul2/1xDb
	 fWxfnZPIki+Zvnhu4Se32p0tMtX+62ukEEnssyeimu/wG3N1vL2nCCNXae3K34hQ0l
	 KUdJhRVv3IPjD9GxJTVhX+xHZBPvXU9y+ogP0fSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.2 569/713] platform/x86: think-lmi: Free system certificate signatures
Date: Fri,  4 Sep 2026 06:58:57 +0200
Message-ID: <20260904045816.573344931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit abca989604f60fe29d7170431f819e28ec7d868a upstream.

Multi-certificate support also allows the system authentication object
to store ->signature and ->save_signature, which leak when the driver is
removed. Free the signatures to avoid leaking memory.

Fixes: 5dcb5ef12590 ("platform/x86: think-lmi: Multi-certificate support")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://patch.msgid.link/20260810204106.165895-2-thorsten.blum@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/lenovo/think-lmi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/platform/x86/lenovo/think-lmi.c
+++ b/drivers/platform/x86/lenovo/think-lmi.c
@@ -1462,6 +1462,10 @@ static void tlmi_release_attr(void)
 	/* Free up any saved signatures */
 	kfree(tlmi_priv.pwd_admin->signature);
 	kfree(tlmi_priv.pwd_admin->save_signature);
+	if (tlmi_priv.pwd_system) {
+		kfree(tlmi_priv.pwd_system->signature);
+		kfree(tlmi_priv.pwd_system->save_signature);
+	}
 
 	/* Authentication structures */
 	list_for_each_entry_safe(pos, n, &tlmi_priv.authentication_kset->list, entry)


