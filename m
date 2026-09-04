Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846A14156E9;
	Fri,  4 Sep 2026 05:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501493; cv=none; b=flALNakfKajifHIgImrtdHX9mXGk1jwYy3hTR84me7F2+n/FNrDRZmTbw6ALNjxZy/jZWNoVMzyddc53PnTTs4w4VyIVXs5hqo+4LPshz3dysj/NBlihLJobN7tIx51sHOYJg1XhkYJALPJDUUen+Gz0+zZ67/0EW7ICC1ILyBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501493; c=relaxed/simple;
	bh=iDSmxvO4OV6Yoaw/OYnIJSvrtXeOM5EvgJfXMN2bAbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kvMWNTKKmVN42tjBN2lvbTURTKaGqYMiWf4xfgMoE1e8yTKSQNYJtZ1U2xEoixwYrnyDpIGiM31c5Ql3+x1uSH4z/D8D9dWwnWIFmK73CRFKCzrHuG7S3dqkG1fpJhrQ3jr/V5ZNFuZaIYnuKK2RvPdC7cfEAc9i1iB8L60U9dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypXDjcVv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypXDjcVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F431F00A3D;
	Fri,  4 Sep 2026 05:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501492;
	bh=2OBauromIr5kIXAWVvwI+VoT5u7/bgFhO5ryxJ+wqVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypXDjcVvXHdL4AqjyAm/CxL9Eh1xMdeX+tCNOnmmElfz/jaIEuhrZZVQaKX61YoDO
	 /6uHt2iTPMu+bEp6qTgk+cC9QnyK38SdgSun7nKPwDPr3P+ysAtmoHszDTX6QClBkQ
	 Wu8juKikgyatXBPqnSZjZEF/G2veQnQqZKGTPhVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 428/552] platform/x86: think-lmi: Free system certificate signatures
Date: Fri,  4 Sep 2026 06:59:45 +0200
Message-ID: <20260904045800.302169240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1458,6 +1458,10 @@ static void tlmi_release_attr(void)
 	/* Free up any saved signatures */
 	kfree(tlmi_priv.pwd_admin->signature);
 	kfree(tlmi_priv.pwd_admin->save_signature);
+	if (tlmi_priv.pwd_system) {
+		kfree(tlmi_priv.pwd_system->signature);
+		kfree(tlmi_priv.pwd_system->save_signature);
+	}
 
 	/* Authentication structures */
 	list_for_each_entry_safe(pos, n, &tlmi_priv.authentication_kset->list, entry)


